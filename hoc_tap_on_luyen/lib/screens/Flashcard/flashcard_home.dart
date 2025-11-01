import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/flashcard.dart';
import '../../services/firestore_service.dart';
import 'add_chude.dart';
import 'flashcard_topic.dart';

class FlashcardHomeScreen extends StatelessWidget {
  const FlashcardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C4CE3),
        title: const Text(
          'Thư mục',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Sao lưu',
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Đỗ',
            icon: const Icon(Icons.checklist_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Tìm kiếm',
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6C4CE3),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const AddChuDeDialog(),
              );
              // Không cần setState; StreamBuilder tự update.
              // ok chỉ để bạn biết có lưu xong hay không nếu muốn hiển thị SnackBar.
              if (ok == true && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Đã tạo thư mục')));
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Mới'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<ChuDe>>(
        stream: FirestoreService.instance.streamFlashTopics(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final topics = snap.data ?? [];
          if (topics.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có thư mục nào.\nNhấn "Mới" để tạo',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (_, i) => _TopicTile(topic: topics[i]),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: topics.length,
          );
        },
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});
  final ChuDe topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FlashcardTopicScreen(topic: topic)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.folder_open_rounded, color: Color(0xFF6C4CE3)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(topic.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            FutureBuilder<int>(
              future: FirestoreService.instance.countFlashcards(topic.id),
              builder: (_, s) => Row(
                children: [
                  const Icon(
                    Icons.layers_rounded,
                    color: Colors.teal,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text('${s.data ?? 0}'),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.favorite_rounded,
                    color: Colors.pinkAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  const Text('1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
