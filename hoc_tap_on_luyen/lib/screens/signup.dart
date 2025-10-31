import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != _password2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu nhập lại không khớp')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.instance.signUp(
        email: _email.text,
        password: _password.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      if (e.code == 'email-already-in-use') {
        msg = 'Email đã tồn tại.';
      } else if (e.code == 'invalid-email') {
        msg = 'Email không hợp lệ.';
      } else if (e.code == 'weak-password') {
        msg = 'Mật khẩu yếu (tối thiểu 6 ký tự).';
      } else {
        msg = 'Đăng ký thất bại: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E0854), // tím đậm
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create your Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _email,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Enter your email id"),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Email không hợp lệ'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Your Password", true),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Tối thiểu 6 ký tự' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _password2,
                  obscureText: _obscure,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Re-enter Password", true),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Tối thiểu 6 ký tự' : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _loading ? null : _signup,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Register", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text(
                    "Already have an account ? Login",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, [bool isPassword = false]) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _obscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            )
          : null,
    );
  }
}
