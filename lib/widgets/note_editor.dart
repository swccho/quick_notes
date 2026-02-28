import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Timer? _debounceTimer;
  String? _boundNoteId;

  static const Duration _debounceDuration = Duration(milliseconds: 400);

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _syncControllers(Note note) {
    if (_boundNoteId == note.id) return;
    _boundNoteId = note.id;
    _titleController.text = note.title;
    _contentController.text = note.content;
  }

  void _scheduleSave(Note note) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      final updated = note.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        updatedAt: DateTime.now(),
      );
      if (context.mounted) {
        context.read<NoteProvider>().updateNote(updated);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedNote = context.watch<NoteProvider>().selectedNote;
    if (selectedNote != null) {
      _syncControllers(selectedNote);
    } else {
      _boundNoteId = null;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: selectedNote == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select or create a note to start editing',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Title',
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        onChanged: (_) => _scheduleSave(selectedNote),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last edited: ${DateFormat.yMd().add_Hm().format(selectedNote.updatedAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: TextField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: '(Empty note)',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: null,
                          expands: true,
                          onChanged: (_) => _scheduleSave(selectedNote),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
