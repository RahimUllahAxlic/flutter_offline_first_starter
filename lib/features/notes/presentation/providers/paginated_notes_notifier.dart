import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/core_providers.dart';
import '../../domain/entities/note_entity.dart';
import 'notes_filter_notifier.dart';

class PaginatedNotesState {
  final List<NoteEntity> items;
  final bool hasMore;
  final bool isLoadingNextPage;

  const PaginatedNotesState({
    required this.items,
    required this.hasMore,
    this.isLoadingNextPage = false,
  });

  PaginatedNotesState copyWith({
    List<NoteEntity>? items,
    bool? hasMore,
    bool? isLoadingNextPage,
  }) {
    return PaginatedNotesState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
    );
  }
}

class PaginatedNotesNotifier extends AsyncNotifier<PaginatedNotesState> {
  @override
  Future<PaginatedNotesState> build() async {
    final filter = ref.watch(notesFilterProvider);
    final repo = ref.watch(notesRepositoryProvider);

    final firstPage = await repo.fetchNotesPage(
      filter: filter,
      limit: filter.pageSize,
      offset: 0,
    );

    return PaginatedNotesState(
      items: firstPage,
      hasMore: firstPage.length >= filter.pageSize,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingNextPage) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingNextPage: true));

    final filter = ref.read(notesFilterProvider);
    final repo = ref.read(notesRepositoryProvider);

    final nextSlice = await repo.fetchNotesPage(
      filter: filter,
      limit: filter.pageSize,
      offset: current.items.length,
    );

    state = AsyncData(
      PaginatedNotesState(
        items: [...current.items, ...nextSlice],
        hasMore: nextSlice.length >= filter.pageSize,
        isLoadingNextPage: false,
      ),
    );
  }

  Future<void> saveNote({
    String? id,
    required String title,
    required String content,
    required String category,
    required bool isPinned,
  }) async {
    final repo = ref.read(notesRepositoryProvider);
    await repo.saveNoteLocally(
      id: id,
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
    );
    ref.invalidateSelf();
  }

  Future<void> deleteNote(String id) async {
    final repo = ref.read(notesRepositoryProvider);
    await repo.deleteNoteLocally(id);
    ref.invalidateSelf();
  }

  Future<void> resolveConflict({
    required String noteId,
    required ConflictResolutionStrategy strategy,
  }) async {
    final repo = ref.read(notesRepositoryProvider);
    await repo.resolveConflict(noteId: noteId, strategy: strategy);
    ref.invalidateSelf();
  }

  Future<void> seedSampleNotes() async {
    final repo = ref.read(notesRepositoryProvider);
    await repo.seedDemoDataset();
    ref.invalidateSelf();
  }
}

final paginatedNotesProvider =
    AsyncNotifierProvider<PaginatedNotesNotifier, PaginatedNotesState>(
  PaginatedNotesNotifier.new,
);
