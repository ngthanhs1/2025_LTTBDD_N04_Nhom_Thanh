import 'package:flutter/material.dart';

class DoiMatKhauScreen extends StatefulWidget {
  const DoiMatKhauScreen({super.key});

  @override
  State<DoiMatKhauScreen> createState() => _DoiMatKhauScreenState();
}

class _DoiMatKhauScreenState extends State<DoiMatKhauScreen> {
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput('Mật khẩu cũ', _oldPass, obscure: true),
            _buildInput('Mật khẩu mới', _newPass, obscure: true),
            _buildInput('Xác nhận mật khẩu', _confirm, obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_newPass.text == _confirm.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đổi mật khẩu thành công')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu không trùng khớp')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 209, 208, 212),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController ctr, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctr,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
