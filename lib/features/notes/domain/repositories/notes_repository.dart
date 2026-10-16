import '../entities/note_entity.dart';
import '../entities/note_filter.dart';
import '../entities/sync_summary.dart';

abstract interface class NotesRepository {
  /// Fetches a paginated slice of notes directly from SQLite using indexed WHERE/LIMIT/OFFSET.
  Future<List<NoteEntity>> fetchNotesPage({
    required NoteQueryFilter filter,
    required int limit,
    required int offset,
  });

  /// Reactive stream of outbox & conflict counts for the telemetry header.
  Stream<OutboxStatusCounts> watchOutboxCounts();

  /// Local-first upsert. Immediately persists to SQLite and marks row as [SyncState.pendingPush].
  Future<NoteEntity> saveNoteLocally({
    String? id,
    required String title,
    required String content,
    required String category,
    bool isPinned = false,
  });

  /// Soft-deletes the note locally (Tombstone pattern) so the next sync cycle
  /// can propagate the deletion to the remote server before hard-deleting.
  Future<void> deleteNoteLocally(String id);

  /// Executes a bidirectional Outbox Push + Delta Pull sync cycle.
  Future<SyncSummary> synchronize({required bool simulateConflictOnNextPush});

  /// Resolves an Optimistic Concurrency Control (OCC) conflict.
  Future<void> resolveConflict({
    required String noteId,
    required ConflictResolutionStrategy strategy,
  });

  /// Seeds 40 realistic notes into SQLite to demonstrate instant search & pagination.
  Future<void> seedDemoDataset();
}
