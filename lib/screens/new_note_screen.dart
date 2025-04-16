import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_form.dart';
import '../widgets/note_action_button.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({super.key});

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _saveNote() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<NoteProvider>().addNote(
        _titleController.text.trim(),
        _contentController.text.trim(),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Нова бележка')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: NoteForm(
                    titleController: _titleController,
                    contentController: _contentController,
                    formKey: _formKey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              NoteActionButton(
                label: 'Запази бележката',
                icon: Icons.save,
                onPressed: _saveNote,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
