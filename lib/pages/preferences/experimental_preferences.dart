import 'dart:io';

import 'package:material_ui/material_ui.dart';
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
      title: Text(localize.experimentalPrefrences),
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
              trailing: Switch(
                value: config.behavior.volumeBtnCtrl,
                onChanged: (val) => setState(() {
                  config.behavior.volumeBtnCtrl = val;
                }),
              ),
            ),
          if (Platform.isAndroid && config.behavior.volumeBtnCtrl)
            ListTile(
              onTap: () => setState(() {
                config.behavior.volumeBtnCtrlShowIndicator = !config.behavior.volumeBtnCtrlShowIndicator;
              }),
              leading: const Icon(Icons.music_note),
              title: Text(localize.volumeBtnCtrlIndicator),
              subtitle: Text(localize.volumeBtnCtrlIndicatorNote),
              trailing: Switch(
                value: config.behavior.volumeBtnCtrlShowIndicator,
                onChanged: (val) => setState(() {
                  config.behavior.volumeBtnCtrlShowIndicator = val;
                }),
              ),
            ),
          /*ListTile(
            onTap: () => setState(() {
              config.behavior.multiAccountSupport = !config.behavior.multiAccountSupport;
            }),
            leading: const Icon(Icons.group),
            title: Text(localize.multiAccount),
            subtitle: Text(localize.multiAccountNotice),
            trailing: Switch(
              value: config.behavior.multiAccountSupport,
              onChanged: (val) => setState(() {
                config.behavior.multiAccountSupport = val;
              }),
            ),
          ),*/
        ],
      ),
    );
  }
}
