import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/flashcard.dart';
import '../models/quiz.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _topicsCol =>
      _db.collection('topics');

  DocumentReference<Map<String, dynamic>> _topicDoc(String topicId) =>
      _topicsCol.doc(topicId);
  CollectionReference<Map<String, dynamic>> _questionsCol(String topicId) =>
      _topicDoc(topicId).collection('questions');

  // Topics
  Future<String> addTopic(String name) async {
    final uid = _auth.currentUser?.uid;
    final doc = await _topicsCol.add({
      'name': name.trim(),
      'createdBy': uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    return doc.id;
  }

  Stream<List<Topic>> streamTopics() {
    final uid = _auth.currentUser?.uid;
    Query<Map<String, dynamic>> q = _topicsCol.orderBy(
      'createdAt',
      descending: true,
    );
    if (uid != null) {
      // Lọc theo người tạo (nếu muốn). Có thể bỏ nếu muốn xem tất cả.
      // q = q.where('createdBy', isEqualTo: uid);
    }
    return q.snapshots().map(
      (snap) => snap.docs.map((d) => Topic.fromDoc(d.id, d.data())).toList(),
    );
  }

  // Questions
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

  Future<List<Flashcard>> getFlashcards() async {
    final snapshot = await _db
        .collection('flashcards')
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => Flashcard.fromDoc(doc.id, doc.data()))
        .toList();
  }

  // Thêm flashcard mới
  Future<void> addFlashcard(String front, String back) async {
    await _db.collection('flashcards').add({
      'front': front,
      'back': back,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
