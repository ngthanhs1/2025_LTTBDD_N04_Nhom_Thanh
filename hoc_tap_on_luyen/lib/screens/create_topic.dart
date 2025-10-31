import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _topicCtrl = TextEditingController();
  final _questionCtrl = TextEditingController();
  final _optCtrls = List.generate(4, (_) => TextEditingController());
  int _correctIndex = 0;
  bool _saving = false;
  final List<_QuestionDraft> _drafts = [];

  @override
  void dispose() {
    _topicCtrl.dispose();
    _questionCtrl.dispose();
    for (final c in _optCtrls) c.dispose();
    super.dispose();
  }

  void _addDraft() {
    final text = _questionCtrl.text.trim();
    final options = _optCtrls.map((c) => c.text.trim()).toList();

    if (text.isEmpty || options.any((o) => o.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ câu hỏi và 4 đáp án')),
      );
      return;
    }

    setState(() {
      _drafts.add(
        _QuestionDraft(
          text: text,
          options: options,
          correctIndex: _correctIndex,
        ),
      );
      _questionCtrl.clear();
      for (final c in _optCtrls) c.clear();
      _correctIndex = 0;
    });
  }

  Future<void> _saveTopic() async {
    final name = _topicCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nhập tên chủ đề')));
      return;
    }
    if (_drafts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Thêm ít nhất 1 câu hỏi')));
      return;
    }

    setState(() => _saving = true);

    try {
      final topicId = await FirestoreService.instance.addTopic(name);

      // ✅ Lưu toàn bộ câu hỏi song song
      await Future.wait(
        _drafts.map((q) async {
          await FirestoreService.instance.addQuestion(
            topicId: topicId,
            text: q.text,
            options: q.options,
            correctIndex: q.correctIndex,
          );
        }),
      );

      if (!mounted) return;

      // ✅ Ẩn loading và ẩn SnackBar cũ (nếu có)
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // ✅ Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu chủ đề và câu hỏi thành công!')),
      );

      // ✅ Pop sau khi UI ổn định (delay + rootNavigator)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop(true);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi lưu: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo chủ đề & câu hỏi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saving ? null : _saveTopic,
          ),
        ],
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
            const SizedBox(height: 20),
            _questionForm(),
            const SizedBox(height: 24),
            _draftList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _saveTopic,
        icon: _saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save),
        label: Text(_saving ? 'Đang lưu...' : 'Lưu chủ đề'),
      ),
    );
  }

  Widget _questionForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thêm câu hỏi mới',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _questionCtrl,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Nội dung câu hỏi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Đáp án (tick chọn đúng):'),
            const SizedBox(height: 8),
            ...List.generate(4, (i) => _optionField(i)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addDraft,
                icon: const Icon(Icons.add),
                label: const Text('Thêm vào danh sách'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionField(int i) {
    return Row(
      children: [
        Radio<int>(
          value: i,
          groupValue: _correctIndex,
          onChanged: (v) => setState(() => _correctIndex = v ?? 0),
        ),
        Expanded(
          child: TextField(
            controller: _optCtrls[i],
            decoration: InputDecoration(
              labelText: 'Đáp án ${String.fromCharCode(65 + i)}',
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _draftList() {
    if (_drafts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Chưa có câu hỏi nào.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh sách câu hỏi đã thêm:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ..._drafts.asMap().entries.map((e) => _draftTile(e.key, e.value)),
      ],
    );
  }

  Widget _draftTile(int index, _QuestionDraft q) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          'Câu ${index + 1}: ${q.text}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(q.options.length, (i) {
            final isCorrect = i == q.correctIndex;
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                '${String.fromCharCode(65 + i)}. ${q.options[i]}'
                '${isCorrect ? ' ✅' : ''}',
                style: TextStyle(
                  color: isCorrect ? Colors.green[700] : null,
                  fontWeight: isCorrect ? FontWeight.w600 : null,
                ),
              ),
            );
          }),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => setState(() => _drafts.removeAt(index)),
        ),
      ),
    );
  }
}

class _QuestionDraft {
  final String text;
  final List<String> options;
  final int correctIndex;
  _QuestionDraft({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}
