import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/note_filter.dart';
import '../providers/notes_filter_notifier.dart';
import '../providers/paginated_notes_notifier.dart';
import '../providers/sync_engine_notifier.dart';
import '../widgets/conflict_resolution_dialog.dart';
import '../widgets/note_card_widget.dart';
import '../widgets/note_editor_sheet.dart';
import '../widgets/sync_telemetry_bar.dart';

class NotesWorkspacePage extends ConsumerStatefulWidget {
  const NotesWorkspacePage({super.key});

  @override
  ConsumerState<NotesWorkspacePage> createState() => _NotesWorkspacePageState();
}

class _NotesWorkspacePageState extends ConsumerState<NotesWorkspacePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 180) {
      ref.read(paginatedNotesProvider.notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(syncEngineProvider);
    final filterState = ref.watch(notesFilterProvider);
    final notesAsync = ref.watch(paginatedNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Offline-First Notes (Drift + Riverpod)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Seed 35 Sample Notes',
            icon: const Icon(Icons.dataset_outlined),
            onPressed: () =>
                ref.read(paginatedNotesProvider.notifier).seedSampleNotes(),
          ),
          IconButton(
            tooltip: 'Run Outbox Sync Cycle',
            icon: syncState.isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            onPressed: syncState.isSyncing
                ? null
                : () async {
                    final summary = await ref
                        .read(syncEngineProvider.notifier)
                        .triggerSyncNow();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sync Complete · Pushed: ${summary.pushedCount} · '
                          'Conflicts: ${summary.conflictsDetected}',
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Outbox & Conflict Simulation Telemetry Bar
          const SyncTelemetryBar(),

          // 2. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              onChanged: (q) =>
                  ref.read(notesFilterProvider.notifier).setSearchQuery(q),
              decoration: InputDecoration(
                hintText: 'Search SQLite indexed title or content...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                filled: true,
                fillColor: const Color(0xFF141923),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 3. Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Notes'),
                  selected: filterState.syncFilter == SyncFilter.all,
                  onSelected: (_) => ref
                      .read(notesFilterProvider.notifier)
                      .setSyncFilter(SyncFilter.all),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pending Outbox'),
                  selected: filterState.syncFilter == SyncFilter.dirtyOnly,
                  onSelected: (_) => ref
                      .read(notesFilterProvider.notifier)
                      .setSyncFilter(SyncFilter.dirtyOnly),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('409 Conflicted'),
                  selected: filterState.syncFilter == SyncFilter.conflictedOnly,
                  onSelected: (_) => ref
                      .read(notesFilterProvider.notifier)
                      .setSyncFilter(SyncFilter.conflictedOnly),
                ),
              ],
            ),
          ),

          // 4. Paginated Notes List
          Expanded(
            child: notesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('SQLite Error: $err')),
              data: (pageState) {
                if (pageState.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'No notes match the current filter.',
                          style: TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.dataset_outlined),
                          label: const Text('Seed 35 Sample Notes'),
                          onPressed: () => ref
                              .read(paginatedNotesProvider.notifier)
                              .seedSampleNotes(),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 90),
                  itemCount:
                      pageState.items.length + (pageState.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= pageState.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    final note = pageState.items[index];

                    return NoteCardWidget(
                      note: note,
                      onTap: () {
                        if (note.hasConflict) {
                          showDialog(
                            context: context,
                            builder: (_) => ConflictResolutionDialog(
                              note: note,
                              onResolve: (strategy) {
                                ref
                                    .read(paginatedNotesProvider.notifier)
                                    .resolveConflict(
                                      noteId: note.id,
                                      strategy: strategy,
                                    );
                              },
                            ),
                          );
                        } else {
                          _openNoteEditor(context, existing: note);
                        }
                      },
                      onDelete: () => ref
                          .read(paginatedNotesProvider.notifier)
                          .deleteNote(note.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteEditor(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Local Note',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _openNoteEditor(BuildContext context, {NoteEntity? existing}) {
    NoteEditorSheet.show(
      context,
      existing: existing,
      onSave: ({
        String? id,
        required String title,
        required String content,
        required String category,
        required bool isPinned,
      }) {
        ref.read(paginatedNotesProvider.notifier).saveNote(
              id: id,
              title: title,
              content: content,
              category: category,
              isPinned: isPinned,
            );
      },
    );
  }
}
