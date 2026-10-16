import 'package:flutter/material.dart';
import '../../domain/entities/note_entity.dart';

class NoteEditorSheet extends StatefulWidget {
  final NoteEntity? existingNote;
  final void Function({
    String? id,
    required String title,
    required String content,
    required String category,
    required bool isPinned,
  }) onSave;

  const NoteEditorSheet({
    super.key,
    this.existingNote,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    NoteEntity? existing,
    required void Function({
      String? id,
      required String title,
      required String content,
      required String category,
      required bool isPinned,
    }) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141923),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => NoteEditorSheet(
        existingNote: existing,
        onSave: onSave,
      ),
    );
  }

  @override
  State<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<NoteEditorSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late String _category;
  late bool _isPinned;

  final List<String> _categories = [
    'Architecture',
    'Security',
    'Performance',
    'Incidents',
    'Database',
  ];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentCtrl =
        TextEditingController(text: widget.existingNote?.content ?? '');
    _category = widget.existingNote?.category ?? 'Architecture';
    _isPinned = widget.existingNote?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existingNote == null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isNew ? 'Create Offline Note' : 'Edit Note',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleCtrl,
            autofocus: isNew,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'e.g. Distributed Consensus ADR',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentCtrl,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Markdown / Body',
              hintText: 'Document local persistence and version vector schema...',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue:
                _categories.contains(_category) ? _category : _categories.first,
            dropdownColor: const Color(0xFF1D2432),
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _category = v);
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Pin to Top of SQLite Index',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            value: _isPinned,
            activeThumbColor: const Color(0xFF06B6D4),
            onChanged: (v) => setState(() => _isPinned = v),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_titleCtrl.text.trim().isEmpty) return;
                widget.onSave(
                  id: widget.existingNote?.id,
                  title: _titleCtrl.text,
                  content: _contentCtrl.text,
                  category: _category,
                  isPinned: _isPinned,
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Save to Local SQLite Outbox',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
