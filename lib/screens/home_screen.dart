import 'package:flutter/material.dart';

import '../widgets/note_editor.dart';
import '../widgets/sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(child: const NoteEditor()),
        ],
      ),
    );
  }
}
