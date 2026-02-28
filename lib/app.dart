import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/note_provider.dart';
import 'screens/home_screen.dart';
import 'services/note_storage_service.dart';

class QuickNotesApp extends StatelessWidget {
  const QuickNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteProvider>(
          create: (_) => NoteProvider(NoteStorageService()),
        ),
      ],
      child: Consumer<NoteProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quick Notes',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode:
                provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
