import 'package:flutter/material.dart';

class ThongTinTkScreen extends StatelessWidget {
  const ThongTinTkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin tài khoản')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: tt@gmail.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Tên đăng nhập: tt', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Ngày tạo: 01/10/2025', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
