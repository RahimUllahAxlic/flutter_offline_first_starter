import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_filter.dart';

class NotesFilterNotifier extends Notifier<NoteQueryFilter> {
  @override
  NoteQueryFilter build() => const NoteQueryFilter();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String? category) {
    state = state.copyWith(
      category: category,
      clearCategory: category == null,
    );
  }

  void setSyncFilter(SyncFilter filter) {
    state = state.copyWith(syncFilter: filter);
  }
}

final notesFilterProvider =
    NotifierProvider<NotesFilterNotifier, NoteQueryFilter>(
  NotesFilterNotifier.new,
);
