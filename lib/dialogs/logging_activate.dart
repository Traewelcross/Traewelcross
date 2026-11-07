import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class LoggingActivate extends StatelessWidget {
  const LoggingActivate({super.key});
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.warning, size: 32),
      title: Text(localize.loggerActivateTitle),
      content: Text(localize.loggerActivateAlertContent, textAlign: .center),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context, true),
          label: Text(localize.loggerActivateTitle),
          icon: const Icon(Icons.check),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(localize.cancel),
        ),
      ],
      iconColor: Theme.of(context).colorScheme.error,
      actionsAlignment: .end,
      actionsOverflowAlignment: .center,
      actionsOverflowButtonSpacing: 8,
      actionsOverflowDirection: .up,
    );
  }
}
