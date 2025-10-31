import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _topicCtrl = TextEditingController();
  final _qCtrl = TextEditingController();
  final _opts = List.generate(4, (_) => TextEditingController());
  int _correct = 0;
  final List<Map<String, dynamic>> _questions = [];
  bool _saving = false;

  @override
  void dispose() {
    _topicCtrl.dispose();
    _qCtrl.dispose();
    for (final c in _opts) c.dispose();
    super.dispose();
  }

  void _addQuestion() {
    if (_qCtrl.text.isEmpty || _opts.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ nội dung câu hỏi.')),
      );
      return;
    }
    setState(() {
      _questions.add({
        'text': _qCtrl.text.trim(),
        'options': _opts.map((e) => e.text.trim()).toList(),
        'correctIndex': _correct,
      });
      _qCtrl.clear();
      for (final c in _opts) c.clear();
      _correct = 0;
    });
  }

  Future<void> _saveTopic() async {
    if (_topicCtrl.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập tên chủ đề và ít nhất 1 câu hỏi.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      // ✅ FirestoreService trả về id chủ đề (đảm bảo Future hoạt động)
      final topicId = await FirestoreService.instance.addTopic(_topicCtrl.text);

      for (final q in _questions) {
        await FirestoreService.instance.addQuestion(
          topicId: topicId,
          text: q['text'],
          options: q['options'],
          correctIndex: q['correctIndex'],
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu chủ đề và câu hỏi!')),
      );

      Navigator.pop(context, true); // ✅ Trở về trang QuizHomeScreen
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi lưu: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo chủ đề & câu hỏi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _topicCtrl,
              decoration: const InputDecoration(
                labelText: 'Tên chủ đề',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _buildQuestionComposer(),
            const SizedBox(height: 16),
            if (_questions.isNotEmpty) ...[
              const Text(
                'Danh sách câu hỏi đã thêm:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._questions.asMap().entries.map((e) {
                final q = e.value;
                return Card(
                  child: ListTile(
                    title: Text('Câu ${e.key + 1}: ${q['text']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (i) {
                        final isCorrect = i == q['correctIndex'];
                        return Text(
                          '${String.fromCharCode(65 + i)}. ${q['options'][i]}'
                          '${isCorrect ? " ✅" : ""}',
                          style: TextStyle(
                            color: isCorrect ? Colors.green : Colors.black87,
                          ),
                        );
                      }),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          setState(() => _questions.removeAt(e.key)),
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 20),
            Center(
              child: FilledButton(
                onPressed: _saving ? null : _saveTopic,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: _saving
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Đang lưu...'),
                        ],
                      )
                    : const Text('Lưu chủ đề'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionComposer() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _qCtrl,
              decoration: const InputDecoration(
                labelText: 'Nội dung câu hỏi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(4, (i) {
              return RadioListTile<int>(
                value: i,
                groupValue: _correct,
                onChanged: (v) => setState(() => _correct = v!),
                title: TextField(
                  controller: _opts[i],
                  decoration: InputDecoration(
                    labelText: 'Đáp án ${String.fromCharCode(65 + i)}',
                  ),
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Thêm câu hỏi'),
                onPressed: _addQuestion,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
