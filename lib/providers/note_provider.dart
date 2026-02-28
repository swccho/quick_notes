import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../services/note_storage_service.dart';

class NoteProvider extends ChangeNotifier {
  NoteProvider(this._storage);

  final NoteStorageService _storage;
  List<Note> _notes = [];
  Note? _selectedNote;
  String _searchQuery = '';
  bool _isDarkMode = true;

  List<Note> get notes => List.unmodifiable(_notes);
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  String get searchQuery => _searchQuery;

  List<Note> get filteredNotes {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return List.unmodifiable(_notes);
    return List.unmodifiable(
      _notes.where((n) =>
          n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q)),
    );
  }

  Note? get selectedNote => _selectedNote;

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    if (_selectedNote != null &&
        !filteredNotes.any((n) => n.id == _selectedNote!.id)) {
      _selectedNote = null;
    }
    notifyListeners();
  }

  void selectNote(Note note) {
    _selectedNote = note;
    notifyListeners();
  }

  void _sortNotes() {
    _notes.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }

  Future<void> init() async {
    await _storage.init();
    _notes = _storage.getAllNotes();
    _sortNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _storage.saveNote(note);
    _notes = _storage.getAllNotes();
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    final wasSelected = _selectedNote?.id == note.id;
    if (index >= 0) {
      _notes = [
        ..._notes.sublist(0, index),
        note,
        ..._notes.sublist(index + 1),
      ];
    } else {
      _notes = _storage.getAllNotes();
    }
    await _storage.saveNote(note);
    if (wasSelected) _selectedNote = note;
    _sortNotes();
    notifyListeners();
  }

  Future<void> togglePin(Note note) async {
    final updatedNote = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await updateNote(updatedNote);
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _storage.deleteNote(id);
    if (_selectedNote?.id == id) _selectedNote = null;
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
    _sortNotes();
    _selectedNote = note;
    notifyListeners();
  }
}
