import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import '../widgets/note_editor.dart';
import '../widgets/sidebar.dart';

class _SaveNoteIntent extends Intent {
  const _SaveNoteIntent();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.keyS, control: true):
              _SaveNoteIntent(),
        },
        child: Actions(
          actions: {
            _SaveNoteIntent: CallbackAction<_SaveNoteIntent>(
              onInvoke: (_) {
                final provider = context.read<NoteProvider>();
                final note = provider.selectedNote;
                if (note != null) {
                  provider.updateNote(note);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved')),
                  );
                }
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: Row(
              children: [
                const Sidebar(),
                Expanded(child: const NoteEditor()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
