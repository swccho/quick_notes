import 'package:hive_flutter/hive_flutter.dart';

import '../models/note.dart';

class NoteStorageService {
  static const String _boxName = 'notes_box';
  Box<dynamic>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<dynamic>(_boxName);
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
