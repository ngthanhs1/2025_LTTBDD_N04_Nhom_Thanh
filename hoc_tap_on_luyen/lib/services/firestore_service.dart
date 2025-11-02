import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/flashcard.dart';
import '../models/quiz.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // ==================== QUIZ ====================

  CollectionReference<Map<String, dynamic>> get _topicsCol =>
      _db.collection('topics');

  DocumentReference<Map<String, dynamic>> _topicDoc(String topicId) =>
      _topicsCol.doc(topicId);

  CollectionReference<Map<String, dynamic>> _questionsCol(String topicId) =>
      _topicDoc(topicId).collection('questions');

  // Thêm topic quiz
  Future<String> addTopic(String name) async {
    final uid = _auth.currentUser?.uid;
    final doc = await _topicsCol.add({
      'name': name.trim(),
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // Stream topics quiz
  Stream<List<Topic>> streamTopics() {
    final uid = _auth.currentUser?.uid;
    Query<Map<String, dynamic>> q = _topicsCol.orderBy(
      'createdAt',
      descending: true,
    );
    if (uid != null) {
      // Có thể lọc theo user nếu cần
      // q = q.where('createdBy', isEqualTo: uid);
    }
    return q.snapshots().map(
      (snap) => snap.docs.map((d) => Topic.fromDoc(d.id, d.data())).toList(),
    );
  }

  // Stream questions quiz
  Stream<List<Question>> streamQuestions(String topicId) {
    return _questionsCol(topicId)
        .orderBy('text')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Question.fromDoc(d.id, d.data())).toList(),
        );
  }

  Future<void> addQuestion({
    required String topicId,
    required String text,
    required List<String> options,
    required int correctIndex,
  }) async {
    await _questionsCol(topicId).add({
      'text': text.trim(),
      'options': options.map((e) => e.trim()).toList(),
      'correctIndex': correctIndex,
    });
  }

  Future<List<Question>> getQuestions(String topicId) async {
    final qs = await _questionsCol(topicId).get();
    return qs.docs.map((d) => Question.fromDoc(d.id, d.data())).toList();
  }

  Future<int> countQuestions(String topicId) async {
    final agg = await _questionsCol(topicId).count().get();
    return agg.count ?? 0;
  }

  // ==================== FLASHCARD ====================

  CollectionReference<Map<String, dynamic>> get _flashTopics =>
      _db.collection('flash_topics');

  DocumentReference<Map<String, dynamic>> _flashTopicDoc(String topicId) =>
      _flashTopics.doc(topicId);

  CollectionReference<Map<String, dynamic>> _flashCards(String topicId) =>
      _flashTopicDoc(topicId).collection('cards');

  // Tạo chủ đề flashcard
  Future<String> addFlashTopic(String name) async {
    final doc = await _flashTopics.add({
      'name': name.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // Lắng nghe danh sách chủ đề flashcard
  Stream<List<ChuDe>> streamFlashTopics() {
    return _flashTopics
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ChuDe.fromDoc(d)).toList());
  }

  // Đếm số thẻ trong 1 chủ đề
  Future<int> countFlashcards(String topicId) async {
    final agg = await _flashCards(topicId).count().get();
    return agg.count ?? 0;
    // Nếu SDK chưa hỗ trợ count() -> fallback:
    // final qs = await _flashCards(topicId).get();
    // return qs.docs.length;
  }

  // Thêm thẻ
  Future<void> addFlashcard({
    required String topicId,
    required String front,
    required String back,
    String note = '',
  }) async {
    await _flashCards(topicId).add({
      'front': front.trim(),
      'back': back.trim(),
      'note': note.trim(),
      'starred': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Lắng nghe thẻ theo chủ đề
  Stream<List<Flashcard>> streamCards(String topicId) {
    return _flashCards(topicId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Flashcard.fromDoc(d)).toList());
  }

  // Cập nhật flashcard hiện có
  Future<void> updateFlashcard({
    required String topicId,
    required String cardId,
    required String front,
    required String back,
    required String note,
  }) async {
    try {
      await _db
          .collection('flash_topics')
          .doc(topicId)
          .collection('cards')
          .doc(cardId)
          .update({
            'front': front.trim(),
            'back': back.trim(),
            'note': note.trim(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint('Lỗi cập nhật flashcard: $e');
    }
  }

  Future<int> countQuizTopics() async =>
      (await _topicsCol.count().get()).count ?? 0;

  Future<int> countAllQuestions() async {
    final topics = await _topicsCol.get();
    int total = 0;
    for (var t in topics.docs) {
      final qs = await _questionsCol(t.id).count().get();
      total += qs.count ?? 0;
    }
    return total;
  }

  Future<int> countFlashTopics() async =>
      (await _flashTopics.count().get()).count ?? 0;

  Future<int> countAllFlashcards() async {
    final topics = await _flashTopics.get();
    int total = 0;
    for (var t in topics.docs) {
      final qs = await _flashCards(t.id).count().get();
      total += qs.count ?? 0;
    }
    return total;
  }
}
