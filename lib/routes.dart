import 'package:flutter/material.dart';
import 'package:notes_app/screens/settings_screen.dart';
import 'screens/note_list_screen.dart';
import 'screens/new_note_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const NoteListScreen(),
  '/new': (_) => const NewNoteScreen(),
  '/settings': (_) => const SettingsScreen(),
};
