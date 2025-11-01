import 'package:flutter/material.dart';

class ChinhSachScreen extends StatelessWidget {
  const ChinhSachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chính sách bảo mật')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Ứng dụng cam kết bảo mật thông tin người dùng. '
          'Dữ liệu cá nhân được sử dụng chỉ nhằm mục đích học tập, '
          'không chia sẻ cho bên thứ ba.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
