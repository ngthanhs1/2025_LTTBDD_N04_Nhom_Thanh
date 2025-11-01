import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class AddChuDeDialog extends StatefulWidget {
  const AddChuDeDialog({super.key});

  @override
  State<AddChuDeDialog> createState() => _AddChuDeDialogState();
}

class _AddChuDeDialogState extends State<AddChuDeDialog> {
  final _ctrl = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    final name = _ctrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nhập tên thư mục')));
      return;
    }
    setState(() => _saving = true);
    try {
      await FirestoreService.instance.addFlashTopic(name);
      if (mounted) Navigator.pop(context, true); // báo thành công
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tạo thư mục mới',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Tên thư mục mới',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.add_rounded),
                    label: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Tạo thư mục'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CE3),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
