import 'package:flutter/material.dart';
import '../../domain/entities/note_entity.dart';

class NoteCardWidget extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCardWidget({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final (badgeColor, badgeText) = switch (note.syncState) {
      SyncState.synced => (
          const Color(0xFF10B981),
          'SYNCED v${note.baseVersion}'
        ),
      SyncState.pendingPush => (
          const Color(0xFFF59E0B),
          'OUTBOX v${note.localVersion} (Base v${note.baseVersion})'
        ),
      SyncState.pendingDelete => (
          Colors.grey,
          'TOMBSTONE'
        ),
      SyncState.conflicted => (
          const Color(0xFFEF4444),
          '409 CONFLICT (Tap to Resolve)'
        ),
    };

    return Card(
      color: const Color(0xFF141923),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: note.hasConflict
              ? const Color(0xFFEF4444)
              : const Color(0xFF262D3D),
          width: note.hasConflict ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (note.isPinned)
                    const Padding(
                      padding: EdgeInsets.only(right: 6, top: 2),
                      child: Icon(
                        Icons.push_pin,
                        size: 14,
                        color: Color(0xFF06B6D4),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.white38,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  Text(
                    note.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
