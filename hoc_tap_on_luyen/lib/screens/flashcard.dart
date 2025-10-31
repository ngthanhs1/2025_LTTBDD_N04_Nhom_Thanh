import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/quiz.dart';
import 'create_topic.dart';
import 'topic_detail.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Study Plan - Flashcard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Thêm chủ đề',
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateTopicScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng quan học tập',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isNarrow ? 2.0 : 2.2,
              children: [
                _statCard(
                  'Tổng số chủ đề',
                  Icons.menu_book_outlined,
                  Colors.indigo,
                ),
                _statCard('Tổng số thẻ', Icons.style, Colors.blue),
                _statCard('Đã học', Icons.check_circle, Colors.green),
                _statCard('Còn lại', Icons.hourglass_bottom, Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Danh sách chủ đề',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<Topic>>(
              stream: FirestoreService.instance.streamTopics(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final topics = snap.data ?? const <Topic>[];
                if (topics.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('Chưa có chủ đề nào. Hãy bấm dấu + để thêm.'),
                    ),
                  );
                }
                return Column(
                  children: topics.map((t) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.menu_book_outlined,
                          color: Colors.indigo,
                        ),
                        title: Text(
                          t.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: FutureBuilder<int>(
                          future: FirestoreService.instance.countQuestions(
                            t.id,
                          ),
                          builder: (context, c) => Text('${c.data ?? 0} thẻ'),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TopicDetailScreen(topic: t),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
