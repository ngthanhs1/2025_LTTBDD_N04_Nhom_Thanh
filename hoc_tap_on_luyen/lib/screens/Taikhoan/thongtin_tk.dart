import 'package:flutter/material.dart';

class ThongTinTkScreen extends StatelessWidget {
  const ThongTinTkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin tài khoản')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoTile(
                    icon: Icons.alternate_email,
                    label: 'Email',
                    value: 'tt@gmail.com',
                  ),
                  Divider(height: 1),
                  _InfoTile(
                    icon: Icons.person_outline,
                    label: 'Tên đăng nhập',
                    value: 'tt',
                  ),
                  Divider(height: 1),
                  _InfoTile(
                    icon: Icons.event_available_outlined,
                    label: 'Ngày tạo',
                    value: '01/10/2025',
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
