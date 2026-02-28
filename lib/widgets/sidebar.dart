import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final notes = provider.notes;
    final selectedId = provider.selectedNote?.id;
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Quick Notes'),
                const SizedBox(height: 4),
                Text(
                  '${notes.length} Notes',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      context.read<NoteProvider>().createNewNote(),
                  child: const Text('New Note'),
                ),
              ],
            ),
          ),
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Text(
                      'No notes yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isSelected = selectedId == note.id;
                      return Material(
                        color: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .primaryContainer
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () =>
                              context.read<NoteProvider>().selectNote(note),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Text(
                              note.title,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
