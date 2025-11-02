import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/quiz.dart';
import '../../services/firestore_service.dart';
import 'create_topic.dart';
import 'topic_detail.dart';
import 'take_quiz.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';

class QuizHomeScreen extends StatelessWidget {
  const QuizHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color.fromARGB(255, 131, 129, 138);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).quizHomeTitle),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 97, 95, 105),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).quizCreateNewTopic,
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final saved = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateTopicScreen()),
              );
              if (saved == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).quizTopicAdded),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Topic>>(
        stream: FirestoreService.instance.streamTopics(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context).errorLoading),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final topics = snapshot.data ?? [];

          if (topics.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context).noTopics,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: topics.length,
            itemBuilder: (context, i) {
              final topic = topics[i];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.folder_open_rounded,
                    color: primary,
                  ),
                  title: Text(
                    topic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).labelCreatedAt}: ${DateFormat('yyyy-MM-dd HH:mm').format(topic.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                      FutureBuilder<int>(
                        future: FirestoreService.instance.countQuestions(
                          topic.id,
                        ),
                        builder: (context, snap) {
                          return Text(
                            AppLocalizations.of(
                              context,
                            ).labelQuestionsCount((snap.data ?? 0).toString()),
                            style: TextStyle(color: Colors.grey.shade800),
                          );
                        },
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: primary,
                          size: 28,
                        ),
                        tooltip: AppLocalizations.of(context).quizPlay,
                        onPressed: () async {
                          final questions = await FirestoreService.instance
                              .getQuestions(topic.id);
                          if (questions.isEmpty && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context).quizTopicEmpty,
                                ),
                              ),
                            );
                            return;
                          }
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TakeQuizScreen(
                                topic: topic,
                                questions: questions,
                              ),
                            ),
                          );
                        },
                      ),
                      PopupMenuButton<String>(
                        tooltip: AppLocalizations.of(context).actionOptions,
                        onSelected: (value) async {
                          if (value == 'rename') {
                            final name = await _promptRename(
                              context,
                              initial: topic.name,
                              title: AppLocalizations.of(
                                context,
                              ).quizRenameTopicTitle,
                            );
                            if (name != null && name.trim().isNotEmpty) {
                              await FirestoreService.instance
                                  .updateQuizTopicName(
                                    topicId: topic.id,
                                    newName: name,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(context).quizSaved,
                                    ),
                                  ),
                                );
                              }
                            }
                          } else if (value == 'delete') {
                            final ok = await _confirmDelete(
                              context,
                              message: AppLocalizations.of(
                                context,
                              ).quizDeleteTopicConfirm,
                            );
                            if (ok == true) {
                              await FirestoreService.instance.deleteQuizTopic(
                                topic.id,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(context).quizDeleted,
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: 'rename',
                            child: ListTile(
                              leading: const Icon(
                                Icons.drive_file_rename_outline,
                              ),
                              title: Text(
                                AppLocalizations.of(context).actionRename,
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
                                AppLocalizations.of(context).actionDelete,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TopicDetailScreen(topic: topic),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<String?> _promptRename(
  BuildContext context, {
  required String initial,
  String title = 'Rename',
}) async {
  final ctr = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctr,
        autofocus: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).quizNewNameHint,
        ),
        onSubmitted: (_) => Navigator.pop(context, ctr.text.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).actionCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, ctr.text.trim()),
          child: Text(AppLocalizations.of(context).actionSave),
        ),
      ],
    ),
  );
}

Future<bool?> _confirmDelete(BuildContext context, {required String message}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(AppLocalizations.of(context).quizDeleteTopicTitle),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context).actionCancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context).actionDelete),
        ),
      ],
    ),
  );
}
