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
        onPressed: _showCreateNoteForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateNoteForm() {
    String title = '';
    String description = '';

    showModalBottomSheet(
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
              TextField(
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                onChanged: (value) {
                  description = value;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  _bloc.add(NoteCreateEvent(
                    title: title,
                    description: description,
                  ));

                  Navigator.pop(context);
                },
                child: const Text('create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
