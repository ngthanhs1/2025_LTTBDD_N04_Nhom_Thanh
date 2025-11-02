import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import '../../services/firestore_service.dart';
import 'create_topic.dart';
import 'topic_detail.dart';
import 'take_quiz.dart';

class QuizHomeScreen extends StatelessWidget {
  const QuizHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Quiz - Chủ đề"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: "Tạo chủ đề mới",
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final saved = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateTopicScreen()),
              );
              if (saved == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã thêm chủ đề mới!")),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Topic>>(
        stream: FirestoreService.instance.streamTopics(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải dữ liệu 😢"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final topics = snapshot.data ?? [];

          if (topics.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có chủ đề nào.\nNhấn nút + để bắt đầu tạo!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: topics.length,
            itemBuilder: (context, i) {
              final topic = topics[i];
              return Card(
                color: Colors.indigo.shade50,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Text(
                      topic.name.isNotEmpty ? topic.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    topic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ngày tạo: ${topic.createdAt.toLocal().toString().split(' ').first}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      FutureBuilder<int>(
                        future: FirestoreService.instance.countQuestions(
                          topic.id,
                        ),
                        builder: (context, snap) {
                          return Text(
                            "${snap.data ?? 0} câu hỏi",
                            style: TextStyle(color: Colors.grey.shade800),
                          );
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.indigo,
                      size: 32,
                    ),
                    onPressed: () async {
                      final questions = await FirestoreService.instance
                          .getQuestions(topic.id);
                      if (questions.isEmpty && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Chủ đề chưa có câu hỏi nào."),
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
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TopicDetailScreen(topic: topic),
                    ),
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
