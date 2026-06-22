import 'package:flutter/material.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class UnavailableService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(localize.errorTitle),
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(
              Icons.railway_alert_outlined,
              color: Theme.of(context).colorScheme.error,
              size: 96,
            ),
            SizedBox(height: 16,),
            Center(child: Text(localize.serviceUnavailable, textAlign: .center,)),
            SizedBox(height: 16,),
            FilledButton.icon(onPressed: ()=>SharedFunctions.launchURL(Uri.parse("https://traewelling.de",), launchMode: .externalApplication), label: Text(localize.checkOnTheWeb), icon: Icon(Icons.open_in_new)),
            SizedBox(height: 8,),
            FilledButton.tonalIcon(onPressed: () => TerminateRestart.instance.restartApp(options:TerminateRestartOptions(clearData: false)), label: Text(localize.errorTroubleshootButtonRestart), icon: Icon(Icons.restart_alt))
          ],
        ),
      ),
    );
  }
}
