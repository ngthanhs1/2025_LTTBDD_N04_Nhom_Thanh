import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/firestore_service.dart';
import 'topic_detail.dart';
import 'take_quiz.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz - Chủ đề'),
        actions: [
          IconButton(
            tooltip: 'Thêm chủ đề',
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTopicDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Topic>>(
        stream: FirestoreService.instance.streamTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final topics = snapshot.data ?? const <Topic>[];
          if (topics.isEmpty) {
            return const Center(
              child: Text('Chưa có chủ đề nào. Hãy bấm "+" để tạo.'),
            );
          }
          return ListView.separated(
            itemCount: topics.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => _topicTile(context, topics[i]),
          );
        },
      ),
    );
  }

  Widget _topicTile(BuildContext context, Topic t) {
    return ListTile(
      title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: FutureBuilder<int>(
        future: FirestoreService.instance.countQuestions(t.id),
        builder: (context, snap) {
          final c = snap.data ?? 0;
          return Text('$c câu hỏi');
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: t)),
      ),
      trailing: FilledButton(
        onPressed: () async {
          // Lấy tất cả câu hỏi để làm bài bằng service
          final questions = await FirestoreService.instance.getQuestions(t.id);
          if (!context.mounted) return;
          if (questions.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chủ đề chưa có câu hỏi.')),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TakeQuizScreen(topic: t, questions: questions),
            ),
          );
        },
        child: const Text('Làm bài'),
      ),
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tạo chủ đề'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tên chủ đề',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              await FirestoreService.instance.addTopic(name);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}
