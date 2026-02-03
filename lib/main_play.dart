import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:logger/logger.dart';
import 'package:traewelcross/app.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/push_notify/push_common.dart';
import 'package:traewelcross/push_notify/push_play.dart';
import 'package:traewelcross/utils/shared.dart';

Future<Config> loadConfig() async {
  return await Config.getConfig();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedFunctions.configureGetIt();
  // Refresh Token on every boot, see request() in utils/api_service.dart for why
  await SharedFunctions.refreshToken();
  final appConfig = await loadConfig();
  getIt.unregister<Config>();
  getIt.registerSingleton<Config>(appConfig);
  final pushManager = PushManager(PushPlay());
  globalPushManager = pushManager;
  final getGPSAvailable = await GoogleApiAvailability.instance
      .checkGooglePlayServicesAvailability();
  await createNotificationChannels();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  if (getGPSAvailable ==
      GooglePlayServicesAvailability.notAvailableOnPlatform) {
    getIt<Logger>().i("No GPS available on Platform, most likely iOS");
    SharedFunctions.canNotificationsBeUsed = true;
    appConfig.notification.notificationsAvailable = true;
  } else if (getGPSAvailable == GooglePlayServicesAvailability.success) {
    SharedFunctions.canNotificationsBeUsed = true;
    appConfig.notification.notificationsAvailable = true;
  } else {
    getIt<Logger>().w("Can't use GPS, not iOS, push not available");
  }
  runApp(const App());
}
