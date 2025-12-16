import 'package:flutter/material.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class SystemTimeOverride extends StatelessWidget {
  const SystemTimeOverride({super.key});
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final config = getIt<Config>();
    final timeTextController = TextEditingController(
      text: config.behavior.delaySystemTimeOverride.toString(),
    );
    return AlertDialog(
      icon: const Icon(Icons.access_time),
      title: Text(localize.delaySystemTimeOverride),
      content: TextField(
        controller: timeTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixText: localize.abrvMinute,
          label: Text(localize.delaySystemTimeOverrideTextField),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (timeTextController.text.isEmpty) {
              config.behavior.delaySystemTimeOverride = -1;
              Navigator.pop(context);
              return;
            }
            config.behavior.delaySystemTimeOverride =
                int.tryParse((timeTextController.text)) ??
                config.behavior.delaySystemTimeOverride;
            Navigator.pop(context);
          },
          child: Text(localize.save),
        ),
      ],
    );
  }
}
