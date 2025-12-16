import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class DefaultTextDialog extends StatelessWidget {
  const DefaultTextDialog({super.key});
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final config = getIt<Config>();
    final defaultTextController = TextEditingController(
      text: config.behavior.defaultStatusText,
    );
    return AlertDialog(
      icon: const Icon(Icons.text_format),
      title: Text(localize.defaultTextPreferenceTitle),
      content: TextField(
        controller: defaultTextController,
        maxLength: 280,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: localize.statusText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            config.behavior.defaultStatusText = defaultTextController.text;
            Navigator.pop(context);
          },
          child: Text(localize.save),
        ),
      ],
    );
  }
}
