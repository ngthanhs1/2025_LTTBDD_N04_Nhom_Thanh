import 'package:flutter/material.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';
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
    for (final o in _options) {
      o.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6C4CE3);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addQuestionTitle),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                        AppLocalizations.of(context).questionContent,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _question,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.help_outline),
                          hintText: AppLocalizations.of(context).enterQuestion,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? AppLocalizations.of(context).enterQuestion
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

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
                        AppLocalizations.of(context).answersLabel,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(4, (i) {
                        final label = String.fromCharCode(65 + i);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.grey.shade200,
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _options[i],
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(
                                      context,
                                    ).answerHint(label),
                                    border: InputBorder.none,
                                  ),
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                      ? AppLocalizations.of(context).enterAnswer
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 6),
                      Text(AppLocalizations.of(context).correctAnswer),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: List.generate(4, (i) {
                          final selected = _correct == i;
                          return ChoiceChip(
                            label: Text(String.fromCharCode(65 + i)),
                            selected: selected,
                            selectedColor: primary.withValues(alpha: .15),
                            labelStyle: TextStyle(
                              color: selected ? primary : Colors.black87,
                            ),
                            onSelected: (_) => setState(() => _correct = i),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _saveQuestion,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_rounded),
                  label: Text(
                    _saving
                        ? AppLocalizations.of(context).adding
                        : AppLocalizations.of(context).addQuestionTitle,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).addedQuestion)),
    );

    _question.clear();
    for (final o in _options) {
      o.clear();
    }
    setState(() {
      _correct = 0;
      _saving = false;
    });
  }
}
