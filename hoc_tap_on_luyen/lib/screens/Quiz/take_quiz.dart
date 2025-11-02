import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import '../../services/firestore_service.dart';
import 'result_screen.dart';

class TakeQuizScreen extends StatefulWidget {
  final Topic topic;
  final List<Question> questions;

  const TakeQuizScreen({
    super.key,
    required this.topic,
    required this.questions,
  });

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  int currentIndex = 0;
  int correctAnswers = 0;

  void _answerQuestion(int selectedIndex) {
    if (widget.questions[currentIndex].correctIndex == selectedIndex) {
      correctAnswers++;
    }

    if (currentIndex < widget.questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      final total = widget.questions.length;
      final wrong = (total - correctAnswers).clamp(0, total);
      FirestoreService.instance.addQuizSession(
        topicId: widget.topic.id,
        topicName: widget.topic.name,
        total: total,
        correct: correctAnswers,
        wrong: wrong,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            total: widget.questions.length,
            correct: correctAnswers,
            topicName: widget.topic.name,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[currentIndex];

    const primary = Color(0xFF6C4CE3);
    final progress = (currentIndex + 1) / widget.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: Text(widget.topic.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header progress
            Row(
              children: [
                Text(
                  'Câu ${currentIndex + 1}/${widget.questions.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Question
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  q.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Options
            ...List.generate(q.options.length, (i) {
              final label = String.fromCharCode(65 + i);
              return InkWell(
                onTap: () => _answerQuestion(i),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: primary.withValues(alpha: .1),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            q.options[i],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
