import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 0,
                        ),
                        child: Text(
                          notes[index].title,
                          style: Theme.of(context).textTheme.bodyMedium,
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
