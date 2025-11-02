import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/flashcard.dart';
import '../../services/firestore_service.dart';
import 'add_chude.dart';
import 'flashcard_topic.dart';
import 'test_flashcard.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';

class FlashcardHomeScreen extends StatelessWidget {
  const FlashcardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C4CE3),
        title: Text(
          AppLocalizations.of(context).flashTitleFolders,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).flashBackup,
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).flashChecklist,
            icon: const Icon(Icons.checklist_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).flashSearch,
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6C4CE3),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const AddChuDeDialog(),
              );
              // Không cần setState; StreamBuilder tự update.
              // ok chỉ để bạn biết có lưu xong hay không nếu muốn hiển thị SnackBar.
              if (ok == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).flashCreatedFolder,
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(AppLocalizations.of(context).flashNew),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<ChuDe>>(
        stream: FirestoreService.instance.streamFlashTopics(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final topics = snap.data ?? [];
          if (topics.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context).flashNoFolders,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (_, i) => _TopicTile(topic: topics[i]),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: topics.length,
          );
        },
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});
  final ChuDe topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FlashcardTopicScreen(topic: topic)),
      ),
      child: Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.folder_open_rounded, color: Color(0xFF6C4CE3)),
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
                    DateFormat('yyyy-MM-dd HH:mm').format(topic.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            FutureBuilder<int>(
              future: FirestoreService.instance.countFlashcards(topic.id),
              builder: (_, s) => Row(
                children: [
                  const Icon(
                    Icons.layers_rounded,
                    color: Color.fromARGB(255, 111, 119, 118),
                  ),
                  const SizedBox(width: 4),
                  Text('${s.data ?? 0}'),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestFlashcardScreen(topic: topic),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context).flashPractice),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  tooltip: AppLocalizations.of(context).actionOptions,
                  onSelected: (value) async {
                    if (value == 'rename') {
                      final name = await _promptRename(
                        context,
                        initial: topic.name,
                        title: AppLocalizations.of(
                          context,
                        ).flashRenameFolderTitle,
                      );
                      if (name != null && name.trim().isNotEmpty) {
                        await FirestoreService.instance.updateFlashTopicName(
                          topicId: topic.id,
                          newName: name,
                        );
                      }
                    } else if (value == 'delete') {
                      final ok = await _confirmDelete(
                        context,
                        title: AppLocalizations.of(
                          context,
                        ).flashDeleteFolderTitle,
                        message: AppLocalizations.of(
                          context,
                        ).flashDeleteFolderConfirm,
                      );
                      if (ok == true) {
                        await FirestoreService.instance.deleteFlashTopic(
                          topic.id,
                        );
                      }
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'rename',
                      child: ListTile(
                        leading: const Icon(Icons.drive_file_rename_outline),
                        title: Text(AppLocalizations.of(ctx).actionRename),
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
                          AppLocalizations.of(ctx).actionDelete,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> _promptRename(
  BuildContext context, {
  required String initial,
  String? title,
}) {
  final ctr = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title ?? AppLocalizations.of(context).actionRename),
      content: TextField(
        controller: ctr,
        autofocus: true,
        decoration: const InputDecoration(),
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

Future<bool?> _confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
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
