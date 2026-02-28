import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/note.dart';

class NoteStorageService {
  static const String _boxName = 'notes_box';
  static const String _settingsBoxName = 'settings_box';
  static const String _keyIsDarkMode = 'isDarkMode';
  static const String _keySidebarWidth = 'sidebarWidth';

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

  double getSidebarWidth({double defaultValue = 280}) {
    if (_settingsBox == null) return defaultValue;
    final value = _settingsBox!.get(_keySidebarWidth);
    if (value is num) return value.toDouble();
    return defaultValue;
  }

  Future<void> setSidebarWidth(double value) async {
    await _settingsBox?.put(_keySidebarWidth, value);
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

  /// Reads and parses a JSON backup file. Does not save to storage.
  Future<List<Note>> importNotesFromJsonFile(String filePath) async {
    final content = await File(filePath).readAsString();
    final list = jsonDecode(content) as List<dynamic>;
    return list
        .map((e) =>
            Note.fromJson(Map<String, dynamic>.from(e as Map<dynamic, dynamic>)))
        .toList();
  }

  /// Exports [note] to a .txt file in [documents]/QuickNotes/exports.
  /// Returns the absolute path of the exported file.
  Future<String> exportNoteToTxt(Note note) async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(dir.path, 'QuickNotes', 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    final sanitized =
        note.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    final baseName =
        '${sanitized.isEmpty ? 'note' : sanitized}-${_formatExportDate(note.updatedAt)}';
    final file = File(p.join(exportDir.path, '$baseName.txt'));
    final content = '${note.title}\n\n${note.content}';
    await file.writeAsString(content);
    return file.absolute.path;
  }

  /// Exports all [notes] to a JSON file in [documents]/QuickNotes/exports.
  /// Returns the absolute path of the exported file.
  Future<String> exportAllNotesToJson(List<Note> notes) async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(dir.path, 'QuickNotes', 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    final baseName =
        'quick-notes-backup-${_formatExportDate(DateTime.now())}';
    final file = File(p.join(exportDir.path, '$baseName.json'));
    final list = notes.map((n) => n.toJson()).toList();
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(list));
    return file.absolute.path;
  }

  static String _formatExportDate(DateTime d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final h = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$y$m$day-$h$min';
  }
}
