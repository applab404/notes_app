import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final List<Note> _notes = List.empty(growable: true);

  List<Note> get notes => _notes;

  void addNote(String title, String content) {
    final newId = 'note_${_notes.length + 1}';

    _notes.add(
      Note(
        id: newId,
        title: title,
        content: content,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Note? getNoteById(String id) {
    for (final note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  void editNote(String id, String newTitle, String newContent) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index < 0) return;

    final current = _notes[index];

    if (current.title == newTitle && current.content == newContent) return;

    _notes[index] = current.copyWith(title: newTitle, content: newContent);

    notifyListeners();
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}
