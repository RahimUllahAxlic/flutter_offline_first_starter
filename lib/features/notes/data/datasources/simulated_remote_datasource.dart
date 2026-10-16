class RemoteNoteDto {
  final String id;
  final String title;
  final String content;
  final String category;
  final bool isPinned;
  final int serverVersion;
  final DateTime updatedAtUtc;

  const RemoteNoteDto({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isPinned,
    required this.serverVersion,
    required this.updatedAtUtc,
  });
}

class RemotePushResult {
  final bool isConflict;
  final RemoteNoteDto serverRecord;

  const RemotePushResult({
    required this.isConflict,
    required this.serverRecord,
  });
}

class SimulatedRemoteDataSource {
  final Map<String, RemoteNoteDto> _cloudStore = {};

  /// Pushes a local note using Optimistic Concurrency Control (OCC).
  /// If [simulateDivergentServerEdit] is true, simulates a concurrent remote
  /// modification so the client receives a 409 Conflict with the server's version.
  Future<RemotePushResult> pushNote({
    required String id,
    required String title,
    required String content,
    required String category,
    required bool isPinned,
    required int clientBaseVersion,
    required bool simulateDivergentServerEdit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 220));

    final existing = _cloudStore[id];

    // Inject a realistic concurrent edit from "Remote Teammate" if requested
    if (simulateDivergentServerEdit) {
      final remoteVersion = (existing?.serverVersion ?? clientBaseVersion) + 1;
      final conflictingServerDto = RemoteNoteDto(
        id: id,
        title: '$title [Edited on Remote Web]',
        content:
            '$content\n\n--- Remote Server Revision v$remoteVersion ---\nAdded production SLA checklist from web dashboard.',
        category: category,
        isPinned: isPinned,
        serverVersion: remoteVersion,
        updatedAtUtc: DateTime.now().toUtc(),
      );
      _cloudStore[id] = conflictingServerDto;
      return RemotePushResult(
        isConflict: true,
        serverRecord: conflictingServerDto,
      );
    }

    // Standard OCC version check
    if (existing != null && existing.serverVersion > clientBaseVersion) {
      return RemotePushResult(isConflict: true, serverRecord: existing);
    }

    final nextVersion = (existing?.serverVersion ?? clientBaseVersion) + 1;
    final updated = RemoteNoteDto(
      id: id,
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
      serverVersion: nextVersion,
      updatedAtUtc: DateTime.now().toUtc(),
    );
    _cloudStore[id] = updated;

    return RemotePushResult(isConflict: false, serverRecord: updated);
  }

  Future<void> deleteNoteOnServer(String id) async {
    await Future.delayed(const Duration(milliseconds: 120));
    _cloudStore.remove(id);
  }
}
