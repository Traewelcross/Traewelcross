import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/enums/error_type.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/utils/authentication.dart';
import 'package:traewelcross/utils/error_info.dart';
import 'package:traewelcross/utils/shared.dart';

class ApiService {
  static const String _baseURL = "https://traewelling.de/api/v1";
  static const int _timeoutDuration = 25;
  final AuthService _authService;
  int _requestCount = 0;
  DateTime _lastRequest = DateTime.now();

  ApiService(this._authService);

  Future<oauth2.Client?> getAuthenticatedClient() async {
    return await _authService.getAuthenticatedClient();
  }

  Future<int> getUserFull({required bool withId}) async {
    final userInfo = await request("/auth/user", HttpRequestTypes.GET);
    final userName = jsonDecode(userInfo.body)["data"]["id"];
    withId ? await SharedPreferencesAsync().setInt("userid", userName) : "";
    await SharedPreferencesAsync().setString(
      "userinfo",
      jsonEncode(jsonDecode(userInfo.body)["data"]),
    );
    return userName;
  }

  Future<http.Response> request(
    String url,
    HttpRequestTypes type, {
    Map<String, String>? headers = const {"Content-Type": "application/json"},
    Object? body,
    Encoding? encoding,
  }) async {
    bool hasBeenRefreshed = false;
    // Token Lifetime has been drastically reduced: https://github.com/Traewelling/traewelling/pull/3869
    // The token will refresh on every 20th API request. This is to avoid potential ratelimits.
    _requestCount++;
    if (_requestCount >= 20) {
      _requestCount = 0;
      if (kDebugMode) print("Refresh Token (20th api request)");
      await refreshToken();
      hasBeenRefreshed = true;
    }
    if (DateTime.now().difference(_lastRequest).inHours >= 1 &&
        !hasBeenRefreshed) {
      if (kDebugMode) print("Refresh Token (stale)");
      await refreshToken();
    }
    encoding ??= Encoding.getByName("UTF-8");
    final client = await getAuthenticatedClient();
    if (client == null) {
      throw Future.error("User is not authenticated.");
    }
    late http.Response res;
    switch (type) {
      case HttpRequestTypes.GET:
        res = await client
            .get(SharedFunctions.concatUri([_baseURL, url]))
            .timeout(Duration(seconds: _timeoutDuration));
        break;
      case HttpRequestTypes.PUT:
        res = await client
            .put(
              SharedFunctions.concatUri([_baseURL, url]),
              headers: headers,
              body: body,
              encoding: encoding,
            )
            .timeout(Duration(seconds: _timeoutDuration));
        break;
      case HttpRequestTypes.POST:
        res = await client
            .post(
              SharedFunctions.concatUri([_baseURL, url]),
              headers: headers,
              body: body,
              encoding: encoding,
            )
            .timeout(Duration(seconds: _timeoutDuration));
        break;
      case HttpRequestTypes.DELETE:
        res = await client
            .delete(
              SharedFunctions.concatUri([_baseURL, url]),
              headers: headers,
              body: body,
              encoding: encoding,
            )
            .timeout(Duration(seconds: _timeoutDuration));
        break;
    }
    _lastRequest = DateTime.now();
    return res;
  }

  Future<void> logOut() async {
    final push = globalPushManager;
    final client = await getAuthenticatedClient();
    try {
      //TODO: Remove WebHook
      push.unregisterDevice(client);
      await client?.post(SharedFunctions.concatUri([_baseURL, "/auth/logout"]));
    } finally {
      SharedPreferencesAsync().clear();
      _authService.logout();
    }
  }

  Future<dynamic> refreshToken() async {
    final oAuthClient = await getAuthenticatedClient();
    if (oAuthClient == null) {
      return false;
    }
    oauth2.Credentials? creds;
    http.Response? res;
    final client = http.Client();

    // Inner try-finally for the plain http.Client
    try {
      res = await client.post(
        SharedFunctions.concatUri(["https://traewelling.de", "/oauth/token"]),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "refresh_token": oAuthClient.credentials.refreshToken ?? "",
          "grant_type": "refresh_token",
          "client_id": oAuthClient.identifier,
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        creds = oauth2.Credentials(
          json["access_token"],
          refreshToken: json["refresh_token"],
          expiration: DateTime.now().add(Duration(seconds: json["expires_in"])),
          tokenEndpoint: Uri.parse(AuthService.tokenEndpoint),
        );
      }
    } catch (e) {
      return Future.error(e);
    } finally {
      client.close();
    }

    if (creds == null) {
      return Future.error(
        ErrorInfo(
          "Couldn't refresh token, response credentials were null",
          type: ErrorType.httpError,
          httpStatusCode: res.statusCode,
          exception: res.body,
        ),
      );
    }
    await _authService.saveCredentials(creds);
    return true;
  }

  Future<String?> fetchUserProfilePicture(String userName) async {
    try {
      final response = await request("/auth/user", HttpRequestTypes.GET);
      final jsonRes = jsonDecode(response.body);
      return jsonRes["data"]["profilePicture"];
    } catch (e) {
      return null;
    }
  }
}
