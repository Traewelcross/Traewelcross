import 'package:material_ui/material_ui.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
    String? selectedLanguage = getIt<Config>().language.langCode;
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.language),
      title: Text(localize.language),
      content: RadioGroup<String?>(
        onChanged: (String? val) => setState(() => selectedLanguage = val),
        groupValue: selectedLanguage,
        child: Column(
          mainAxisSize: .min,
          children: [
            RadioListTile<String?>(value: null, title: Text(localize.lang_sys)),
            RadioListTile<String?>(value: "de", title: Text(localize.lang_de)),
            RadioListTile<String?>(value: "en", title: Text(localize.lang_en)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(localize.cancel)),
        FilledButton.icon(onPressed: () {
          getIt<Config>().language.langCode = selectedLanguage;
          TerminateRestart.instance.restartApp(options: .new(terminate: false));
        }, label: Text(localize.save), icon: const Icon(Icons.save)),
      ],
    );
  }
}
