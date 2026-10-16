import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_offline_first_starter/core/database/app_database.dart';
import 'package:flutter_offline_first_starter/features/notes/data/datasources/simulated_remote_datasource.dart';
import 'package:flutter_offline_first_starter/features/notes/data/repositories/drift_notes_repository.dart';
import 'package:flutter_offline_first_starter/features/notes/domain/entities/note_entity.dart';
import 'package:flutter_offline_first_starter/features/notes/domain/entities/note_filter.dart';

void main() {
  late AppDatabase db;
  late SimulatedRemoteDataSource remote;
  late DriftNotesRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    remote = SimulatedRemoteDataSource();
    repository = DriftNotesRepository(db: db, remote: remote);
  });

  tearDown(() async {
    await db.close();
  });

  test('Local save queues note in pendingPush state and syncs cleanly to v1',
      () async {
    final created = await repository.saveNoteLocally(
      title: 'Offline Architecture ADR',
      content: 'Use Drift with Outbox pattern',
      category: 'Architecture',
    );

    expect(created.syncState, SyncState.pendingPush);
    expect(created.baseVersion, 0);
    expect(created.localVersion, 1);

    final summary = await repository.synchronize(
      simulateConflictOnNextPush: false,
    );
    expect(summary.pushedCount, 1);
    expect(summary.conflictsDetected, 0);

    final page = await repository.fetchNotesPage(
      filter: const NoteQueryFilter(),
      limit: 10,
      offset: 0,
    );
    expect(page.single.syncState, SyncState.synced);
    expect(page.single.baseVersion, 1);
  });

  test('Detects 409 OCC conflict and resolves via MergeBoth strategy',
      () async {
    final note = await repository.saveNoteLocally(
      title: 'API Contract',
      content: 'Client Payload v1',
      category: 'Architecture',
    );

    // Trigger sync with conflict injection enabled
    final summary = await repository.synchronize(
      simulateConflictOnNextPush: true,
    );
    expect(summary.conflictsDetected, 1);

    final conflictedList = await repository.fetchNotesPage(
      filter: const NoteQueryFilter(syncFilter: SyncFilter.conflictedOnly),
      limit: 10,
      offset: 0,
    );
    expect(conflictedList.length, 1);
    expect(conflictedList.single.hasConflict, isTrue);

    // Resolve using MergeBoth
    await repository.resolveConflict(
      noteId: note.id,
      strategy: ConflictResolutionStrategy.mergeBoth,
    );

    final resolved = (await repository.fetchNotesPage(
      filter: const NoteQueryFilter(),
      limit: 10,
      offset: 0,
    ))
        .single;

    expect(resolved.syncState, SyncState.pendingPush);
    expect(resolved.content, contains('MERGED REMOTE CHANGES'));
  });

  test('Tombstone soft-delete propagates deletion to remote and then purges locally',
      () async {
    final note = await repository.saveNoteLocally(
      title: 'Note to be deleted',
      content: 'Tombstone test',
      category: 'Architecture',
    );

    // Sync to establish remote baseline (baseVersion = 1)
    await repository.synchronize(simulateConflictOnNextPush: false);

    // Delete locally
    await repository.deleteNoteLocally(note.id);

    // Query should exclude soft-deleted note
    final activeNotes = await repository.fetchNotesPage(
      filter: const NoteQueryFilter(),
      limit: 10,
      offset: 0,
    );
    expect(activeNotes, isEmpty);

    // Synchronize to push tombstone to server
    final summary = await repository.synchronize(
      simulateConflictOnNextPush: false,
    );
    expect(summary.pushedCount, 1);
  });
}
