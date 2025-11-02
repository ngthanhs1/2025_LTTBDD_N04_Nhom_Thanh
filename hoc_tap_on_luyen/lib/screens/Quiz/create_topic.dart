import 'package:flutter/material.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';
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
    for (final c in _opts) {
      c.dispose();
    }
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
      for (final c in _opts) {
        c.clear();
      }
      _correct = 0;
    });
  }

  Future<void> _saveTopic() async {
    if (_topicCtrl.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).enterTopicAndOneQuestion),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
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
        SnackBar(
          content: Text(AppLocalizations.of(context).savedTopicAndQuestions),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).errorSavingWithMessage('$e'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6C4CE3);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addTopicAndQuestionsTitle),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chủ đề
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).topicInfo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _topicCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.folder_outlined),
                        labelText: AppLocalizations.of(context).topicNameLabel,
                        hintText: AppLocalizations.of(context).topicNameHint,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Soạn câu hỏi
            _buildQuestionComposer(),

            const SizedBox(height: 16),

            // Danh sách câu hỏi đã thêm
            if (_questions.isNotEmpty) ...[
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).addedQuestionsTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._questions.asMap().entries.map((e) {
                        final q = e.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            title: Text(
                              'Câu ${e.key + 1}: ${q['text']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(4, (i) {
                                  final isCorrect = i == q['correctIndex'];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isCorrect
                                                ? Colors.green.withValues(
                                                    alpha: .1,
                                                  )
                                                : Colors.grey.withValues(
                                                    alpha: .1,
                                                  ),
                                          ),
                                          child: Text(
                                            String.fromCharCode(65 + i),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isCorrect
                                                  ? Colors.green
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            q['options'][i],
                                            style: TextStyle(
                                              color: isCorrect
                                                  ? Colors.green.shade700
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
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  setState(() => _questions.removeAt(e.key)),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Lưu chủ đề
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveTopic,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded),
                label: Text(
                  _saving
                      ? AppLocalizations.of(context).savingEllipsis
                      : AppLocalizations.of(context).saveTopic,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionComposer() {
    const primary = Color(0xFF6C4CE3);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).composeQuestionTitle,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _qCtrl,
              maxLines: null,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.help_outline),
                labelText: AppLocalizations.of(context).questionContent,
                hintText: AppLocalizations.of(context).enterQuestion,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(4, (i) {
              final label = String.fromCharCode(65 + i);
              final isCorrect = _correct == i;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect
                        ? primary.withValues(alpha: .5)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isCorrect
                          ? primary.withValues(alpha: .15)
                          : Colors.grey.shade200,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? primary : Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _opts[i],
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            context,
                          ).answerHint(label),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ChoiceChip(
                      selected: isCorrect,
                      label: Text(AppLocalizations.of(context).correctAnswer),
                      selectedColor: primary.withValues(alpha: .15),
                      labelStyle: TextStyle(
                        color: isCorrect ? primary : Colors.black87,
                      ),
                      onSelected: (_) => setState(() => _correct = i),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add_rounded),
                label: Text(AppLocalizations.of(context).addQuestionTitle),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
