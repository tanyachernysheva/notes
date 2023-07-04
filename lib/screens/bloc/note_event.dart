part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {
  const NoteEvent();
  const factory NoteEvent.create({String? title, String? description}) =
      NoteCreateEvent;
  const factory NoteEvent.get() = NoteGetEvent;
  const factory NoteEvent.update(int index) = NoteUpdateEvent;
  const factory NoteEvent.delete(int index) = NoteDeleteEvent;
  const factory NoteEvent.setNoteCompleted(
      {required int index, required bool? value}) = SetNoteCompletedEvent;
  const factory NoteEvent.updateFields(
      {required int index, required Note note}) = UpdateFieldsEvent;
}

final class NoteGetEvent extends NoteEvent {
  const NoteGetEvent();
}

final class NoteCreateEvent extends NoteEvent {
  final String? title;
  final String? description;

  const NoteCreateEvent({
    this.title,
    this.description,
  });
}

final class NoteUpdateEvent extends NoteEvent {
  final int index;

  const NoteUpdateEvent(this.index);
}

final class NoteDeleteEvent extends NoteEvent {
  final int index;

  const NoteDeleteEvent(
    this.index,
  );
}

final class SetNoteCompletedEvent extends NoteEvent {
  final int index;
  final bool? value;

  const SetNoteCompletedEvent({
    required this.index,
    required this.value,
  });
}

final class UpdateFieldsEvent extends NoteEvent {
  final int index;
  final Note note;

  const UpdateFieldsEvent({
    required this.index,
    required this.note,
  });
}
