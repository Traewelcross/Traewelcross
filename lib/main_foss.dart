import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traewelcross/app.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/push_notify/push_common.dart';
import 'package:traewelcross/push_notify/push_foss.dart';
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
  final pushManager = PushManager(PushFoss());
  globalPushManager = pushManager;
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
  runApp(const App());
}
