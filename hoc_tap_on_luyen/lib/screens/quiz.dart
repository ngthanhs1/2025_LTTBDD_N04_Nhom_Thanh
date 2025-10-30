import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: const Center(
        child: Text(
          'Màn hình Quiz - kiểm tra từ vựng',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
