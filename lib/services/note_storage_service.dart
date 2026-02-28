import 'package:hive_flutter/hive_flutter.dart';

import '../models/note.dart';

class NoteStorageService {
  static const String _boxName = 'notes_box';
  static const String _settingsBoxName = 'settings_box';
  static const String _keyIsDarkMode = 'isDarkMode';

  Box<dynamic>? _box;
  Box<dynamic>? _settingsBox;

  Future<void> init() async {
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  Future<void> initSettings() async {
    _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);
  }

  bool getIsDarkMode({bool defaultValue = false}) {
    if (_settingsBox == null) return defaultValue;
    final value = _settingsBox!.get(_keyIsDarkMode);
    return value is bool ? value : defaultValue;
  }

  Future<void> setIsDarkMode(bool value) async {
    await _settingsBox?.put(_keyIsDarkMode, value);
  }

  List<Note> getAllNotes() {
    if (_box == null) return [];
    return _box!
        .values
        .map((e) => Note.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveNote(Note note) async {
    await _box?.put(note.id, note.toJson());
  }

  Future<void> deleteNote(String id) async {
    await _box?.delete(id);
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }
}
