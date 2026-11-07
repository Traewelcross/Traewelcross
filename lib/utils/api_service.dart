import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/error_type.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/utils/api_providers/mastodon_api_provider.dart';
import 'package:traewelcross/utils/api_providers/misc_api_provider.dart';
import 'package:traewelcross/utils/api_providers/statistics_api_provider.dart';
import 'package:traewelcross/utils/api_providers/train_api_provider.dart';
import 'package:traewelcross/utils/api_providers/trip_api_provider.dart';
import 'package:traewelcross/utils/api_providers/user_api_provider.dart';
import 'package:traewelcross/utils/authentication.dart';
import 'package:traewelcross/utils/error_info.dart';
import 'package:traewelcross/utils/api_providers/notification_api_provider.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:traewelcross/utils/api_providers/status_api_provider.dart';
import 'package:traewelcross/utils/api_providers/station_api_provider.dart';
import 'package:traewelcross/utils/api_providers/event_api_provider.dart';
import 'package:traewelcross/utils/api_providers/alert_api_provider.dart';
import 'package:traewelcross/utils/api_providers/checkin_api_provider.dart';
import 'package:traewelcross/utils/api_providers/operator_api_provider.dart';

class UnavailableException implements Exception {}

class ApiService {
  static const String _baseURL = "https://traewelling.de/api/v1";
  static const int _timeoutDuration = 25;
  final AuthService _authService;
  DateTime _lastRequest = DateTime.now();
  Future<dynamic>? _refreshFuture;
  bool serviceUnavailable = false;

  //TODO: provider wide check for common status code like 200, 404, 401, ...
  late final status = StatusApiProvider(this);
  late final notification = NotificationApiProvider(this);
  late final user = UserApiProvider(this);
  late final station = StationApiProvider(this);
  late final event = EventApiProvider(this);
  late final alert = AlertApiProvider(this);
  late final checkin = CheckinApiProvider(this);
  late final train = TrainApiProvider(this);
  late final trip = TripApiProvider(this);
  late final mastodon = MastodonApiProvider();
  late final operator = OperatorApiProvider(this);
  late final statistics = StatisticsApiProvider(this);
  late final misc = MiscApiProvider(this);

  ApiService(this._authService);

  Future<oauth2.Client?> getAuthenticatedClient() async {
    return await _authService.getAuthenticatedClient();
  }

  Future<int> getUserFull({required bool withId}) async {
    http.Response userInfo;
    try {
      userInfo = await request("/auth/user", HttpRequestTypes.GET);
    } catch (e) {
      rethrow;
    }
    if (userInfo.statusCode == 503) {
      throw UnavailableException();
    }
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
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final requesthash = url.hashCode + type.hashCode;
    headers ??= {};
    headers.addAll({
      "User-Agent":
          "Traewelcross/${(await PackageInfo.fromPlatform()).version} (https://github.com/traewelcross/traewelcross; traewelcross.de)",
      "Content-Type": "application/json",
    });
    final logger = getIt<Logger>();
    logger.i("($requesthash) Trying to request $url with method ${type.toString()}");
    if(getIt<Config>().misc.logBody){

    logger.i("($requesthash) Body for this request is: $body");
    }
    oauth2.Client? client = await getAuthenticatedClient();
    if (DateTime.now().difference(_lastRequest).inMinutes >= 55 ||
        client?.credentials.isExpired == true) {
      logger.i("Refresh Token (stale or expired)");
      await refreshToken();
    }
    encoding ??= Encoding.getByName("UTF-8");
    client = await getAuthenticatedClient();
    if (client == null) {
      logger.e("($requesthash) User is not authenticated. This is bad, when you consider that we tried to make an authenticated request.");
      throw Future.error("User is not authenticated.");
    }
    late http.Response res;
    switch (type) {
      case HttpRequestTypes.GET:
        res = await client
            .get(SharedFunctions.concatUri([_baseURL, url]), headers: headers)
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
    logger.i("($requesthash) The request for $url finished with ${res.statusCode}.");
    if(res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204){
      if(getIt<Config>().misc.logSuccessFull){
        logger.i("($requesthash) The request for $url returned ${res.body}");
      } else {
        logger.i("($requesthash) The request for $url seems to have finished without error. Since the option to log the response when a request was successful is turned off, no body is displayed here.");
      }
    } else {
      logger.w("($requesthash) The request for $url has seemingly failed. The response was: ${res.body}");
    }
    /*if (res.statusCode == 503 && !serviceUnavailable) {
      serviceUnavailable = true;
      final buildCtx = getIt<GlobalKey<NavigatorState>>().currentState?.context;
      if (!buildCtx!.mounted) return res;
      Navigator.pushReplacement(
        buildCtx,
        MaterialPageRoute(builder: (ctx) => UnavailableService()),
      );
      return res;
    }*/
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

  Future<dynamic> refreshToken({bool secondTry = false}) async {
    final logger = getIt<Logger>();
    logger.i("Received Request to refresh token. Second Try? $secondTry");
    if (_refreshFuture != null) {
      logger.i("Already trying to refresh token, no new request started");
      return _refreshFuture;
    }

    _refreshFuture = _doRefreshToken(secondTry: secondTry);
    try {
      return await _refreshFuture;
    } catch (e,st) {
      logger.w("Token failed to refresh :(", error: e, stackTrace: st);
      rethrow;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<dynamic> _doRefreshToken({bool secondTry = false}) async {
    final logger = getIt<Logger>();
    final oAuthClient = await getAuthenticatedClient();
    if (oAuthClient == null) {
      return false;
    }
    oauth2.Credentials? creds;
    http.Response? res;
    final client = http.Client();

    try {
      res = await client.post(
        SharedFunctions.concatUri(["https://traewelling.de", "/oauth/token"]),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "User-Agent":
              "Traewelcross/${(await PackageInfo.fromPlatform()).version} (https://github.com/traewelcross/traewelcross; traewelcross.de)",
        },
        body: {
          "refresh_token": oAuthClient.credentials.refreshToken ?? "",
          "grant_type": "refresh_token",
          "client_id": oAuthClient.identifier,
        },
        encoding: Encoding.getByName("UTF-8"),
      );
      logger.i("Requested new token.");
      if(getIt<Config>().misc.logBody){

      logger.i("Body for this token request: ${res.body}");
      }
      //print(res.request);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        creds = oauth2.Credentials(
          json["access_token"],
          refreshToken: json["refresh_token"],
          expiration: DateTime.now().add(Duration(seconds: json["expires_in"])),
          tokenEndpoint: Uri.parse(AuthService.tokenEndpoint),
        );
        logger.i("Refreshed the Token. Great success!");
        if(getIt<Config>().misc.logSuccessFull){
          logger.d("Token data received was: $json");
        }
      } else if (res.statusCode == 429) {
        if (!oAuthClient.credentials.isExpired) {
          logger.i("Refresh Rate Limited, but token should still be valid");
          return true;
        }
        if (secondTry) {
          logger.e("We got rate limited at our second try and couldn't fetch a new Token. Unfortunate!");
          return await Future.error(
            ErrorInfo(
              "rate limit",
              type: ErrorType.httpError,
              httpStatusCode: 429,
              exception: res.body,
            ),
          );
        }
        await Future.delayed(const Duration(seconds: 10));
        return await refreshToken(secondTry: true);
      }
    } catch (e, st) {
      logger.e("An error occured while trying to refresh the token.", error: e, stackTrace: st);
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

  Future<String?> fetchUserProfilePicture() async {
    try {
      final response = await request("/auth/user", HttpRequestTypes.GET);
      final jsonRes = jsonDecode(response.body);
      return jsonRes["data"]["profilePicture"];
    } catch (e) {
      return null;
    }
  }
}
