import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Plan - Flashcard'),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text(
          'Trang Flashcard (Study Plan)',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
