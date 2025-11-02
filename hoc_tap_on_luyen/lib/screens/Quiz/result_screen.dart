import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int total;
  final int correct;
  final String topicName;

  const QuizResultScreen({
    super.key,
    required this.total,
    required this.correct,
    required this.topicName,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (correct / total) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả - $topicName'),
        backgroundColor: const Color.fromARGB(255, 117, 115, 126),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                "Bạn đã trả lời đúng $correct / $total câu",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tỷ lệ chính xác: ${percent.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 18,
                  color: percent >= 70 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("Về trang chủ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CE3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
