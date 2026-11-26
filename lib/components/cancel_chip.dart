import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class CancelChip extends StatelessWidget {
  const CancelChip({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          child: Text(
            AppLocalizations.of(context)!.stopCancelled,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
    );
  }
}
