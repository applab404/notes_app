import 'package:flutter/material.dart';
import 'note_input.dart';

class NoteForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final GlobalKey<FormState>? formKey;
  final bool enableValidation;

  const NoteForm({
    super.key,
    required this.titleController,
    required this.contentController,
    this.formKey,
    this.enableValidation = true,
  });

  @override
  Widget build(BuildContext context) {
    final form = Column(
      children: [
        NoteInputField(
          controller: titleController,
          label: 'Заглавие',
          hint: 'Въведи заглавие',
          validator:
              enableValidation
                  ? (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Моля, въведи заглавие'
                          : null
                  : null,
        ),
        const SizedBox(height: 16),
        NoteInputField(
          controller: contentController,
          label: 'Съдържание',
          hint: 'Напиши бележката си...',
          maxLines: 10,
          validator:
              enableValidation
                  ? (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Моля, въведи съдържание'
                          : null
                  : null,
        ),
      ],
    );

    return formKey != null ? Form(key: formKey, child: form) : form;
  }
}
