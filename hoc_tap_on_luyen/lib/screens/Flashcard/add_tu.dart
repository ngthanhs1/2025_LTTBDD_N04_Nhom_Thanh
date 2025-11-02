import 'package:flutter/material.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';
import '../../models/flashcard.dart';
import '../../services/firestore_service.dart';

class AddTuScreen extends StatefulWidget {
  const AddTuScreen({super.key, required this.topic, this.card});

  final ChuDe topic;
  final Flashcard? card;

  @override
  State<AddTuScreen> createState() => _AddTuScreenState();
}

class _AddTuScreenState extends State<AddTuScreen> {
  final _frontCtr = TextEditingController();
  final _backCtr = TextEditingController();
  final _noteCtr = TextEditingController();
  bool _saving = false;
  bool get _isEditing => widget.card != null;

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _frontCtr.text = widget.card!.front;
      _backCtr.text = widget.card!.back;
      _noteCtr.text = widget.card!.note;
    }
  }

  Future<void> _save({bool pop = true}) async {
    final f = _frontCtr.text.trim();
    final b = _backCtr.text.trim();
    if (f.isEmpty || b.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).validationFrontBackRequired,
          ),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    if (_isEditing) {
      await FirestoreService.instance.updateFlashcard(
        topicId: widget.topic.id,
        cardId: widget.card!.id,
        front: f,
        back: b,
        note: _noteCtr.text.trim(),
      );
    } else {
      await FirestoreService.instance.addFlashcard(
        topicId: widget.topic.id,
        front: f,
        back: b,
        note: _noteCtr.text.trim(),
      );
    }

    if (!mounted) return;
    setState(() => _saving = false);

    if (pop) Navigator.pop(context);
    if (!_isEditing && !pop) {
      _frontCtr.clear();
      _backCtr.clear();
      _noteCtr.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).savedContinueAdding),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C4CE3),
        title: Text(
          _isEditing
              ? AppLocalizations.of(context).addWordTitleEdit
              : AppLocalizations.of(context).addWordTitleNew,
        ),
        actions: [
          if (!_isEditing)
            TextButton.icon(
              onPressed: _saving ? null : () => _save(pop: false),
              icon: const Icon(Icons.save_as_rounded, color: Colors.white),
              label: Text(
                AppLocalizations.of(context).saveAndCreate,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          TextButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_rounded, color: Colors.white),
            label: Text(
              AppLocalizations.of(context).actionSave,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _sectionTitle(AppLocalizations.of(context).labelFront),
          _bigInput(controller: _frontCtr, hint: '…'),
          const SizedBox(height: 16),
          _sectionTitle(AppLocalizations.of(context).labelBack),
          _bigInput(controller: _backCtr, hint: '…'),
          const SizedBox(height: 16),
          _sectionTitle(AppLocalizations.of(context).labelNote),
          _bigInput(controller: _noteCtr, hint: '…', maxLines: 5),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).actionCancel),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      t,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
    ),
  );

  Widget _bigInput({
    required TextEditingController controller,
    String hint = '',
    int maxLines = 4,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
