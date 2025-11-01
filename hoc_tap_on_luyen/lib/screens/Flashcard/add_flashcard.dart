import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  bool _saving = false;

  Future<void> _saveFlashcard() async {
    final front = _frontController.text.trim();
    final back = _backController.text.trim();

    if (front.isEmpty || back.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ 2 mặt thẻ!")),
      );
      return;
    }

    setState(() => _saving = true);

    await FirestoreService.instance.addFlashcard(front, back);

    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã lưu thẻ thành công!")));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm Flashcard"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _frontController,
              decoration: const InputDecoration(
                labelText: "Mặt trước (Từ / Câu hỏi)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _backController,
              decoration: const InputDecoration(
                labelText: "Mặt sau (Nghĩa / Đáp án)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(_saving ? "Đang lưu..." : "Lưu thẻ"),
                onPressed: _saving ? null : _saveFlashcard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
