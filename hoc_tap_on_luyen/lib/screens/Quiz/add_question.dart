import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class AddQuestionScreen extends StatefulWidget {
  final String topicId;
  const AddQuestionScreen({super.key, required this.topicId});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _question = TextEditingController();
  final _options = List.generate(4, (_) => TextEditingController());
  int _correct = 0;
  bool _saving = false;

  @override
  void dispose() {
    _question.dispose();
    for (final o in _options) o.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm câu hỏi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _question,
                decoration: const InputDecoration(
                  labelText: 'Nội dung câu hỏi',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nhập nội dung câu hỏi'
                    : null,
              ),
              const SizedBox(height: 16),
              ...List.generate(4, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    controller: _options[i],
                    decoration: InputDecoration(
                      labelText: 'Đáp án ${String.fromCharCode(65 + i)}',
                      border: const OutlineInputBorder(),
                      suffixIcon: Radio<int>(
                        value: i,
                        groupValue: _correct,
                        onChanged: (v) => setState(() => _correct = v ?? 0),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Nhập đáp án' : null,
                  ),
                );
              }),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saving ? null : _saveQuestion,
                icon: const Icon(Icons.add),
                label: Text(_saving ? 'Đang lưu...' : 'Thêm câu hỏi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveQuestion() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await FirestoreService.instance.addQuestion(
      topicId: widget.topicId,
      text: _question.text,
      options: _options.map((e) => e.text).toList(),
      correctIndex: _correct,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm câu hỏi!')));

    _question.clear();
    for (final o in _options) o.clear();
    setState(() {
      _correct = 0;
      _saving = false;
    });
  }
}
