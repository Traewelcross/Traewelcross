import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/detailed_ride_view.dart';
import 'package:traewelcross/push_notify/push_interface.dart';
import 'package:traewelcross/utils/shared.dart';

class PushManager {
  final PushApi api;
  PushManager(this.api);
  Future<void> unregisterDevice(oauth2.Client? client) =>
      api.unregisterDevice(client);
  Future<bool> registerDevice(oauth2.Client? client) =>
      api.registerDevice(client);
  Future<String> checkAndSyncToken(
    String currentSaved,
    oauth2.Client? client,
  ) => api.checkAndSyncToken(currentSaved, client);
  Future<void> initializeNotifications() => api.initializeNotifications();
}

Future<void> createNotificationChannels() async {
  if (!Platform.isAndroid) return;
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  final AppLocalizations localize = await AppLocalizations.delegate.load(
    locale,
  );
  final AndroidNotificationChannel likes = AndroidNotificationChannel(
    "likes",
    localize.notificationChannelLikes,
  );
  final AndroidNotificationChannel checkIns = AndroidNotificationChannel(
    "checkin",
    localize.notificationChannelCheckIns,
  );
  final AndroidNotificationChannel travelTogether = AndroidNotificationChannel(
    "traveltogether",
    localize.notificationChannelTravelTogether,
  );
  final AndroidNotificationChannel account = AndroidNotificationChannel(
    "account",
    localize.notificationChannelAccount,
  );
  final AndroidNotificationChannel misc = AndroidNotificationChannel(
    "misc",
    localize.notificationChannelMisc,
    importance: Importance.low,
  );
  final plugin = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  plugin?.createNotificationChannel(likes);
  plugin?.createNotificationChannel(checkIns);
  plugin?.createNotificationChannel(travelTogether);
  plugin?.createNotificationChannel(account);
  plugin?.createNotificationChannel(misc);
}

void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) {
  final json = jsonDecode(notificationResponse.payload ?? "{}");
  if (json["data"]["status"]?["id"] != null) {
    getIt<GlobalKey<NavigatorState>>().currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            DetailedRideView(rideId: json["data"]["status"]["id"]),
      ),
    );
  }
}

Future<void> processAndShowNotification(Map<String, dynamic> data) async {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final notification = jsonDecode(data["rawBody"])["notification"];
  final channel = switch (notification["type"]) {
    "StatusLiked" || "UserMentioned" => "likes",
    "YouHaveBeenCheckedIn" => "checkin",
    "UserJoinedConnection" => "traveltogether",
    "FollowRequestApproved" ||
    "FollowRequestIssued" ||
    "UserFollowed" => "account",
    _ => "misc",
  };
  final channelName = switch (channel) {
    "likes" => "Likes",
    "checkin" => "Check-In",
    "traveltogether" => "Travel Together",
    "account" => "Account",
    _ => "Misc",
  };
  final androidDetails = AndroidNotificationDetails(channel, channelName);
  final notificationDetails = NotificationDetails(android: androidDetails);
  notificationsPlugin.show(
    data.hashCode,
    notification["lead"],
    notification["notice"],
    notificationDetails,
    payload: jsonEncode(notification),
  );
}
