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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.name),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Câu ${currentIndex + 1}/${widget.questions.length}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              q.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List.generate(q.options.length, (i) {
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(q.options[i]),
                  onTap: () => _answerQuestion(i),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
