import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import '../../services/firestore_service.dart';
import 'add_question.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FA),
      appBar: AppBar(
        title: Text('Chủ đề: ${topic.name}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Thêm câu hỏi',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddQuestionScreen(topicId: topic.id),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Question>>(
        stream: FirestoreService.instance.streamQuestions(topic.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Lỗi tải dữ liệu câu hỏi.'));
          }

          final questions = snapshot.data ?? [];
          if (questions.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có câu hỏi nào trong chủ đề này.\nNhấn + để thêm mới!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: questions.length,
            itemBuilder: (context, i) {
              final q = questions[i];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Câu ${i + 1}: ${q.text}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...List.generate(q.options.length, (idx) {
                        final isCorrect = idx == q.correctIndex;
                        return Padding(
                          padding: const EdgeInsets.only(left: 6, top: 3),
                          child: Text(
                            '${String.fromCharCode(65 + idx)}. ${q.options[idx]}'
                            '${isCorrect ? " ✅" : ""}',
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.black87,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
