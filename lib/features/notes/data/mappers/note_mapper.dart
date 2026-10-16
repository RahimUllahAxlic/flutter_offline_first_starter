import '../../../../core/database/app_database.dart';
import '../../domain/entities/note_entity.dart';

class NoteMapper {
  const NoteMapper._();

  static NoteEntity toDomain(NoteRow row) {
    return NoteEntity(
      id: row.id,
      title: row.title,
      content: row.content,
      category: row.category,
      isPinned: row.isPinned,
      syncState: row.syncState,
      baseVersion: row.baseVersion,
      localVersion: row.localVersion,
      conflictedRemoteTitle: row.conflictedRemoteTitle,
      conflictedRemoteContent: row.conflictedRemoteContent,
      conflictedRemoteVersion: row.conflictedRemoteVersion,
      updatedAtUtc: row.updatedAtUtc,
    );
  }
}
