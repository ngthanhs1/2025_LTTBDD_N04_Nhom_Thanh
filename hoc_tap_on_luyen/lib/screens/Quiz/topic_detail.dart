import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/quiz.dart';
import '../../services/firestore_service.dart';
import 'add_question.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).topicDetailTitle(topic.name)),
        centerTitle: true,
        // Use default themed AppBar; keep icons readable
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).tooltipAddQuestion,
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddQuestionScreen(topicId: topic.id),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Question>>(
        stream: FirestoreService.instance.streamQuestions(topic.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context).errorLoadingQuestions),
            );
          }

          final questions = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(Icons.folder_open_rounded, color: primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AppLocalizations.of(context).labelCreatedAt}: ${DateFormat('yyyy-MM-dd HH:mm').format(topic.createdAt)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).labelQuestionsCount(questions.length),
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (questions.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).topicEmpty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...List.generate(questions.length, (i) {
                  final q = questions[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: primary.withValues(alpha: .12),
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  q.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await _showEditQuestionSheet(
                                      context: context,
                                      topicId: topic.id,
                                      question: q,
                                    );
                                  } else if (value == 'delete') {
                                    final ok = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).actionDelete,
                                        ),
                                        content: Text('Xóa câu hỏi này?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              ).actionCancel,
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              ).actionDelete,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (ok == true) {
                                      await FirestoreService.instance
                                          .deleteQuestion(
                                            topicId: topic.id,
                                            questionId: q.id,
                                          );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.of(
                                                context,
                                              ).quizDeleted,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: const Icon(Icons.edit_outlined),
                                      title: Text(
                                        AppLocalizations.of(context).actionSave,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      title: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).actionDelete,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(q.options.length, (idx) {
                            final isCorrect = idx == q.correctIndex;
                            final label = String.fromCharCode(65 + idx);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green.withValues(alpha: .06)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isCorrect
                                      ? Colors.green.withValues(alpha: .3)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: isCorrect
                                        ? Colors.green.withValues(alpha: .2)
                                        : Colors.grey.shade200,
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isCorrect
                                            ? Colors.green.shade800
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      q.options[idx],
                                      style: TextStyle(
                                        color: isCorrect
                                            ? Colors.green.shade800
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (isCorrect)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _showEditQuestionSheet({
  required BuildContext context,
  required String topicId,
  required Question question,
}) async {
  final primary = Theme.of(context).colorScheme.primary;
  final ctrQ = TextEditingController(text: question.text);
  final ctrs = List.generate(
    4,
    (i) => TextEditingController(
      text: i < question.options.length ? question.options[i] : '',
    ),
  );
  int correct = question.correctIndex;
  bool saving = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final bottom = MediaQuery.of(ctx).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Chỉnh sửa câu hỏi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ctrQ,
                    maxLines: null,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.help_outline),
                      hintText: 'Nhập câu hỏi...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(4, (i) {
                    final label = String.fromCharCode(65 + i);
                    final selected = correct == i;
                    return InkWell(
                      onTap: () => setState(() => correct = i),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
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
                            Expanded(
                              child: TextField(
                                controller: ctrs[i],
                                decoration: InputDecoration(
                                  hintText: 'Đáp án $label',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
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
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: saving
                          ? null
                          : () async {
                              final text = ctrQ.text.trim();
                              final ops = ctrs
                                  .map((e) => e.text.trim())
                                  .toList();
                              if (text.isEmpty || ops.any((e) => e.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Vui lòng nhập câu hỏi và đủ 4 đáp án.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              setState(() => saving = true);
                              await FirestoreService.instance.updateQuestion(
                                topicId: topicId,
                                questionId: question.id,
                                text: text,
                                options: ops,
                                correctIndex: correct,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(context).quizSaved,
                                    ),
                                  ),
                                );
                              }
                            },
                      icon: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(AppLocalizations.of(context).actionSave),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
