import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class ManualTripInfo extends StatelessWidget {
  const ManualTripInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.info_outline),
      title: Text(localize.manualTripCreationTile),
      content: Text(localize.manualTripCreationDialogContent, textAlign: .center,),
      actions: [
        TextButton(onPressed: () {
          getIt<Config>().dialog.manualTripInfo = false;
          Navigator.pop(context);
        }, child: Text(localize.gotItDontShow)),
        FilledButton(onPressed: () => Navigator.pop(context), child: Text(localize.gotIt)),
      ],
      actionsOverflowAlignment: .center,
      actionsOverflowDirection: .up,
      actionsOverflowButtonSpacing: 5,
    );
  }
}
