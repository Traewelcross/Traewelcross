import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/dialogs/default_text.dart';
import 'package:traewelcross/dialogs/system_time_override.dart';
import 'package:traewelcross/dialogs/time_deviation.dart';
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

  void changeTimeDeviation() {
    showDialog(context: context, builder: (context) => TimeDeviationDialog());
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
            trailing: Switch(
              key: const ValueKey("overrideOnTimeTap"),
              value: config.behavior.overrideOnTimeTap,
              onChanged: (val) => setState(() {
                config.behavior.overrideOnTimeTap = val;
              }),
            ),
          ),
          if (config.behavior.overrideOnTimeTap)
            ListTile(
              title: Text(localize.delaySystemTimeOverride),
              subtitle: Text(localize.delaySystemTimeOverrideExplain),
              onTap: () => changeSystemOverrideDelay(),
            ),
          ListTile(
            title: Text(localize.systemTimeDeviationPreferenceTitle),
            subtitle: Text(localize.systemTimeDeviationPreferenceExplanation),
            onTap: () => changeTimeDeviation(),
          ),
          Divider(),
          ListTile(
            onTap: () => setState(() {
              config.behavior.confirmDelete = !config.behavior.confirmDelete;
            }),
            title: Text(localize.confirmDelete),
            subtitle: Text(localize.confirmDeleteExplain),
            trailing: Switch(
              key: const ValueKey("confirmDelete"),
              value: config.behavior.confirmDelete,
              onChanged: (val) => setState(() {
                config.behavior.confirmDelete = val;
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
            trailing: Switch(
              key: const ValueKey("hideManualOnTimeOverride"),
              value: config.behavior.hideManualOnTimeOverride,
              onChanged: (val) => setState(() {
                config.behavior.hideManualOnTimeOverride = val;
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
              config.behavior.showAltDepartureStops =
                  !config.behavior.showAltDepartureStops;
            }),
            title: Text(localize.showAltDepStation),
            trailing: Switch(
              key: const ValueKey("showAltDepStation"),
              value: config.behavior.showAltDepartureStops,
              onChanged: (val) => setState(() {
                config.behavior.showAltDepartureStops = val;
              }),
            ),
          ),
          if (config.behavior.showAltDepartureStops)
            ListTile(
              title: Text(localize.stationRadius),
              subtitle: Slider(
                value: config.behavior.stopSearchRadius.toDouble(),
                onChanged: (val) => setState(
                  () => config.behavior.stopSearchRadius = val.toInt(),
                ),
                min: 50.0,
                max: 1000.0,
                showValueIndicator: .onDrag,
                label: "${config.behavior.stopSearchRadius}m",
                divisions: ((1000 - 50) ~/ 10),
              ),
            ),

          ListTile(
            onTap: () => setState(() {
              config.behavior.showActiveRideCard =
                  !config.behavior.showActiveRideCard;
            }),
            title: Text(localize.showActiveRideCard),
            subtitle: Text(localize.showActiveRideCardDesc),
            trailing: Switch(
              key: const ValueKey("showActiveRideCard"),
              value: config.behavior.showActiveRideCard,
              onChanged: (val) => setState(() {
                config.behavior.showActiveRideCard = val;
              }),
            ),
          ),
          ListTile(
            onTap: () => setState(() {
              config.behavior.hideTicketButton =
                  !config.behavior.hideTicketButton;
            }),
            title: Text(localize.hideTicketButton),
            trailing: Switch(
              key: const ValueKey("hideTicketButton"),
              value: config.behavior.hideTicketButton,
              onChanged: (val) => setState(() {
                config.behavior.hideTicketButton = val;
              }),
            ),
          ),
          ListTile(
            onTap: () => setState(() {
              config.behavior.showLikeButtonForOwnRides =
                  !config.behavior.showLikeButtonForOwnRides;
            }),
            title: Text(localize.likeOwnPostAllowed),
            trailing: Switch(
              key: const ValueKey("showLikeButtonForOwnRides"),
              value: config.behavior.showLikeButtonForOwnRides,
              onChanged: (val) => setState(() {
                config.behavior.showLikeButtonForOwnRides = val;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
