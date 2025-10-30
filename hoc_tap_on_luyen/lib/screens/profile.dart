import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final email = user?.email ?? 'user@example.com';
    final name = email.split('@').first;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tài khoản',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Hồ sơ người dùng ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFDCE5FF),
                    child: Icon(Icons.person, color: Colors.indigo, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Danh sách chức năng ---
            _menuItem(Icons.person, 'Thông tin tài khoản', () {}),
            _menuItem(Icons.lock_outline, 'Đổi mật khẩu', () {}),
            _menuItem(Icons.language, 'Ngôn ngữ', () {}),
            _menuItem(Icons.privacy_tip_outlined, 'Chính sách bảo mật', () {}),

            const SizedBox(height: 10),

            // --- Nút đăng xuất ---
            _menuItem(Icons.logout, 'Đăng xuất', () async {
              await AuthService.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            }, color: Colors.red),

            const SizedBox(height: 20),
            const Text(
              'Phiên bản: 2.27.11',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget cho từng dòng menu ---
  Widget _menuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.black87,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.indigo),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
