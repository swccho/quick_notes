import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';

class _FocusSearchIntent extends Intent {
  const _FocusSearchIntent();
}

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final notes = provider.filteredNotes;
    final selectedId = provider.selectedNote?.id;
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyF, control: true):
            _FocusSearchIntent(),
      },
      child: Actions(
        actions: {
          _FocusSearchIntent: CallbackAction<_FocusSearchIntent>(
            onInvoke: (_) {
              _searchFocusNode.requestFocus();
              return null;
            },
          ),
        },
        child: SizedBox(
          width: 280,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Quick Notes (${provider.notes.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) async {
                        if (value != 'clear_all') return;
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Clear all notes?'),
                            content: const Text(
                              'This will permanently delete all notes.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(true),
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true && context.mounted) {
                          context.read<NoteProvider>().clearAll();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'clear_all',
                          child: Text('Clear all notes'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      context.read<NoteProvider>().createNewNote(),
                  child: const Text('New Note'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Search notes...',
                    suffixIcon: provider.searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              context.read<NoteProvider>().setSearchQuery('');
                            },
                          ),
                  ),
                  onChanged: (value) =>
                      context.read<NoteProvider>().setSearchQuery(value),
                ),
              ],
            ),
          ),
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No notes yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first note to get started.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () =>
                                context.read<NoteProvider>().createNewNote(),
                            child: const Text('Create Note'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isSelected = selectedId == note.id;
                      final colorScheme = Theme.of(context).colorScheme;
                      return Material(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    context.read<NoteProvider>().selectNote(note),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        note.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat('MMM d, h:mm a')
                                            .format(note.updatedAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        note.content.trim().isEmpty
                                            ? '(Empty)'
                                            : note.content.trim(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                color: note.isPinned
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () =>
                                  context.read<NoteProvider>().togglePin(note),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () =>
                      context.read<NoteProvider>().toggleTheme(),
                ),
              ],
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }
}
