import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class CancelledConnectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.warning,),
      iconColor: Colors.amber,
      title: Text(localize.warning),
      content: Text(localize.connectionOrStationCancelled, textAlign: .center,),
      actions: [
        FilledButton(onPressed: () => Navigator.pop(context, false), child: Text(localize.cancel)),
        const SizedBox(height: 8,),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(localize.ignoreAndProceed))
      ],
      actionsAlignment: .center,
      actionsOverflowAlignment: .center,
    );
  }
}