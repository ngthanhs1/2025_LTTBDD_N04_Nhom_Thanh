import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'gioithieu.dart';
import 'thongtin_tk.dart';
import 'quen_mk.dart';
import 'chinh_sach.dart';
import 'ngonngu.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).titleAccount),
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
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                final user = snapshot.data ?? FirebaseAuth.instance.currentUser;
                final email = user?.email ?? '';
                final displayName =
                    (user?.displayName != null &&
                        user!.displayName!.trim().isNotEmpty)
                    ? user.displayName!.trim()
                    : (email.isNotEmpty ? email.split('@').first : 'User');
                return Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFFE0E7FF),
                      child: Icon(Icons.person, size: 40, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email.isNotEmpty ? email : '—',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // --- Các tùy chọn ---
          _ProfileOption(
            icon: Icons.info_outline,
            label: AppLocalizations.of(context).menuAbout,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GioiThieuScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.person_outline,
            label: AppLocalizations.of(context).menuAccountInfo,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThongTinTkScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.lock_outline,
            label: AppLocalizations.of(context).menuChangePassword,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DoiMatKhauScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.language_rounded,
            label: AppLocalizations.of(context).menuLanguage,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NgonNguScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.privacy_tip_outlined,
            label: AppLocalizations.of(context).menuPrivacy,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChinhSachScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.logout_rounded,
            label: AppLocalizations.of(context).menuLogout,
            color: Colors.red,
            onTap: () async {
              try {
                await AuthService.instance.signOut();
              } catch (_) {}
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),

          const SizedBox(height: 20),
          Center(
            child: Text(
              AppLocalizations.of(context).versionLabel('1.0.0'),
              style: const TextStyle(color: Colors.grey),
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
