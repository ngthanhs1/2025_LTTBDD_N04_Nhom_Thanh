import 'package:flutter/material.dart';

class NgonNguScreen extends StatefulWidget {
  const NgonNguScreen({super.key});

  @override
  State<NgonNguScreen> createState() => _NgonNguScreenState();
}

class _NgonNguScreenState extends State<NgonNguScreen> {
  String _lang = 'vi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ngôn ngữ')),
      body: Column(
        children: [
          RadioListTile<String>(
            value: 'vi',
            groupValue: _lang,
            onChanged: (v) => setState(() => _lang = v!),
            title: const Text('Tiếng Việt'),
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: _lang,
            onChanged: (v) => setState(() => _lang = v!),
            title: const Text('English'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Đã chuyển sang: ${_lang == 'vi' ? 'Tiếng Việt' : 'English'}',
                  ),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CE3),
              minimumSize: const Size(200, 45),
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
