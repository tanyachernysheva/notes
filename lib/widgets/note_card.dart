import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(bool? value)? onCompletedChanged;

  const NoteCard({
    super.key,
    required this.note,
    this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        onChanged: onCompletedChanged,
        value: note.completed,
        title: Text(note.title ?? ''),
        subtitle: Text(note.description ?? ''),
      ),
    );
  }
}
