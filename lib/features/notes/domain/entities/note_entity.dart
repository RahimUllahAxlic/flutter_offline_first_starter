enum SyncState {
  /// Local state matches the last known server revision.
  synced,

  /// Created or modified locally; queued in the Outbox for next push.
  pendingPush,

  /// Soft-deleted locally (Tombstone); queued to notify remote before hard purge.
  pendingDelete,

  /// Remote revision diverged from [baseVersion] while local changes were pending.
  conflicted,
}

enum ConflictResolutionStrategy {
  /// Overwrite remote with local payload and bump baseVersion.
  keepLocal,

  /// Discard local unpushed changes and adopt the server payload.
  acceptRemote,

  /// Combine both bodies into a unified note and push as a new revision.
  mergeBoth,
}

class NoteEntity {
  final String id;
  final String title;
  final String content;
  final String category;
  final bool isPinned;
  final SyncState syncState;

  /// The server revision this note was last synced against.
  final int baseVersion;

  /// Incremented on every local edit.
  final int localVersion;

  /// Populated when [syncState] == [SyncState.conflicted].
  final String? conflictedRemoteTitle;
  final String? conflictedRemoteContent;
  final int? conflictedRemoteVersion;

  final DateTime updatedAtUtc;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isPinned,
    required this.syncState,
    required this.baseVersion,
    required this.localVersion,
    this.conflictedRemoteTitle,
    this.conflictedRemoteContent,
    this.conflictedRemoteVersion,
    required this.updatedAtUtc,
  });

  bool get hasConflict => syncState == SyncState.conflicted;
}
