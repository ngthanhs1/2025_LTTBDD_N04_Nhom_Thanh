import 'package:flutter/material.dart';

class GioiThieuScreen extends StatelessWidget {
  const GioiThieuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giới thiệu cá nhân')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Họ tên: Nguyễn Văn A\n'
          'Mã SV: 123456\n'
          'Lớp: CNTT K17A\n'
          'Môn học: Lập trình thiết bị di động\n'
          '\nỨng dụng học từ vựng giúp sinh viên luyện tập dễ dàng hơn.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
