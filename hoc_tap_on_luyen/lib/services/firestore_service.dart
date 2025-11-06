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

  Future<String> addTopic(String name) async {
    final uid = _auth.currentUser?.uid;
    final doc = await _topicsCol.add({
      'name': name.trim(),
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<List<Topic>> streamTopics() {
    final uid = _auth.currentUser?.uid;
    return _topicsCol
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .where((d) {
                final data = d.data();
                final createdBy = data['createdBy'];
                return createdBy == uid || createdBy == null;
              })
              .map((d) => Topic.fromDoc(d.id, d.data()))
              .toList(),
        );
  }

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

  Future<void> updateQuestion({
    required String topicId,
    required String questionId,
    required String text,
    required List<String> options,
    required int correctIndex,
  }) async {
    await _questionsCol(topicId).doc(questionId).update({
      'text': text.trim(),
      'options': options.map((e) => e.trim()).toList(),
      'correctIndex': correctIndex,
    });
  }

  Future<void> deleteQuestion({
    required String topicId,
    required String questionId,
  }) async {
    await _questionsCol(topicId).doc(questionId).delete();
  }

  Future<List<Question>> getQuestions(String topicId) async {
    final qs = await _questionsCol(topicId).get();
    return qs.docs.map((d) => Question.fromDoc(d.id, d.data())).toList();
  }

  Future<int> countQuestions(String topicId) async {
    final agg = await _questionsCol(topicId).count().get();
    return agg.count ?? 0;
  }

  // Đổi tên và xóa chủ đề Quiz
  Future<void> updateQuizTopicName({
    required String topicId,
    required String newName,
  }) async {
    await _topicDoc(topicId).update({'name': newName.trim()});
  }

  Future<void> deleteQuizTopic(String topicId) async {
    // Xóa toàn bộ câu hỏi trong chủ đề rồi xóa chủ đề
    final qs = await _questionsCol(topicId).get();
    for (final d in qs.docs) {
      await d.reference.delete();
    }
    await _topicDoc(topicId).delete();
  }

  // ==================== FLASHCARD ====================

  CollectionReference<Map<String, dynamic>> get _flashTopics =>
      _db.collection('flash_topics');

  DocumentReference<Map<String, dynamic>> _flashTopicDoc(String topicId) =>
      _flashTopics.doc(topicId);

  CollectionReference<Map<String, dynamic>> _flashCards(String topicId) =>
      _flashTopicDoc(topicId).collection('cards');

  Future<String> addFlashTopic(String name) async {
    final uid = _auth.currentUser?.uid;
    final doc = await _flashTopics.add({
      'name': name.trim(),
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<List<ChuDe>> streamFlashTopics() {
    final uid = _auth.currentUser?.uid;
    return _flashTopics
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .where((d) {
                final data = d.data();
                final createdBy = data['createdBy'];
                return createdBy == uid || createdBy == null;
              })
              .map((d) => ChuDe.fromDoc(d))
              .toList(),
        );
  }

  Future<int> countFlashcards(String topicId) async {
    final agg = await _flashCards(topicId).count().get();
    return agg.count ?? 0;
  }

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

  Stream<List<Flashcard>> streamCards(String topicId) {
    return _flashCards(topicId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Flashcard.fromDoc(d)).toList());
  }

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

  // Đổi tên và xóa thư mục Flashcard
  Future<void> updateFlashTopicName({
    required String topicId,
    required String newName,
  }) async {
    await _flashTopicDoc(topicId).update({'name': newName.trim()});
  }

  Future<void> deleteFlashTopic(String topicId) async {
    // Xóa toàn bộ thẻ trong chủ đề rồi xóa chủ đề
    final cards = await _flashCards(topicId).get();
    for (final d in cards.docs) {
      await d.reference.delete();
    }
    await _flashTopicDoc(topicId).delete();
  }

  Future<int> countQuizTopics() async {
    final uid = _auth.currentUser?.uid;
    final snap = await _topicsCol.get();
    return snap.docs.where((d) {
      final data = d.data();
      final createdBy = data['createdBy'];
      return createdBy == uid || createdBy == null;
    }).length;
  }

  Future<int> countAllQuestions() async {
    final uid = _auth.currentUser?.uid;
    final topicsSnap = await _topicsCol.get();
    final filtered = topicsSnap.docs.where((d) {
      final data = d.data();
      final createdBy = data['createdBy'];
      return createdBy == uid || createdBy == null;
    });
    int total = 0;
    for (var t in filtered) {
      final qs = await _questionsCol(t.id).count().get();
      total += qs.count ?? 0;
    }
    return total;
  }

  Future<int> countFlashTopics() async {
    final uid = _auth.currentUser?.uid;
    final snap = await _flashTopics.get();
    return snap.docs.where((d) {
      final data = d.data();
      final createdBy = data['createdBy'];
      return createdBy == uid || createdBy == null;
    }).length;
  }

  Future<int> countAllFlashcards() async {
    final uid = _auth.currentUser?.uid;
    final topicsSnap = await _flashTopics.get();
    final filtered = topicsSnap.docs.where((d) {
      final data = d.data();
      final createdBy = data['createdBy'];
      return createdBy == uid || createdBy == null;
    });
    int total = 0;
    for (var t in filtered) {
      final qs = await _flashCards(t.id).count().get();
      total += qs.count ?? 0;
    }
    return total;
  }

  // ==================== FLASH PRACTICE SESSIONS ====================

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> _flashPracticeSessions(
    String uid,
  ) => _userDoc(uid).collection('flash_practice_sessions');
  Future<void> addFlashPracticeSession({
    required String topicId,
    required String topicName,
    required int total,
    required int correct,
    required int wrong,
  }) async {
    final uid = _auth.currentUser?.uid ?? 'guest';
    await _flashPracticeSessions(uid).add({
      'topicId': topicId,
      'topicName': topicName,
      'total': total,
      'correct': correct,
      'wrong': wrong,
      'accuracy': total == 0 ? 0 : (correct / total),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> getFlashPracticeSummary({
    int limit = 200,
  }) async {
    final uid = _auth.currentUser?.uid ?? 'guest';
    final qs = await _flashPracticeSessions(
      uid,
    ).orderBy('createdAt', descending: true).limit(limit).get();

    int correct = 0;
    int wrong = 0;
    final Map<String, Map<String, dynamic>> perTopic = {};

    for (final d in qs.docs) {
      final data = d.data();
      final c = (data['correct'] ?? 0) as int;
      final w = (data['wrong'] ?? 0) as int;
      correct += c;
      wrong += w;
      final tId = (data['topicId'] ?? '') as String;
      final tName = (data['topicName'] ?? '') as String;
      final ts = (data['createdAt'] as Timestamp?);
      final createdAt = ts?.toDate() ?? DateTime.now();

      final entry =
          perTopic[tId] ??
          {
            'name': tName,
            'id': tId,
            'correct': 0,
            'wrong': 0,
            'done': 0,
            'lastDate': createdAt,
          };
      entry['correct'] = (entry['correct'] as int) + c;
      entry['wrong'] = (entry['wrong'] as int) + w;
      entry['done'] = (entry['done'] as int) + 1;
      if (createdAt.isAfter(entry['lastDate'] as DateTime)) {
        entry['lastDate'] = createdAt;
      }
      perTopic[tId] = entry;
    }

    final accuracy = (correct + wrong) == 0
        ? 0
        : ((correct / (correct + wrong)) * 100).round();

    final topics = perTopic.values.map((e) {
      final c = e['correct'] as int;
      final w = e['wrong'] as int;
      final acc = (c + w) == 0 ? 0 : ((c / (c + w)) * 100).round();
      final dt = e['lastDate'] as DateTime;
      final dateStr =
          '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
      return {
        'name': e['name'],
        'id': e['id'],
        'accuracy': acc,
        'done': e['done'],
        'date': dateStr,
      };
    }).toList();

    topics.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

    return {
      'done': qs.docs.length,
      'accuracy': accuracy,
      'correct': correct,
      'wrong': wrong,
      'topics': topics,
    };
  }

  Stream<Map<String, dynamic>> streamFlashPracticeSummary({int limit = 200}) {
    final uid = _auth.currentUser?.uid ?? 'guest';
    return _flashPracticeSessions(
      uid,
    ).orderBy('createdAt', descending: true).limit(limit).snapshots().map((qs) {
      int correct = 0;
      int wrong = 0;
      final Map<String, Map<String, dynamic>> perTopic = {};

      for (final d in qs.docs) {
        final data = d.data();
        final c = (data['correct'] ?? 0) as int;
        final w = (data['wrong'] ?? 0) as int;
        correct += c;
        wrong += w;
        final tId = (data['topicId'] ?? '') as String;
        final tName = (data['topicName'] ?? '') as String;
        final ts = (data['createdAt'] as Timestamp?);
        final createdAt = ts?.toDate() ?? DateTime.now();

        final entry =
            perTopic[tId] ??
            {
              'name': tName,
              'id': tId,
              'correct': 0,
              'wrong': 0,
              'done': 0,
              'lastDate': createdAt,
            };
        entry['correct'] = (entry['correct'] as int) + c;
        entry['wrong'] = (entry['wrong'] as int) + w;
        entry['done'] = (entry['done'] as int) + 1;
        if (createdAt.isAfter(entry['lastDate'] as DateTime)) {
          entry['lastDate'] = createdAt;
        }
        perTopic[tId] = entry;
      }

      final accuracy = (correct + wrong) == 0
          ? 0
          : ((correct / (correct + wrong)) * 100).round();

      final topics =
          perTopic.values.map((e) {
            final c = e['correct'] as int;
            final w = e['wrong'] as int;
            final acc = (c + w) == 0 ? 0 : ((c / (c + w)) * 100).round();
            final dt = e['lastDate'] as DateTime;
            final dateStr =
                '${dt.day.toString().padLeft(2, '0')}/'
                '${dt.month.toString().padLeft(2, '0')}/'
                '${dt.year}';
            return {
              'name': e['name'],
              'id': e['id'],
              'accuracy': acc,
              'done': e['done'],
              'date': dateStr,
            };
          }).toList()..sort(
            (a, b) => (b['date'] as String).compareTo(a['date'] as String),
          );

      return {
        'done': qs.docs.length,
        'accuracy': accuracy,
        'correct': correct,
        'wrong': wrong,
        'topics': topics,
      };
    });
  }

  // ==================== QUIZ SESSIONS ====================

  CollectionReference<Map<String, dynamic>> _quizSessions(String uid) =>
      _userDoc(uid).collection('quiz_sessions');

  Future<void> addQuizSession({
    required String topicId,
    required String topicName,
    required int total,
    required int correct,
    required int wrong,
  }) async {
    final uid = _auth.currentUser?.uid ?? 'guest';
    await _quizSessions(uid).add({
      'topicId': topicId,
      'topicName': topicName,
      'total': total,
      'correct': correct,
      'wrong': wrong,
      'accuracy': total == 0 ? 0 : (correct / total),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> getQuizSummary({int limit = 200}) async {
    final uid = _auth.currentUser?.uid ?? 'guest';
    final qs = await _quizSessions(
      uid,
    ).orderBy('createdAt', descending: true).limit(limit).get();

    int correct = 0;
    int wrong = 0;
    final Map<String, Map<String, dynamic>> perTopic = {};

    for (final d in qs.docs) {
      final data = d.data();
      final c = (data['correct'] ?? 0) as int;
      final w = (data['wrong'] ?? 0) as int;
      correct += c;
      wrong += w;
      final tId = (data['topicId'] ?? '') as String;
      final tName = (data['topicName'] ?? '') as String;
      final ts = (data['createdAt'] as Timestamp?);
      final createdAt = ts?.toDate() ?? DateTime.now();

      final entry =
          perTopic[tId] ??
          {
            'name': tName,
            'id': tId,
            'correct': 0,
            'wrong': 0,
            'done': 0,
            'lastDate': createdAt,
          };
      entry['correct'] = (entry['correct'] as int) + c;
      entry['wrong'] = (entry['wrong'] as int) + w;
      entry['done'] = (entry['done'] as int) + 1;
      if (createdAt.isAfter(entry['lastDate'] as DateTime)) {
        entry['lastDate'] = createdAt;
      }
      perTopic[tId] = entry;
    }

    final accuracy = (correct + wrong) == 0
        ? 0
        : ((correct / (correct + wrong)) * 100).round();

    final topics = perTopic.values.map((e) {
      final c = e['correct'] as int;
      final w = e['wrong'] as int;
      final acc = (c + w) == 0 ? 0 : ((c / (c + w)) * 100).round();
      final dt = e['lastDate'] as DateTime;
      final dateStr =
          '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
      return {
        'name': e['name'],
        'accuracy': acc,
        'done': e['done'],
        'date': dateStr,
      };
    }).toList();

    topics.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

    return {
      'done': qs.docs.length,
      'accuracy': accuracy,
      'correct': correct,
      'wrong': wrong,
      'topics': topics,
    };
  }

  Stream<Map<String, dynamic>> streamQuizSummary({int limit = 200}) {
    final uid = _auth.currentUser?.uid ?? 'guest';
    return _quizSessions(
      uid,
    ).orderBy('createdAt', descending: true).limit(limit).snapshots().map((qs) {
      int correct = 0;
      int wrong = 0;
      final Map<String, Map<String, dynamic>> perTopic = {};

      for (final d in qs.docs) {
        final data = d.data();
        final c = (data['correct'] ?? 0) as int;
        final w = (data['wrong'] ?? 0) as int;
        correct += c;
        wrong += w;
        final tId = (data['topicId'] ?? '') as String;
        final tName = (data['topicName'] ?? '') as String;
        final ts = (data['createdAt'] as Timestamp?);
        final createdAt = ts?.toDate() ?? DateTime.now();

        final entry =
            perTopic[tId] ??
            {
              'name': tName,
              'id': tId,
              'correct': 0,
              'wrong': 0,
              'done': 0,
              'lastDate': createdAt,
            };
        entry['correct'] = (entry['correct'] as int) + c;
        entry['wrong'] = (entry['wrong'] as int) + w;
        entry['done'] = (entry['done'] as int) + 1;
        if (createdAt.isAfter(entry['lastDate'] as DateTime)) {
          entry['lastDate'] = createdAt;
        }
        perTopic[tId] = entry;
      }

      final accuracy = (correct + wrong) == 0
          ? 0
          : ((correct / (correct + wrong)) * 100).round();

      final topics =
          perTopic.values.map((e) {
            final c = e['correct'] as int;
            final w = e['wrong'] as int;
            final acc = (c + w) == 0 ? 0 : ((c / (c + w)) * 100).round();
            final dt = e['lastDate'] as DateTime;
            final dateStr =
                '${dt.day.toString().padLeft(2, '0')}/'
                '${dt.month.toString().padLeft(2, '0')}/'
                '${dt.year}';
            return {
              'name': e['name'],
              'accuracy': acc,
              'done': e['done'],
              'date': dateStr,
            };
          }).toList()..sort(
            (a, b) => (b['date'] as String).compareTo(a['date'] as String),
          );

      return {
        'done': qs.docs.length,
        'accuracy': accuracy,
        'correct': correct,
        'wrong': wrong,
        'topics': topics,
      };
    });
  }

  /// Thống kê Quiz cho riêng hôm nay: số bài đã làm và điểm trung bình (tỉ lệ đúng %)
  Future<Map<String, int>> getTodayQuizStats() async {
    final uid = _auth.currentUser?.uid ?? 'guest';
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    final qs = await _quizSessions(uid)
        .where('createdAt', isGreaterThanOrEqualTo: startOfToday)
        .where('createdAt', isLessThan: startOfTomorrow)
        .get();

    final done = qs.docs.length;
    double accSum = 0;
    for (final d in qs.docs) {
      final data = d.data();
      final accFrac = (data['accuracy'] ?? 0).toDouble(); // 0..1
      accSum += accFrac;
    }
    final avgPercent = done == 0 ? 0 : ((accSum / done) * 100).round();
    return {'done': done, 'avg': avgPercent};
  }

  Future<List<int>> getDailyActivityThisMonth() async {
    final uid = _auth.currentUser?.uid ?? 'guest';
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    final daysInMonth = nextMonth.difference(firstDay).inDays;
    final counts = List<int>.filled(daysInMonth, 0);

    Future<void> accumulate(Query<Map<String, dynamic>> q) async {
      final qs = await q.get();
      for (final d in qs.docs) {
        final ts = d.data()['createdAt'] as Timestamp?;
        final dt = ts?.toDate();
        if (dt == null) continue;
        final dayIndex = dt.day - 1;
        if (dayIndex >= 0 && dayIndex < daysInMonth) {
          counts[dayIndex] += 1;
        }
      }
    }

    final quizQ = _quizSessions(uid)
        .where('createdAt', isGreaterThanOrEqualTo: firstDay)
        .where('createdAt', isLessThan: nextMonth);
    final flashQ = _flashPracticeSessions(uid)
        .where('createdAt', isGreaterThanOrEqualTo: firstDay)
        .where('createdAt', isLessThan: nextMonth);

    await Future.wait([accumulate(quizQ), accumulate(flashQ)]);
    return counts;
  }
}
