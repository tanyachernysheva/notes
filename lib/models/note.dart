import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String? title;
  final String? description;
  final bool? completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Note({
    this.id,
    this.title,
    this.description,
    this.completed = false,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Note.fromDocumentnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Note(
      id: snapshot.id,
      title: snapshot.data()?['title'],
      description: snapshot.data()?['description'],
      completed: snapshot.data()?['completed'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          (snapshot.data()?['createdAt'] as Timestamp).millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
          (snapshot.data()?['updatedAt'] as Timestamp).millisecondsSinceEpoch),
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
