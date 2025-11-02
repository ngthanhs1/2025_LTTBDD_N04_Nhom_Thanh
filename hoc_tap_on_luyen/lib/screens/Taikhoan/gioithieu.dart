import 'package:flutter/material.dart';

class GioiThieuScreen extends StatelessWidget {
  const GioiThieuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giới thiệu cá nhân')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _InfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Họ và tên',
                    value: 'Nguyễn Văn A',
                  ),
                  Divider(height: 1),
                  _InfoTile(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Mã SV',
                    value: '123456',
                  ),
                  Divider(height: 1),
                  _InfoTile(
                    icon: Icons.school_outlined,
                    label: 'Lớp',
                    value: 'CNTT K17A',
                  ),
                  Divider(height: 1),
                  _InfoTile(
                    icon: Icons.menu_book_outlined,
                    label: 'Môn học',
                    value: 'Lập trình thiết bị di động',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Giới thiệu',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ứng dụng học từ vựng giúp sinh viên luyện tập dễ dàng hơn.',
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      dense: true,
    );
  }
}
