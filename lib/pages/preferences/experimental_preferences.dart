import 'dart:io';

import 'package:flutter/material.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class ExperimentalPreferences extends StatefulWidget {
  const ExperimentalPreferences({super.key});

  @override
  State<ExperimentalPreferences> createState() =>
      _ExperimentalPreferencesState();
}

class _ExperimentalPreferencesState extends State<ExperimentalPreferences> {
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    Config config = getIt<Config>();
    return MainScaffold(
      title: Text(localize.behavior),
      body: ListView(
        children: [
          if (Platform.isAndroid)
            ListTile(
              onTap: () => setState(() {
                config.behavior.volumeBtnCtrl = !config.behavior.volumeBtnCtrl;
              }),
              leading: const Icon(Icons.music_note),
              title: Text(localize.volumeBtnCtrl),
              subtitle: Text(localize.volumeBtnCtrlNote),
              trailing: Checkbox(
                value: config.behavior.volumeBtnCtrl,
                onChanged: (val) => setState(() {
                  config.behavior.volumeBtnCtrl = val!;
                }),
              ),
            ),
          /*ListTile(
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
          ),*/
        ],
      ),
    );
  }
}
