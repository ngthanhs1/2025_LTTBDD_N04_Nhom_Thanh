import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/firestore_service.dart';
import 'topic_detail.dart';
import 'create_topic.dart';
import 'take_quiz.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quiz - Chủ đề',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Tạo chủ đề mới',
            icon: const Icon(Icons.add_circle_outline, color: Colors.indigo),
            onPressed: () async {
              final saved = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateTopicScreen()),
              );
              if (saved == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã tạo chủ đề mới')),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Topic>>(
        stream: FirestoreService.instance.streamTopics(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final topics = snap.data ?? const <Topic>[];
          if (topics.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'Chưa có chủ đề nào.\nHãy bấm dấu "+" để tạo mới!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, i) {
              final t = topics[i];
              return _topicCard(context, t);
            },
          );
        },
      ),
    );
  }

  Widget _topicCard(BuildContext context, Topic topic) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<int>(
          future: FirestoreService.instance.countQuestions(topic.id),
          builder: (context, snap) {
            final count = snap.data ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bookmark_outline, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        topic.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$count câu hỏi',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TopicDetailScreen(topic: topic),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Xem / Sửa'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () async {
                        final questions = await FirestoreService.instance
                            .getQuestions(topic.id);
                        if (!context.mounted) return;
                        if (questions.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chủ đề chưa có câu hỏi.'),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TakeQuizScreen(
                              topic: topic,
                              questions: questions,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Làm bài'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
