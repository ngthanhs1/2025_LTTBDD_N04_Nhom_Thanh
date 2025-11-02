import 'package:flutter/material.dart';
import 'package:hoc_tap_on_luyen/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../services/locale_provider.dart';

class NgonNguScreen extends StatefulWidget {
  const NgonNguScreen({super.key});

  @override
  State<NgonNguScreen> createState() => _NgonNguScreenState();
}

class _NgonNguScreenState extends State<NgonNguScreen> {
  String _lang = 'vi';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cur = context.read<LocaleProvider>().locale;
      setState(() => _lang = cur?.languageCode ?? 'vi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).menuLanguage)),
      body: Column(
        children: [
          RadioListTile<String>(
            value: 'vi',
            groupValue: _lang,
            onChanged: (v) => setState(() => _lang = v!),
            title: Text(AppLocalizations.of(context).languageVietnamese),
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: _lang,
            onChanged: (v) => setState(() => _lang = v!),
            title: Text(AppLocalizations.of(context).languageEnglish),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<LocaleProvider>().setLocale(Locale(_lang));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context).languageChanged),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C4CE3),
              minimumSize: const Size(200, 45),
            ),
            child: Text(AppLocalizations.of(context).actionSave),
          ),
        ],
      ),
    );
  }
}
