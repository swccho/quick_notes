import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../services/note_storage_service.dart';

class NoteProvider extends ChangeNotifier {
  NoteProvider(this._storage);

  final NoteStorageService _storage;
  List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  Future<void> init() async {
    await _storage.init();
    _notes = _storage.getAllNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _storage.saveNote(note);
    _notes = _storage.getAllNotes();
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await _storage.saveNote(note);
    _notes = _storage.getAllNotes();
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    await _storage.deleteNote(id);
    _notes = _storage.getAllNotes();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _storage.clearAll();
    _notes = [];
    notifyListeners();
  }

  Future<void> createNewNote() async {
    final now = DateTime.now();
    final note = Note(
      id: const Uuid().v4(),
      title: 'Untitled',
      content: '',
      createdAt: now,
      updatedAt: now,
      isPinned: false,
      color: null,
    );
    await _storage.saveNote(note);
    _notes = [note, ..._notes];
    notifyListeners();
  }
}
