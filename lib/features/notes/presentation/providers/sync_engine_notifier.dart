import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/core_providers.dart';
import '../../domain/entities/sync_summary.dart';
import 'paginated_notes_notifier.dart';

class SyncEngineState {
  final bool isSyncing;
  final bool injectConflictOnNextSync;
  final SyncSummary? lastSummary;

  const SyncEngineState({
    this.isSyncing = false,
    this.injectConflictOnNextSync = false,
    this.lastSummary,
  });

  SyncEngineState copyWith({
    bool? isSyncing,
    bool? injectConflictOnNextSync,
    SyncSummary? lastSummary,
  }) {
    return SyncEngineState(
      isSyncing: isSyncing ?? this.isSyncing,
      injectConflictOnNextSync:
          injectConflictOnNextSync ?? this.injectConflictOnNextSync,
      lastSummary: lastSummary ?? this.lastSummary,
    );
  }
}

class SyncEngineNotifier extends Notifier<SyncEngineState> {
  @override
  SyncEngineState build() => const SyncEngineState();

  void toggleConflictInjection(bool enabled) {
    state = state.copyWith(injectConflictOnNextSync: enabled);
  }

  Future<SyncSummary> triggerSyncNow() async {
    if (state.isSyncing) {
      return state.lastSummary ??
          SyncSummary(
            pushedCount: 0,
            pulledCount: 0,
            conflictsDetected: 0,
            completedAtUtc: DateTime.now().toUtc(),
          );
    }

    state = state.copyWith(isSyncing: true);
    final repo = ref.read(notesRepositoryProvider);

    final summary = await repo.synchronize(
      simulateConflictOnNextPush: state.injectConflictOnNextSync,
    );

    state = state.copyWith(
      isSyncing: false,
      injectConflictOnNextSync: false, // Reset toggle after injection
      lastSummary: summary,
    );

    ref.invalidate(paginatedNotesProvider);
    return summary;
  }
}

final syncEngineProvider =
    NotifierProvider<SyncEngineNotifier, SyncEngineState>(
  SyncEngineNotifier.new,
);
