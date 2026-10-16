import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_filter.dart';
import '../../domain/entities/sync_summary.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/simulated_remote_datasource.dart';
import '../mappers/note_mapper.dart';

class DriftNotesRepository implements NotesRepository {
  final AppDatabase _db;
  final SimulatedRemoteDataSource _remote;
  final Uuid _uuid = const Uuid();

  DriftNotesRepository({
    required AppDatabase db,
    required SimulatedRemoteDataSource remote,
  })  : _db = db,
        _remote = remote;

  @override
  Future<List<NoteEntity>> fetchNotesPage({
    required NoteQueryFilter filter,
    required int limit,
    required int offset,
  }) async {
    final rows = await _db.queryPaginatedNotes(
      filter: filter,
      limit: limit,
      offset: offset,
    );
    return rows.map(NoteMapper.toDomain).toList();
  }

  @override
  Stream<OutboxStatusCounts> watchOutboxCounts() {
    return _db.watchOutboxTelemetry();
  }

  @override
  Future<NoteEntity> saveNoteLocally({
    String? id,
    required String title,
    required String content,
    required String category,
    bool isPinned = false,
  }) async {
    final now = DateTime.now().toUtc();
    final noteId = id ?? _uuid.v4();

    final existing = await (_db.select(_db.notesTable)
          ..where((t) => t.id.equals(noteId)))
        .getSingleOrNull();

    final nextLocalVersion = (existing?.localVersion ?? 0) + 1;
    final currentBaseVersion = existing?.baseVersion ?? 0;

    final companion = NotesTableCompanion(
      id: Value(noteId),
      title: Value(title.trim()),
      content: Value(content.trim()),
      category: Value(category),
      isPinned: Value(isPinned),
      syncState: const Value(SyncState.pendingPush),
      baseVersion: Value(currentBaseVersion),
      localVersion: Value(nextLocalVersion),
      updatedAtUtc: Value(now),
    );

    await _db.into(_db.notesTable).insertOnConflictUpdate(companion);

    final savedRow = await (_db.select(_db.notesTable)
          ..where((t) => t.id.equals(noteId)))
        .getSingle();
    return NoteMapper.toDomain(savedRow);
  }

  @override
  Future<void> deleteNoteLocally(String id) async {
    final existing = await (_db.select(_db.notesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (existing == null) return;

    // If never synced to server (baseVersion == 0), safe to hard-delete immediately
    if (existing.baseVersion == 0) {
      await (_db.delete(_db.notesTable)..where((t) => t.id.equals(id))).go();
      return;
    }

    // Otherwise mark as Tombstone (pendingDelete) so remote server is notified
    await (_db.update(_db.notesTable)..where((t) => t.id.equals(id))).write(
      NotesTableCompanion(
        syncState: const Value(SyncState.pendingDelete),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<SyncSummary> synchronize({
    required bool simulateConflictOnNextPush,
  }) async {
    final dirtyRows = await _db.getDirtyOutboxRows();
    int pushed = 0;
    int conflicts = 0;
    bool conflictInjectedOnce = false;

    for (final row in dirtyRows) {
      if (row.syncState == SyncState.pendingDelete) {
        await _remote.deleteNoteOnServer(row.id);
        await (_db.delete(_db.notesTable)..where((t) => t.id.equals(row.id)))
            .go();
        pushed++;
        continue;
      }

      final shouldInjectConflict =
          simulateConflictOnNextPush && !conflictInjectedOnce;
      if (shouldInjectConflict) conflictInjectedOnce = true;

      final result = await _remote.pushNote(
        id: row.id,
        title: row.title,
        content: row.content,
        category: row.category,
        isPinned: row.isPinned,
        clientBaseVersion: row.baseVersion,
        simulateDivergentServerEdit: shouldInjectConflict,
      );

      if (result.isConflict) {
        conflicts++;
        await (_db.update(_db.notesTable)..where((t) => t.id.equals(row.id)))
            .write(
          NotesTableCompanion(
            syncState: const Value(SyncState.conflicted),
            conflictedRemoteTitle: Value(result.serverRecord.title),
            conflictedRemoteContent: Value(result.serverRecord.content),
            conflictedRemoteVersion: Value(result.serverRecord.serverVersion),
          ),
        );
      } else {
        pushed++;
        await (_db.update(_db.notesTable)..where((t) => t.id.equals(row.id)))
            .write(
          NotesTableCompanion(
            syncState: const Value(SyncState.synced),
            baseVersion: Value(result.serverRecord.serverVersion),
            localVersion: Value(result.serverRecord.serverVersion),
            conflictedRemoteTitle: const Value(null),
            conflictedRemoteContent: const Value(null),
            conflictedRemoteVersion: const Value(null),
          ),
        );
      }
    }

    return SyncSummary(
      pushedCount: pushed,
      pulledCount: 0,
      conflictsDetected: conflicts,
      completedAtUtc: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> resolveConflict({
    required String noteId,
    required ConflictResolutionStrategy strategy,
  }) async {
    final row = await (_db.select(_db.notesTable)
          ..where((t) => t.id.equals(noteId)))
        .getSingleOrNull();

    if (row == null || row.syncState != SyncState.conflicted) return;

    final remoteVer = row.conflictedRemoteVersion ?? (row.baseVersion + 1);
    final now = DateTime.now().toUtc();

    switch (strategy) {
      case ConflictResolutionStrategy.acceptRemote:
        await (_db.update(_db.notesTable)..where((t) => t.id.equals(noteId)))
            .write(
          NotesTableCompanion(
            title: Value(row.conflictedRemoteTitle ?? row.title),
            content: Value(row.conflictedRemoteContent ?? row.content),
            syncState: const Value(SyncState.synced),
            baseVersion: Value(remoteVer),
            localVersion: Value(remoteVer),
            conflictedRemoteTitle: const Value(null),
            conflictedRemoteContent: const Value(null),
            conflictedRemoteVersion: const Value(null),
            updatedAtUtc: Value(now),
          ),
        );
        break;

      case ConflictResolutionStrategy.keepLocal:
        // Rebase local version onto the latest remote version and queue for push
        await (_db.update(_db.notesTable)..where((t) => t.id.equals(noteId)))
            .write(
          NotesTableCompanion(
            syncState: const Value(SyncState.pendingPush),
            baseVersion: Value(remoteVer),
            localVersion: Value(remoteVer + 1),
            conflictedRemoteTitle: const Value(null),
            conflictedRemoteContent: const Value(null),
            conflictedRemoteVersion: const Value(null),
            updatedAtUtc: Value(now),
          ),
        );
        break;

      case ConflictResolutionStrategy.mergeBoth:
        final mergedContent =
            '${row.content}\n\n=== MERGED REMOTE CHANGES (v$remoteVer) ===\n${row.conflictedRemoteContent ?? ""}';
        await (_db.update(_db.notesTable)..where((t) => t.id.equals(noteId)))
            .write(
          NotesTableCompanion(
            content: Value(mergedContent),
            syncState: const Value(SyncState.pendingPush),
            baseVersion: Value(remoteVer),
            localVersion: Value(remoteVer + 1),
            conflictedRemoteTitle: const Value(null),
            conflictedRemoteContent: const Value(null),
            conflictedRemoteVersion: const Value(null),
            updatedAtUtc: Value(now),
          ),
        );
        break;
    }
  }

  @override
  Future<void> seedDemoDataset() async {
    final categories = ['Architecture', 'Security', 'Performance', 'Incidents'];
    final now = DateTime.now().toUtc();

    await _db.batch((batch) {
      for (int i = 1; i <= 35; i++) {
        final category = categories[i % categories.length];
        batch.insert(
          _db.notesTable,
          NotesTableCompanion.insert(
            id: _uuid.v4(),
            title: 'Engineering Note #$i: $category Spec',
            content:
                'Offline-first persistence record #$i stored in SQLite via Drift. '
                'Supports indexed LIKE filtering, tombstone soft-deletes, and OCC version vectors.',
            category: Value(category),
            isPinned: Value(i <= 2),
            syncState: const Value(SyncState.pendingPush),
            baseVersion: const Value(1),
            localVersion: const Value(2),
            updatedAtUtc: now.subtract(Duration(minutes: i * 12)),
          ),
        );
      }
    });
  }
}
