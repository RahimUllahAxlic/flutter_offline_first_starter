enum SyncFilter { all, dirtyOnly, conflictedOnly }

class NoteQueryFilter {
  final String searchQuery;
  final String? category;
  final SyncFilter syncFilter;
  final int pageSize;

  const NoteQueryFilter({
    this.searchQuery = '',
    this.category,
    this.syncFilter = SyncFilter.all,
    this.pageSize = 15,
  });

  NoteQueryFilter copyWith({
    String? searchQuery,
    String? category,
    bool clearCategory = false,
    SyncFilter? syncFilter,
    int? pageSize,
  }) {
    return NoteQueryFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : (category ?? this.category),
      syncFilter: syncFilter ?? this.syncFilter,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
