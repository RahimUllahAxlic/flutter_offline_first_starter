class SyncSummary {
  final int pushedCount;
  final int pulledCount;
  final int conflictsDetected;
  final DateTime completedAtUtc;

  const SyncSummary({
    required this.pushedCount,
    required this.pulledCount,
    required this.conflictsDetected,
    required this.completedAtUtc,
  });
}

class OutboxStatusCounts {
  final int syncedCount;
  final int pendingCount;
  final int conflictCount;

  const OutboxStatusCounts({
    this.syncedCount = 0,
    this.pendingCount = 0,
    this.conflictCount = 0,
  });
}
