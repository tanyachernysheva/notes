import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repositories/note_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final Repository _repository;

  NoteBloc(this._repository) : super(const NoteState.loading()) {
    on<NoteGetEvent>(_getNotes);
    on<NoteCreateEvent>(_createNote);
    on<NoteUpdateEvent>(_updateNote);
    on<SetNoteCompletedEvent>(_setNoteCompleted);
    on<UpdateFieldsEvent>(_updateFields);
    on<NoteDeleteEvent>(_deleteNote);
  }

  Future<void> _getNotes(NoteGetEvent event, Emitter<NoteState> emit) async {
    try {
      emit(const NoteState.loading());

      List<Note> notes = await _repository.get();

      emit(NoteState.data(notes));
    } catch (e, stackTrace) {
      emit(NoteState.error(e.toString()));

      log(e.toString() + stackTrace.toString());
    }
  }

  Future<void> _createNote(
      NoteCreateEvent event, Emitter<NoteState> emit) async {
    try {
      final Note note = Note(
        title: event.title,
        description: event.description,
        createdAt: DateTime.timestamp(),
        updatedAt: DateTime.timestamp(),
      );

      await _repository.createNote(note);

      add(const NoteEvent.get());
    } catch (e, stackTrace) {
      emit(NoteState.error(e.toString()));

      log(e.toString() + stackTrace.toString());
    }
  }

  Future<void> _updateNote(
      NoteUpdateEvent event, Emitter<NoteState> emit) async {
    if (state is! NoteDataState) return;

    try {
      final index = event.index;

      final Note note = (state as NoteDataState).notes[index].copyWith(
            updatedAt: DateTime.timestamp(),
          );

      await _repository.updateNote(note);
    } catch (e) {
      emit(NoteState.error(e.toString()));
    }
  }

  void _setNoteCompleted(SetNoteCompletedEvent event, Emitter<NoteState> emit) {
    if (state is! NoteDataState) return;

    final index = event.index;
    final value = event.value;

    final List<Note> newList = List.of((state as NoteDataState).notes);

    newList[index] = newList[index].copyWith(
      completed: value,
    );

    emit(NoteDataState(newList));
  }

  void _updateFields(UpdateFieldsEvent event, Emitter<NoteState> emit) {
    if (state is! NoteDataState) return;

    final newNote = event.note;
    final index = event.index;

    final List<Note> newList = List.of((state as NoteDataState).notes);

    newList[index] = newList[index].copyWith(
      title: newNote.title,
      description: newNote.description,
    );

    emit(NoteDataState(newList));
  }

  Future<void> _deleteNote(
      NoteDeleteEvent event, Emitter<NoteState> emit) async {
    if (state is! NoteDataState) return;

    try {
      final int index = event.index;
      final List<Note> newList = List.of((state as NoteDataState).notes);

      await _repository.deleteNote(newList.removeAt(index));

      emit(NoteDataState(newList));
    } catch (e, stackTrace) {
      emit(NoteState.error(e.toString()));

      log(e.toString() + stackTrace.toString());
    }
  }
}
