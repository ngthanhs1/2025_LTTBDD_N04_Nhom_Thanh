import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcard')),
      body: const Center(
        child: Text(
          'Màn hình Flashcard - nơi học từ vựng',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
