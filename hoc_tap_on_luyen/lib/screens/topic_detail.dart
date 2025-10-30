import 'package:flutter/material.dart';

import '../models/quiz.dart';
import '../services/firestore_service.dart';
import 'add_question.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chủ đề: ${topic.name}'),
        actions: [
          IconButton(
            tooltip: 'Thêm câu hỏi',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddQuestionScreen(topicId: topic.id),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Question>>(
        stream: FirestoreService.instance.streamQuestions(topic.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final questions = snapshot.data ?? const <Question>[];
          if (questions.isEmpty) {
            return const Center(child: Text('Chưa có câu hỏi, hãy thêm mới.'));
          }
          return ListView.separated(
            itemCount: questions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final q = questions[i];
              return ListTile(
                title: Text(q.text),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(q.options.length, (idx) {
                    final isCorrect = idx == q.correctIndex;
                    return Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '${String.fromCharCode(65 + idx)}. ${q.options[idx]}' +
                            (isCorrect ? '  (Đúng)' : ''),
                        style: TextStyle(
                          color: isCorrect ? Colors.green[700] : null,
                          fontWeight: isCorrect ? FontWeight.w600 : null,
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
