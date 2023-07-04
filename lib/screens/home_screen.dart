import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repositories/note_repository.dart';
import 'package:notes/screens/bloc/note_bloc.dart';
import 'package:notes/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NoteBloc _bloc;

  @override
  void initState() {
    _bloc = NoteBloc(FirebaseRepository());

    _bloc.add(const NoteEvent.get());

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        bloc: _bloc,
        builder: (context, state) {
          return switch (state) {
            NoteLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            NoteDataState() => RefreshIndicator(
                onRefresh: () async {
                  _bloc.add(const NoteEvent.get());
                },
                child: ListView.builder(
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) {
                    final Note note = state.notes[index];

                    return NoteCard(
                      note: note,
                      onCompletedChanged: (value) {
                        _bloc.add(NoteEvent.setNoteCompleted(
                            index: index, value: value));
                        _bloc.add(NoteEvent.update(index));
                      },
                      onFieldsChanged: () {
                        _showNoteForm(index);
                      },
                      onSwipe: (direction) {
                        _bloc.add(NoteDeleteEvent(index));
                      },
                    );
                  },
                )),
            NoteErrorState() => Center(
                child: Text(state.message),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showNoteForm([int? index]) async {
    Note? note;

    if (index != null) {
      note = (_bloc.state as NoteDataState).notes[index];
    }

    String title = note?.title ?? '';
    String description = note?.description ?? '';

    final newNote = await showModalBottomSheet<Note>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                initialValue: title,
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                initialValue: description,
                onChanged: (value) {
                  description = value;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  if (note == null) {
                    _bloc.add(NoteCreateEvent(
                      title: title,
                      description: description,
                    ));

                    Navigator.pop(context);
                  } else {
                    Navigator.pop(
                        context,
                        note.copyWith(
                          title: title,
                          description: description,
                        ));
                  }
                },
                child: Text(note == null ? 'create' : 'update'),
              ),
            ],
          ),
        ),
      ),
    );

    if (newNote == null) return;

    if (index != null) {
      _bloc.add(UpdateFieldsEvent(note: newNote, index: index));
      _bloc.add(NoteUpdateEvent(index));
    }
  }
}
