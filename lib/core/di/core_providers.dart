import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/notes/data/datasources/simulated_remote_datasource.dart';
import '../../features/notes/data/repositories/drift_notes_repository.dart';
import '../../features/notes/domain/entities/sync_summary.dart';
import '../../features/notes/domain/repositories/notes_repository.dart';
import '../database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final simulatedRemoteDataSourceProvider =
    Provider<SimulatedRemoteDataSource>((ref) {
  return SimulatedRemoteDataSource();
});

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return DriftNotesRepository(
    db: ref.watch(appDatabaseProvider),
    remote: ref.watch(simulatedRemoteDataSourceProvider),
  );
});

final outboxTelemetryStreamProvider =
    StreamProvider<OutboxStatusCounts>((ref) {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.watchOutboxCounts();
});
