import 'package:drift/drift.dart';
import '../../features/notes/domain/entities/note_entity.dart';
import '../../features/notes/domain/entities/note_filter.dart';
import '../../features/notes/domain/entities/sync_summary.dart';
import 'connection/native_connection.dart';

part 'app_database.g.dart';

@DataClassName('NoteRow')
class NotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content => text()();
  TextColumn get category =>
      text().withDefault(const Constant('Architecture'))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  /// Stored as SyncState enum index: 0=synced, 1=pendingPush, 2=pendingDelete, 3=conflicted
  IntColumn get syncState =>
      intEnum<SyncState>().withDefault(const Constant(1))();

  IntColumn get baseVersion => integer().withDefault(const Constant(0))();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();

  /// Conflict snapshot columns (populated when server rejects push with 409)
  TextColumn get conflictedRemoteTitle => text().nullable()();
  TextColumn get conflictedRemoteContent => text().nullable()();
  IntColumn get conflictedRemoteVersion => integer().nullable()();

  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [NotesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? openNativeDatabaseConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Create composite SQLite indexes for fast pagination & outbox lookup
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_notes_updated '
            'ON notes_table (is_pinned DESC, updated_at_utc DESC);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_notes_sync_state '
            'ON notes_table (sync_state);',
          );
        },
      );

  /// Paginated, filtered SQLite query excluding soft-deleted tombstones.
  Future<List<NoteRow>> queryPaginatedNotes({
    required NoteQueryFilter filter,
    required int limit,
    required int offset,
  }) {
    final query = select(notesTable)
      ..where((t) => t.syncState.isNotValue(SyncState.pendingDelete.index));

    if (filter.searchQuery.trim().isNotEmpty) {
      final pattern = '%${filter.searchQuery.trim()}%';
      query.where((t) => t.title.like(pattern) | t.content.like(pattern));
    }

    if (filter.category != null && filter.category!.isNotEmpty) {
      query.where((t) => t.category.equals(filter.category!));
    }

    switch (filter.syncFilter) {
      case SyncFilter.all:
        break;
      case SyncFilter.dirtyOnly:
        query.where((t) => t.syncState.equals(SyncState.pendingPush.index));
        break;
      case SyncFilter.conflictedOnly:
        query.where((t) => t.syncState.equals(SyncState.conflicted.index));
        break;
    }

    query
      ..orderBy([
        (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
        (t) =>
            OrderingTerm(expression: t.updatedAtUtc, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);

    return query.get();
  }

  /// Reactive SQLite aggregation stream for the Sync Telemetry Header.
  Stream<OutboxStatusCounts> watchOutboxTelemetry() {
    return select(notesTable).watch().map((rows) {
      int synced = 0;
      int pending = 0;
      int conflicted = 0;
      for (final r in rows) {
        switch (r.syncState) {
          case SyncState.synced:
            synced++;
            break;
          case SyncState.pendingPush:
          case SyncState.pendingDelete:
            pending++;
            break;
          case SyncState.conflicted:
            conflicted++;
            break;
        }
      }
      return OutboxStatusCounts(
        syncedCount: synced,
        pendingCount: pending,
        conflictCount: conflicted,
      );
    });
  }

  /// Fetches all dirty rows (pendingPush + pendingDelete) for the Outbox worker.
  Future<List<NoteRow>> getDirtyOutboxRows() {
    return (select(notesTable)
          ..where(
            (t) =>
                t.syncState.equals(SyncState.pendingPush.index) |
                t.syncState.equals(SyncState.pendingDelete.index),
          ))
        .get();
  }
}
