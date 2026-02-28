import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import '../widgets/note_editor.dart';
import '../widgets/sidebar.dart';

class _SaveNoteIntent extends Intent {
  const _SaveNoteIntent();
}

class _DeleteNoteIntent extends Intent {
  const _DeleteNoteIntent();
}

class _NewNoteIntent extends Intent {
  const _NewNoteIntent();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _minSidebarWidth = 240;
  static const double _maxSidebarWidth = 420;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    if (provider.initError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Something went wrong',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  provider.initError!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () =>
                      context.read<NoteProvider>().init(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (!provider.isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.keyS, control: true):
              _SaveNoteIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              _NewNoteIntent(),
          SingleActivator(LogicalKeyboardKey.delete): _DeleteNoteIntent(),
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
            _NewNoteIntent: CallbackAction<_NewNoteIntent>(
              onInvoke: (_) {
                context.read<NoteProvider>().createNewNote();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New note created')),
                );
                return null;
              },
            ),
            _DeleteNoteIntent: CallbackAction<_DeleteNoteIntent>(
              onInvoke: (_) async {
                final note = context.read<NoteProvider>().selectedNote;
                if (note == null) return null;
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete note?'),
                    content: const Text(
                      'This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  context.read<NoteProvider>().deleteNote(note.id);
                }
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: Row(
              children: [
                SizedBox(
                  width: provider.sidebarWidth
                      .clamp(_minSidebarWidth, _maxSidebarWidth),
                  child: const Sidebar(),
                ),
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final newWidth = (provider.sidebarWidth + details.delta.dx)
                        .clamp(_minSidebarWidth, _maxSidebarWidth);
                    provider.setSidebarWidth(newWidth);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: Container(
                      width: 6,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
                Expanded(child: const NoteEditor()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
