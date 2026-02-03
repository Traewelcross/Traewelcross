import 'dart:convert';
import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/push_notify/push_common.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/custom_providers.dart';
import 'package:traewelcross/utils/authentication.dart';
import 'package:traewelcross/utils/time_span.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

late final PushManager globalPushManager;

final getIt = GetIt.instance;

class SharedFunctions {
  static Uri repoURI = Uri.parse(
    "https://github.com/Traewelcross/traewelcross",
  );

  /// To be used for page loads or substantial requests like checking in.
  /// For smaller requests (e.g. following, homeing) a SnackBar should be used instead
  static void handleRequestTimeout(BuildContext context, dynamic onRetry) {
    final localize = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        leading: const Icon(Icons.hourglass_bottom),
        content: Text(localize.requestTimeoutMessage),
        actions: [
          TextButton.icon(
            onPressed: () {
              onRetry.call();
              ScaffoldMessenger.of(context).clearMaterialBanners();
            },
            label: Text(localize.retry),
          ),
        ],
      ),
    );
  }

  static void configureGetIt() {
    getIt.registerSingleton<Config>(Config());
    getIt.registerLazySingleton<AuthService>(() => AuthService());
    getIt.registerLazySingleton<ApiService>(
      () => ApiService(getIt<AuthService>()),
    );
    getIt.registerLazySingleton<AppBarState>(() => AppBarState());
    getIt.registerLazySingleton<UnreadCountProvider>(
      () => UnreadCountProvider(),
    );
    getIt.registerLazySingleton<Logger>(
      () => Logger(printer: SimplePrinter(printTime: true, colors: true)),
    );
  }

  static Future<void> refreshToken() async {
    if(getIt.isRegistered(type: ApiService)){
      if(kDebugMode) print("Refresh Token (boot)");
      final apiService = getIt<ApiService>();
      await apiService.refreshToken();
    }
  }

  static Future<void> launchURL(Uri url, {LaunchMode? launchMode}) async {
    if (!await launchUrl(url, mode: launchMode ?? LaunchMode.platformDefault)) {
      throw Exception('Could not launch $url');
    }
  }

  static bool canNotificationsBeUsed = false;

  static Uri pushServer = Uri.parse("https://push.traewelcross.de");

  static Uri concatUri(List<String> parts) {
    return Uri.parse(
      parts
          .map((part) => part.trim())
          .map((part) => part.replaceAll(RegExp(r'^/+|/+$'), ''))
          .where((part) => part.isNotEmpty)
          .join('/'),
    );
  }

  static Future<Map<String, dynamic>> getUserInfoFromCache() async {
    final userPref =
        await SharedPreferencesAsync().getString("userinfo") ?? "{}";
    return jsonDecode(userPref);
  }

  static bool get isDesktop {
    if (kIsWeb) return false;
    return [
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.macOS,
    ].contains(defaultTargetPlatform);
  }

  static TimeSpan parseDuration(int duration) {
    return TimeSpan(duration);
  }

  static String parseDateTime(String isoDateTime, String value) {
    switch (value) {
      case "hour":
        return DateTime.parse(
          isoDateTime,
        ).toLocal().hour.toString().padLeft(2, "0");
      case "minute":
        return DateTime.parse(
          isoDateTime,
        ).toLocal().minute.toString().padLeft(2, "0");
      case "day":
        return DateTime.parse(
          isoDateTime,
        ).toLocal().day.toString().padLeft(2, "0");
      default:
        return "";
    }
  }

  static Color secondCard(BuildContext context) => Color.alphaBlend(
    Colors.white.withValues(alpha: .03),
    Theme.of(context).cardColor,
  );
  static Future<int> getUserId() async {
    int userid = 0;
    userid = await SharedPreferencesAsync().getInt("userid") ?? 0;
    return userid;
  }

  /// Compare two Maps and return the differences
  static Map<String, dynamic> diffMaps(
    Map<String, dynamic> oldMap,
    Map<String, dynamic> newMap,
  ) {
    final diff = <String, dynamic>{};
    for (final entry in newMap.entries) {
      final key = entry.key;
      final newValue = entry.value;
      final oldValue = oldMap[key];
      if (newValue != oldValue) {
        diff[key] = newValue;
      }
    }
    return diff;
  }

  static Future<bool> dynamicColorSupport() async {
    final accent = await DynamicColorPlugin.getAccentColor();
    final pal = await DynamicColorPlugin.getCorePalette();
    if (Platform.isAndroid && pal != null) {
      return true;
    }
    if (accent == null) {
      return false;
    }
    return true;
  }
}
