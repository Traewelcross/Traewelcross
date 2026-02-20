import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:traewelcross/push_notify/push_common.dart';
import 'package:traewelcross/push_notify/push_interface.dart';
// ignore: uri_does_not_exist
import 'package:traewelcross/utils/firebase_options.dart';
import 'package:traewelcross/utils/shared.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

@pragma('vm:entry-point')
Future<void> _fmbBackgroundHandler(RemoteMessage msg) async {
  // Needs to be init, else the backend will fail with "Requested entity was not found."
  // ignore: undefined_identifier
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  processAndShowNotification(msg.data);
}

class PushPlay implements PushApi {
  static bool _isInit = false;
  @override
  Future<void> initializeNotifications() async {
    if (_isInit) return;
    if (!SharedFunctions.canNotificationsBeUsed) {
      getIt<Logger>().i("Notifications cannot be used on this device.");
      return;
    }

    await Firebase.initializeApp(
      // ignore: undefined_identifier
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initFirebaseMessaging();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings("@drawable/ic_notify_icon");
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    _isInit = true;
    getIt<Logger>().i("Push notifications initialized via PushPlay.");
  }

  static Future<void> initFirebaseMessaging() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission(providesAppNotificationSettings: true);
    FirebaseMessaging.onBackgroundMessage(_fmbBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      processAndShowNotification(msg.data);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      processAndShowNotification(msg.data);
    });
  }

  @override
  Future<String> checkAndSyncToken(
    String currentSaved,
    oauth2.Client? client,
  ) async {
    final String? currentToken = await FirebaseMessaging.instance.getToken();
    if (client == null) {
      throw Future.error('User is not authenticated.');
    }
    if (currentToken == null) return currentSaved;
    if (currentSaved == "" || currentSaved != currentToken) {
      final uid = await SharedFunctions.getUserId();
      final fcm = await FirebaseMessaging.instance.getToken();
      final res = await client.patch(
        SharedFunctions.concatUri([
          SharedFunctions.pushServer.toString(),
          "update",
        ]),
        encoding: Encoding.getByName("UTF-8"),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "fcm_token_old": currentSaved,
          "user_id": uid,
          "fcm_token": fcm,
        }),
      );
      if (res.statusCode == 200) {
        return currentToken;
      }
    }
    return currentSaved;
  }

  @override
  Future<void> unregisterDevice(oauth2.Client? client) async {
    if (client == null) {
      throw Future.error('User is not authenticated.');
    }
    final uid = await SharedFunctions.getUserId();
    final fcm = await FirebaseMessaging.instance.getToken();
    await client.delete(
      SharedFunctions.concatUri([
        SharedFunctions.pushServer.toString(),
        "delete",
      ]),
      encoding: Encoding.getByName("UTF-8"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode({"fcm_token": fcm, "user_id": uid, "is_firebase": true}),
    );
    await FirebaseMessaging.instance.deleteToken();
  }

  @override
  Future<bool> registerDevice(oauth2.Client? client) async {
    if (client == null) {
      throw Future.error('User is not authenticated.');
    }
    final uid = await SharedFunctions.getUserId();
    final fcm = await FirebaseMessaging.instance.getToken();
    final response = await client.post(
      SharedFunctions.concatUri([
        SharedFunctions.pushServer.toString(),
        "register",
      ]),
      encoding: Encoding.getByName("UTF-8"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode({"fcm_token": fcm, "user_id": uid, "is_firebase": true}),
    );
    if (response.statusCode == 201) {
      return true;
    }
    getIt<Logger>().i("notify register status: ${response.statusCode}");
    getIt<Logger>().t(response.body);
    return false;
  }
}
