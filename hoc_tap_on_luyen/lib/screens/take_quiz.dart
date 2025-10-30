import 'package:flutter/material.dart';

import '../models/quiz.dart';

class TakeQuizScreen extends StatefulWidget {
  final Topic topic;
  final List<Question> questions;
  const TakeQuizScreen({
    super.key,
    required this.topic,
    required this.questions,
  });

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  int _index = 0;
  final Map<int, int> _answers = {}; // questionIndex -> chosenOptionIndex

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Làm bài: ${widget.topic.name} (${_index + 1}/${widget.questions.length})',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ...List.generate(q.options.length, (i) {
              final selected = _answers[_index] == i;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Radio<int>(
                    value: i,
                    groupValue: _answers[_index],
                    onChanged: (v) => setState(() => _answers[_index] = v ?? i),
                  ),
                  title: Text(
                    '${String.fromCharCode(65 + i)}. ${q.options[i]}',
                  ),
                  tileColor: selected
                      ? Colors.indigo.withValues(alpha: 0.06)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () => setState(() => _answers[_index] = i),
                ),
              );
            }),
            const Spacer(),
            Row(
              children: [
                if (_index > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _index -= 1),
                    child: const Text('Quay lại'),
                  ),
                const Spacer(),
                if (_index < widget.questions.length - 1)
                  FilledButton(
                    onPressed: _answers.containsKey(_index)
                        ? () => setState(() => _index += 1)
                        : null,
                    child: const Text('Tiếp tục'),
                  )
                else
                  FilledButton.icon(
                    onPressed: _answers.length == widget.questions.length
                        ? _submit
                        : null,
                    icon: const Icon(Icons.flag),
                    label: const Text('Nộp bài'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    int correct = 0;
    for (var i = 0; i < widget.questions.length; i++) {
      final chosen = _answers[i];
      if (chosen != null && chosen == widget.questions[i].correctIndex) {
        correct++;
      }
    }
    final total = widget.questions.length;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Kết quả'),
        content: Text('Bạn đúng $correct/$total câu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Xem lại'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to topics
            },
            child: const Text('Hoàn thành'),
          ),
        ],
      ),
    );
  }
}
