import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import '../../services/firestore_service.dart';
import 'result_screen.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';

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
  late final List<int?> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<int?>.filled(widget.questions.length, null);
  }

  Future<void> _submit() async {
    final total = widget.questions.length;
    final correct = List.generate(total, (i) {
      final sel = _selected[i];
      return sel != null && sel == widget.questions[i].correctIndex ? 1 : 0;
    }).fold<int>(0, (a, b) => a + b);
    final wrong = (total - correct).clamp(0, total);

    await FirestoreService.instance.addQuizSession(
      topicId: widget.topic.id,
      topicName: widget.topic.name,
      total: total,
      correct: correct,
      wrong: wrong,
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          total: total,
          correct: correct,
          topicName: widget.topic.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final answered = _selected.where((e) => e != null).length;
    final progress = widget.questions.isEmpty
        ? 0.0
        : answered / widget.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(widget.topic.name),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(AppLocalizations.of(context).quizSubmitTitle),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        ).quizSubmitConfirm(answered, widget.questions.length),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(AppLocalizations.of(context).quizSubmit),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            AppLocalizations.of(context).actionCancel,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              if (ok == true) {
                await _submit();
              }
            },
            icon: Icon(
              Icons.send_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(
              AppLocalizations.of(context).quizSubmit,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header progress
            Row(
              children: [
                Text(
                  'Đã chọn: $answered/${widget.questions.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            // All questions list
            Expanded(
              child: ListView.separated(
                itemCount: widget.questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final q = widget.questions[index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: primary.withValues(alpha: .1),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  q.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(q.options.length, (i) {
                            final label = String.fromCharCode(65 + i);
                            final selected = _selected[index] == i;
                            return InkWell(
                              onTap: () => setState(() => _selected[index] = i),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? primary.withValues(alpha: .6)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: selected
                                          ? primary.withValues(alpha: .15)
                                          : Colors.grey.shade200,
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selected
                                              ? primary
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(q.options[i])),
                                    SizedBox(
                                      width: 26,
                                      child: Icon(
                                        selected
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: selected
                                            ? primary
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
