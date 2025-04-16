import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final void Function() onTap;

  const NoteTile({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(
        note.content.length > 50
            ? '${note.content.substring(0, 50)}...'
            : note.content,
      ),
      onTap: onTap,
    );
  }
}
