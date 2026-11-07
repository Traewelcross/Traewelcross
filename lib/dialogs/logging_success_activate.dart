import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class LoggingSuccessActivate extends StatelessWidget {
  const LoggingSuccessActivate({super.key});
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.warning, size: 42,),
      title: Text(localize.loggerAlsoSuccessTitle),
      content: Text(localize.loggerAlsoSuccessAlertContent, textAlign: .center),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(localize.loggerAlsoSuccessTitle, textAlign: .center,),
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
