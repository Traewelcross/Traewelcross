import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class LoggingBodyActivate extends StatelessWidget {
  const LoggingBodyActivate({super.key});
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.warning,),
      title: Text(localize.loggerAlsoBodyTitle),
      content: Text(localize.loggerAlsoBodyAlertContent, textAlign: .center),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(localize.loggerAlsoBodyTitle, textAlign: .center,),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(localize.cancel),
        ),
      ],
      actionsAlignment: .end,
      actionsOverflowAlignment: .center,
      actionsOverflowButtonSpacing: 8,
      actionsOverflowDirection: .up,
    );
  }
}
