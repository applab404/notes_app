import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_form.dart';
import '../widgets/note_action_button.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  Note? _note;

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    loadNoteData();
  }

  void loadNoteData() {
    final note = context.read<NoteProvider>().getNoteById(widget.noteId);
    setState(() {
      _note = note;
      _titleController = TextEditingController(text: note?.title ?? '');
      _contentController = TextEditingController(text: note?.content ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_note == null || _note!.id.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Бележката не е намерена')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Редактиране' : _note!.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child:
                      isEditing
                          ? NoteForm(
                            titleController: _titleController,
                            contentController: _contentController,
                            enableValidation: true,
                            formKey: _formKey,
                          )
                          : _buildNoteView(),
                ),
              ),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteView() {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      height: 1.3,
    );

    final dateStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.hintColor,
      fontStyle: FontStyle.italic,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_note!.title, style: titleStyle),
        const SizedBox(height: 8),
        Text(_formatDate(_note!.createdAt), style: dateStyle),
        const Divider(height: 32, thickness: 1),
        Text(_note!.content),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: NoteActionButton(
            label: isEditing ? 'Запази' : 'Редактирай',
            icon: isEditing ? Icons.check : Icons.edit,
            onPressed: isEditing ? _saveNote : _toggleEditMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NoteActionButton(
            label: isEditing ? 'Откажи' : 'Изтрий',
            icon: isEditing ? Icons.close : Icons.delete,
            onPressed: isEditing ? _toggleEditMode : _confirmDelete,
            backgroundColor:
                isEditing ? Colors.grey.shade400 : Colors.redAccent,
            foregroundColor: isEditing ? Colors.black : null,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() => isEditing = !isEditing);
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      deleteNote();
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<NoteProvider>().editNote(widget.noteId, title, content);

      final updated = context.read<NoteProvider>().getNoteById(widget.noteId);
      setState(() {
        _note = updated;
        isEditing = false;
      });
    }
  }

  void deleteNote() {
    context.read<NoteProvider>().deleteNote(widget.noteId);
    Navigator.pop(context);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Изтриване'),
            content: const Text(
              'Сигурни ли сте, че искате да изтриете тази бележка?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отказ'),
              ),
              TextButton(
                onPressed: () {
                  deleteNote();
                  Navigator.pop(context);
                },
                child: const Text('Изтрий'),
              ),
            ],
          ),
    );
  }
}
