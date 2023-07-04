part of 'note_bloc.dart';

@immutable
sealed class NoteState {
  const NoteState();
  const factory NoteState.data(List<Note> notes) = NoteDataState;
  const factory NoteState.loading() = NoteLoadingState;
  const factory NoteState.error(String message) = NoteErrorState;
}

final class NoteDataState extends NoteState {
  final List<Note> notes;
  
  const NoteDataState(this.notes);
}

final class NoteLoadingState extends NoteState {
  const NoteLoadingState();
}

final class NoteErrorState extends NoteState {
  final String message;

  const NoteErrorState(this.message);
}
