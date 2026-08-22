import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/enums/alert_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.text,
    required this.type,
    this.url,
    this.title,
    this.size
  });

  final String text;
  final AlertTypes type;
  final String? url;
  final String? title;
  final double? size;
  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      .info =>  Icon(Icons.info, size: size ?? 32),
      .warning =>  Icon(Icons.warning, size: size ?? 32),
      .danger =>  Icon(Icons.dangerous, size: size ?? 32),
      .success =>  Icon(Icons.check, size: size ?? 32),
    };

    return Card.filled(
      color: switch (type) {
        .info => Color.alphaBlend(
          Colors.blue.withValues(alpha: 0.2),
          Theme.of(context).colorScheme.surface,
        ),
        .warning => Color.alphaBlend(
          Colors.yellow.withValues(alpha: 0.2),
          Theme.of(context).colorScheme.surface,
        ),
        .danger => Color.alphaBlend(
          Colors.red.withValues(alpha: 0.2),
          Theme.of(context).colorScheme.surface,
        ),
        .success => Color.alphaBlend(
          Colors.greenAccent.shade400.withValues(alpha: 0.2),
          Theme.of(context).colorScheme.surface,
        ),
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 4,
          crossAxisAlignment: .start,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const Divider(height: 4),
              Text(text),
            ] else ...[
              Row(
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(text),
                  ),
                ],
              ),
            ],
            if (url != null)
              Row(
                mainAxisAlignment: .end,
                children: [
                  FilledButton.icon(
                    onPressed: () => SharedFunctions.launchURL(Uri.parse(url!)),
                    icon: const Icon(Icons.open_in_new),
                    label: Text(AppLocalizations.of(context)!.openExternal),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
