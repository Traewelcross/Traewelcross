import 'package:flutter/material.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/dialogs/default_text.dart';
import 'package:traewelcross/dialogs/system_time_override.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class BehaviorPreferences extends StatefulWidget {
  const BehaviorPreferences({super.key});

  @override
  State<BehaviorPreferences> createState() => _BehaviorPreferencesState();
}

class _BehaviorPreferencesState extends State<BehaviorPreferences> {
  void changeSystemOverrideDelay() {
    showDialog(context: context, builder: (context) => SystemTimeOverride());
  }

  void changeDefaultText() {
    showDialog(context: context, builder: (context) => DefaultTextDialog());
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    Config config = getIt<Config>();
    return MainScaffold(
      title: Text(localize.behavior),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            onTap: () => setState(() {
              config.behavior.overrideOnTimeTap =
                  !config.behavior.overrideOnTimeTap;
            }),
            title: Text(localize.overrideOnTimeTap),
            subtitle: Text(localize.overrideOnTimeTapExplain),
            trailing: Checkbox(
              value: config.behavior.overrideOnTimeTap,
              onChanged: (val) => setState(() {
                config.behavior.overrideOnTimeTap = val!;
              }),
            ),
          ),
          if (config.behavior.overrideOnTimeTap)
            ListTile(
              title: Text(localize.delaySystemTimeOverride),
              subtitle: Text(localize.delaySystemTimeOverrideExplain),
              onTap: () => changeSystemOverrideDelay(),
            ),
          Divider(),
          ListTile(
            onTap: () => setState(() {
              config.behavior.confirmDelete = !config.behavior.confirmDelete;
            }),
            title: Text(localize.confirmDelete),
            subtitle: Text(localize.confirmDeleteExplain),
            trailing: Checkbox(
              value: config.behavior.confirmDelete,
              onChanged: (val) => setState(() {
                config.behavior.confirmDelete = val!;
              }),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => setState(() {
              config.behavior.hideManualOnTimeOverride =
                  !config.behavior.hideManualOnTimeOverride;
            }),
            title: Text(localize.hideManualOnTimeOverride),
            subtitle: Text(localize.hideManualOnTimeOverrideExplain),
            trailing: Checkbox(
              value: config.behavior.hideManualOnTimeOverride,
              onChanged: (val) => setState(() {
                config.behavior.hideManualOnTimeOverride = val!;
              }),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => changeDefaultText(),
            title: Text(localize.defaultTextPreferenceTitle),
            subtitle: Text(localize.defaultTextPreferenceSubtitle),
          ),
          Divider(),
          ListTile(
            onTap: () => setState(() {
              config.behavior.showAltDepartureStops = !config.behavior.showAltDepartureStops;
            }),
            title: Text(localize.showAltDepStation),
            trailing: Checkbox(value: config.behavior.showAltDepartureStops, onChanged: (val) => setState(() {config.behavior.showAltDepartureStops = val!;})),
          )
        ],
      ),
    );
  }
}
