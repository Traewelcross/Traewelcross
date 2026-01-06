import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/app_info.dart';
import 'package:traewelcross/pages/preferences/account_preferences.dart';
import 'package:traewelcross/pages/preferences/appearance_preferences.dart';
import 'package:traewelcross/pages/preferences/behavior_preferences.dart';
// ignore: unused_import
import 'package:traewelcross/pages/preferences/misc_preferences.dart';
import 'package:traewelcross/pages/preferences/notification_preferences.dart';
import 'package:traewelcross/utils/shared.dart';

class Preferences extends StatelessWidget {
  const Preferences({super.key});
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: Text(localize.settings),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "icons/raw_icon.svg",
                  width: 24,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Träwelcross",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontFamily: "SUSE",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppInfo()),
                  ),
                  child: Text("Info"),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPreferences()),
            ),
            leading: const Icon(Icons.account_circle),
            title: Text(localize.account),
          ),
          if (getIt<Config>().notification.notificationsAvailable)
            ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPreferences(),
                ),
              ),
              leading: const Icon(Icons.notifications),
              title: Text(localize.notificationPreferences),
            ),
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppearancePreferences()),
            ),
            leading: const Icon(Icons.format_paint),
            title: Text(localize.appearance),
          ),
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BehaviorPreferences()),
            ),
            leading: const Icon(Icons.psychology),
            title: Text(localize.behavior),
          ),

          // Nothing to configure here yet
          /*ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MiscPreferences()),
            ),
            leading: const Icon(Icons.more),
            title: Text(localize.misc),
          ),*/
        ],
      ),
    );
  }
}
