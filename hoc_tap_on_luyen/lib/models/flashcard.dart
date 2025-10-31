import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  final String id;
  final String front;
  final String back;

  Flashcard({required this.id, required this.front, required this.back});

  factory Flashcard.fromDoc(String id, Map<String, dynamic> data) {
    return Flashcard(
      id: id,
      front: data['front'] ?? '',
      back: data['back'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'front': front,
      'back': back,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
