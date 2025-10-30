import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ học tập'),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text(
          'Chào mừng bạn đến với ứng dụng học tập!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
