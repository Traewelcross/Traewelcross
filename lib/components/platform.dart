import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class Platform extends StatelessWidget {
  const Platform({
    super.key,
    required this.platform,
    required this.plannedPlatform,
    required this.cancelled
  });

  final String platform;
  final String plannedPlatform;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    bool platformMoved = false;
    if (platform != plannedPlatform) {
      platformMoved = true;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: platformMoved || cancelled
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          child: Text(
            AppLocalizations.of(context)!.platformAbrv(platform),
            style: TextStyle(
              color: platformMoved || cancelled
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              decoration: cancelled ? .lineThrough : null,
              decorationColor: Theme.of(context).colorScheme.error
            ),
          ),
        ),
      ),
    );
  }
}
