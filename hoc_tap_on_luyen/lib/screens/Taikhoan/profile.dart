import 'package:flutter/material.dart';
import 'gioithieu.dart';
import 'thongtin_tk.dart';
import 'quen_mk.dart';
import 'chinh_sach.dart';
import 'ngonngu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Tài khoản'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Thông tin user ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFE0E7FF),
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'tt',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 4),
                Text('tt@gmail.com', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- Các tùy chọn ---
          _ProfileOption(
            icon: Icons.info_outline,
            label: 'Giới thiệu cá nhân',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GioiThieuScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.person_outline,
            label: 'Thông tin tài khoản',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThongTinTkScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.lock_outline,
            label: 'Đổi mật khẩu',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoiMatKhauScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.language_rounded,
            label: 'Ngôn ngữ',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NgonNguScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.privacy_tip_outlined,
            label: 'Chính sách bảo mật',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChinhSachScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.logout_rounded,
            label: 'Đăng xuất',
            color: Colors.red,
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã đăng xuất')));
            },
          ),

          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Phiên bản: 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const _ProfileOption({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.indigo),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }
}
