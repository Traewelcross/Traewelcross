import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:saf_util/saf_util.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/dialogs/logging_activate.dart';
import 'package:traewelcross/dialogs/logging_body_activate.dart';
import 'package:traewelcross/dialogs/logging_success_activate.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class MiscPreferences extends StatefulWidget {
  const MiscPreferences({super.key});

  @override
  State<MiscPreferences> createState() => _MiscPreferencesState();
}

class _MiscPreferencesState extends State<MiscPreferences> {
  void toggleLogging(bool value) async {
    if (!value) {
      getIt<Config>().misc.enableLogging = false;
    } else {
      final res = await showDialog<bool>(
        context: context,
        builder: (ctx) => const LoggingActivate(),
        barrierDismissible: false,
      );
      if (res!) {
        final String? selectedDir;
        if (!Platform.isAndroid) {
          selectedDir = await FilePicker.getDirectoryPath();
        } else {
          final dir = await SafUtil().pickDirectory(
            writePermission: true,
            persistablePermission: true,
          );
          selectedDir = dir?.uri;
        }
        if (selectedDir == null) return;
        getIt<Config>().misc.logFile = selectedDir;
        getIt<Config>().misc.enableLogging = true;
      }
      //getIt<Config>().misc.enableLogging = res!;
    }
    setState(() {});
  }

  void toggleLoggingSuccess(bool value) async {
    if (!value) {
      getIt<Config>().misc.logSuccessFull = false;
    } else {
      final res = await showDialog<bool>(
        context: context,
        builder: (ctx) => const LoggingSuccessActivate(),
        barrierDismissible: false,
      );
      if (res!) {
        getIt<Config>().misc.logSuccessFull = true;
      }
      //getIt<Config>().misc.enableLogging = res!;
    }
    setState(() {});
  }

  void toggleLoggingBody(bool value) async {
    if (!value) {
      getIt<Config>().misc.logBody = false;
    } else {
      final res = await showDialog<bool>(
        context: context,
        builder: (ctx) => const LoggingBodyActivate(),
        barrierDismissible: false,
      );
      if (res!) {
        getIt<Config>().misc.logBody = true;
      }
      //getIt<Config>().misc.enableLogging = res!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    // ignore: unused_local_variable
    Config config = getIt<Config>();
    return PopScope(
      onPopInvokedWithResult: (_, _) =>
          TerminateRestart.instance.restartApp(options: .new(terminate: true)),
      child: MainScaffold(
        title: Text(localize.misc),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text(localize.loggerSettings),
              subtitle: Text(localize.loggerSettingsRestart),
            ),
            Divider(),
            ListTile(
              onTap: () => toggleLogging(!getIt<Config>().misc.enableLogging),
              leading: const Icon(Symbols.unknown_document),
              title: Text(localize.loggerActivateTitle),
              subtitle: Text(localize.loggerActivateSubtitle),
              trailing: Switch(
                value: getIt<Config>().misc.enableLogging,
                onChanged: toggleLogging,
              ),
            ),
            if (getIt<Config>().misc.enableLogging) ...[
              ListTile(
                onTap: () =>
                    toggleLoggingSuccess(!getIt<Config>().misc.logSuccessFull),
                leading: const Icon(Icons.cloud_done),
                title: Text(localize.loggerAlsoSuccessTitle),
                subtitle: Text(localize.loggerAlsoSuccessSubtitle),
                trailing: Switch(
                  value: getIt<Config>().misc.logSuccessFull,
                  onChanged: toggleLoggingSuccess,
                ),
              ),
              ListTile(
                onTap: () => toggleLoggingBody(!getIt<Config>().misc.logBody),
                leading: const Icon(Icons.receipt_long),
                title: Text(localize.loggerAlsoBodyTitle),
                subtitle: Text(localize.loggerAlsoBodySubtitle),
                trailing: Switch(
                  value: getIt<Config>().misc.logBody,
                  onChanged: toggleLoggingBody,
                ),
              ),
              Text(localize.loggerDisclaimer, textAlign: .center, style: .new(fontStyle: .italic),)
            ],
          ],
        ),
      ),
    );
  }
}
