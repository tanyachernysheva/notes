part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {
  const NoteEvent();
  const factory NoteEvent.create({String? title, String? description}) =
      NoteCreateEvent;
  const factory NoteEvent.get() = NoteGetEvent;
  const factory NoteEvent.update(int index) = NoteUpdateEvent;
  const factory NoteEvent.delete() = NoteDeleteEvent;
  const factory NoteEvent.setNoteCompleted({required int index, required bool? value}) = SetNoteCompletedEvent;
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
  const NoteDeleteEvent();
}

final class SetNoteCompletedEvent extends NoteEvent {
  final int index;
  final bool? value;

  const SetNoteCompletedEvent({
    required this.index,
    required this.value,
  });
}
