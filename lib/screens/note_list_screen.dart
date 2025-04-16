import 'package:flutter/material.dart';
import 'package:notes_app/screens/note_detail_screen.dart';
import 'package:notes_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_tile.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List _notes = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    loadNoteData();
  }

  void loadNoteData() {
    final provider = context.read<NoteProvider>();
    setState(() {
      _notes = provider.notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Моите бележки')),
      drawer: _buildDrawer(context),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.pushNamed(context, '/new').then((_) {
              loadNoteData();
            }),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Text('Меню', style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_notes.isEmpty) {
      return const Center(
        child: Text('Няма добавени бележки', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _notes.length,
      itemBuilder: (_, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: NoteTile(
            note: _notes[i],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteDetailScreen(noteId: _notes[i].id),
                ),
              ).then((_) {
                loadNoteData();
              });
            },
          ),
        );
      },
    );
  }
}
