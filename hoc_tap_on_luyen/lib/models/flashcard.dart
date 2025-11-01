// lib/models/flashcard.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChuDe {
  final String id;
  final String name;
  final DateTime createdAt;

  ChuDe({required this.id, required this.name, required this.createdAt});

  factory ChuDe.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data() ?? {};
    return ChuDe(
      id: d.id,
      name: (data['name'] ?? '') as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name.trim(),
    'createdAt': FieldValue.serverTimestamp(),
  };
}

class Flashcard {
  final String id;
  final String front;
  final String back;
  final String note;
  final bool starred;
  final DateTime createdAt;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    this.note = '',
    this.starred = false,
    required this.createdAt,
  });

  factory Flashcard.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data() ?? {};
    return Flashcard(
      id: d.id,
      front: (data['front'] ?? '') as String,
      back: (data['back'] ?? '') as String,
      note: (data['note'] ?? '') as String,
      starred: (data['starred'] ?? false) as bool,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'front': front.trim(),
    'back': back.trim(),
    'note': note.trim(),
    'starred': starred,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
