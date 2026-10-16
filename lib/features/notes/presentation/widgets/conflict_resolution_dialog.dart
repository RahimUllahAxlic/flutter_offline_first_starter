import 'package:flutter/material.dart';
import '../../domain/entities/note_entity.dart';

class ConflictResolutionDialog extends StatelessWidget {
  final NoteEntity note;
  final ValueChanged<ConflictResolutionStrategy> onResolve;

  const ConflictResolutionDialog({
    super.key,
    required this.note,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF141923),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      title: const Row(
        children: [
          Icon(Icons.sync_problem, color: Colors.redAccent),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '409 OCC Version Conflict',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Base Revision v${note.baseVersion} diverged! Your local copy is v${note.localVersion}, '
              'while the remote server advanced to v${note.conflictedRemoteVersion}.',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 14),
            _VersionDiffBox(
              badge: 'LOCAL OUTBOX VERSION (v${note.localVersion})',
              badgeColor: Colors.amberAccent,
              title: note.title,
              content: note.content,
            ),
            const SizedBox(height: 10),
            _VersionDiffBox(
              badge:
                  'REMOTE SERVER VERSION (v${note.conflictedRemoteVersion ?? "?"})',
              badgeColor: Colors.cyanAccent,
              title: note.conflictedRemoteTitle ?? note.title,
              content: note.conflictedRemoteContent ?? '',
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.cyanAccent),
          onPressed: () {
            Navigator.pop(context);
            onResolve(ConflictResolutionStrategy.acceptRemote);
          },
          child: const Text('Accept Remote'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.amberAccent),
          onPressed: () {
            Navigator.pop(context);
            onResolve(ConflictResolutionStrategy.keepLocal);
          },
          child: const Text('Force Keep Local'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
          onPressed: () {
            Navigator.pop(context);
            onResolve(ConflictResolutionStrategy.mergeBoth);
          },
          child: const Text('Merge Both'),
        ),
      ],
    );
  }
}

class _VersionDiffBox extends StatelessWidget {
  final String badge;
  final Color badgeColor;
  final String title;
  final String content;

  const _VersionDiffBox({
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2432),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            badge,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
