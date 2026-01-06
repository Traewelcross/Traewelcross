import 'package:flutter/material.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class MiscPreferences extends StatefulWidget {
  const MiscPreferences({super.key});

  @override
  State<MiscPreferences> createState() => _MiscPreferencesState();
}

class _MiscPreferencesState extends State<MiscPreferences> {
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    Config config = getIt<Config>();
    return MainScaffold(
      title: Text(localize.behavior),
      body: ListView(
        children: [
          ListTile(
            onTap: () => setState(() {
              config.misc.showStats = !config.misc.showStats;
            }),
            leading: const Icon(Icons.bar_chart),
            title: Text(localize.stats),
            subtitle: Text(localize.statisticsExperimentalNote),
            trailing: Switch(
              value: config.misc.showStats,
              onChanged: (val) => setState(() {
                config.misc.showStats = val;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
