import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/routes.dart';
import 'package:notes_app/theme/app_theme.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Notes',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: appRoutes,
          );
        },
      ),
    );
  }
}
