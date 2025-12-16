import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class NotificationPreferences extends StatefulWidget {
  const NotificationPreferences({super.key});

  @override
  State<NotificationPreferences> createState() =>
      _NotificationPreferencesState();
}

class _NotificationPreferencesState extends State<NotificationPreferences> {
  bool changingNotificationState = false;
  void toggleNotifications(
    bool? val,
    BuildContext context,
    Config config,
  ) async {
    if (val == null) return;
    setState(() {
      changingNotificationState = true;
    });
    final client = await getIt<ApiService>().getAuthenticatedClient();
    if (val) {
      await globalPushManager.initializeNotifications();
      await globalPushManager.registerDevice(client);
    } else {
      await globalPushManager.unregisterDevice(client);
    }
    setState(() {
      config.notification.notificationsEnabled = val;
      changingNotificationState = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final config = getIt<Config>();
    return MainScaffold(
      title: Text(localize.notificationPreferences),
      body: ListView(
        children: [
          ListTile(
            onTap: () => toggleNotifications(
              !config.notification.notificationsEnabled,
              context,
              config,
            ),
            leading: config.notification.notificationsEnabled
                ? const Icon(Icons.notifications)
                : const Icon(Icons.notifications_off),
            title: Text(localize.activateNotifications),
            trailing: changingNotificationState
                ? Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(strokeWidth: 8),
                  )
                : Checkbox(
                    value: config.notification.notificationsEnabled,
                    onChanged: (val) =>
                        toggleNotifications(val, context, config),
                  ),
          ),
          if (config.notification.notificationsEnabled) ...[
            Divider(),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(localize.openNotificationSettingsTitle),
              subtitle: Text(localize.openNotificationSettingsSub),
              onTap: () => AppSettings.openAppSettings(
                type: AppSettingsType.notification,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
