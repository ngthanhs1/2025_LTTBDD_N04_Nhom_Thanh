import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class AddQuestionScreen extends StatefulWidget {
  final String topicId;
  const AddQuestionScreen({super.key, required this.topicId});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textCtrl = TextEditingController();
  final _optCtrls = List.generate(4, (_) => TextEditingController());
  int _correctIndex = 0;
  bool _saving = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    for (final c in _optCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final options = _optCtrls.map((c) => c.text).toList();
      await FirestoreService.instance.addQuestion(
        topicId: widget.topicId,
        text: _textCtrl.text,
        options: options,
        correctIndex: _correctIndex,
      );
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã thêm câu hỏi.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm câu hỏi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _textCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nội dung câu hỏi',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Vui lòng nhập nội dung'
                    : null,
                maxLines: null,
              ),
              const SizedBox(height: 16),
              ...List.generate(4, (i) => _optionField(i)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionField(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<int>(
            value: i,
            groupValue: _correctIndex,
            onChanged: (v) => setState(() => _correctIndex = v ?? 0),
          ),
          Expanded(
            child: TextFormField(
              controller: _optCtrls[i],
              decoration: InputDecoration(
                labelText: 'Đáp án ${String.fromCharCode(65 + i)}',
                border: const OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Vui lòng nhập đáp án'
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
