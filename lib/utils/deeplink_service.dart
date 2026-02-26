import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/pages/detailed_ride_view.dart';
import 'package:traewelcross/utils/authentication.dart';
import 'package:traewelcross/utils/shared.dart';

class DeepLinkService {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  
  Function? onLoginSuccess;

  void init({Function? onLoginSuccess}) {
    this.onLoginSuccess = onLoginSuccess;
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Handle initial link that launched the app
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    // Handle links received while the app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    if (uri.host == "oauth.traewelcross.de") {
      _handleOauthCallback(uri);
    } else if (uri.host == "traewelling.de") {
      _handleTraewelling(uri);
    }
  }

  void _handleTraewelling(Uri uri) async {
    int userId = 0;
    await SharedPreferencesAsync()
        .getInt("userid")
        .then((val) => userId = val ?? 0);
    getIt<Logger>().i(uri.pathSegments);
    if(uri.pathSegments[0] == "status"){
      getIt<GlobalKey<NavigatorState>>().currentState?.push(MaterialPageRoute(builder: (context) => DetailedRideView(rideId: (int.parse(uri.pathSegments[1])), authUserId: userId,)));
    }
  }

  void _handleOauthCallback(Uri uri) {
    final authService = getIt<AuthService>();
    authService.handleAuthorizationResponse(uri.queryParameters).then((client) {
      if (client != null) {
        onLoginSuccess?.call();
      }
    });
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
