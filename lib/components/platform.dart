import 'package:flutter/material.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class Platform extends StatelessWidget {
  const Platform({
    super.key,
    required this.platform,
    required this.plannedPlatform,
  });

  final String platform;
  final String plannedPlatform;

  @override
  Widget build(BuildContext context) {
    bool platformMoved = false;
    if (platform != plannedPlatform) {
      platformMoved = true;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: platformMoved
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          child: Text(
            AppLocalizations.of(context)!.platformAbrv(platform),
            style: TextStyle(
              color: platformMoved
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
