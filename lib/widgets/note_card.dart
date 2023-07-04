import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(bool? value)? onCompletedChanged;
  final Function()? onFieldsChanged;
  final Function(DismissDirection)? onSwipe;

  const NoteCard({
    super.key,
    required this.note,
    this.onCompletedChanged,
    this.onFieldsChanged,
    this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${note.id}'),
      onDismissed: onSwipe,
      child: GestureDetector(
        onLongPress: onFieldsChanged,
        child: Card(
          child: CheckboxListTile(
            onChanged: onCompletedChanged,
            value: note.completed,
            title: Text(note.title ?? ''),
            subtitle: Text(note.description ?? ''),
          ),
        ),
      ),
    );
  }
}
