import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/models/note.dart';

abstract interface class Repository {
  Future<List<Note>> get();
  Future<void> createNote(Note note);
  Future<void> updateNote(Note note);
}

final class FakeRepository implements Repository {
  @override
  Future<List<Note>> get() async {
    await Future.delayed(const Duration(seconds: 1));

    List<Note> notes = [
      Note(
        title: 'note1',
        description: 'desc1',
        completed: true,
      ),
      Note(
        title: 'note1',
        description: 'desc1',
        completed: true,
      )
    ];

    return notes;
  }

  @override
  Future<void> createNote(Note note) {
    // TODO: implement createNote
    throw UnimplementedError();
  }

  @override
  Future<void> updateNote(Note note) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}

final class FirebaseRepository implements Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'Notes';

  @override
  Future<List<Note>> get() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((docSnapshot) => Note.fromDocumentnapshot(docSnapshot))
        .toList();
  }

  @override
  Future<void> createNote(Note note) async {
    await _firestore.collection(_collectionName).add(note.toJson());
  }

  @override
  Future<void> updateNote(Note note) async {
    await _firestore
        .collection(_collectionName)
        .doc(note.id)
        .update(note.toJson());
  }
}
