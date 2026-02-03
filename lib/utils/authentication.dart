import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:pkce/pkce.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  static const clientId = '218';
  static const clientSecret = "x8auLtzRfFy6SdYuX8NI3rIiJrwWgUzV6PBljUSi";
  static const _authEndpoint = 'https://traewelling.de/oauth/authorize';
  static const tokenEndpoint = 'https://traewelling.de/oauth/token';
  static const _redirectUri = 'https://oauth.traewelcross.de';
  static const _webHookUrl = "https://push.traewelcross.de/wh";
  static const _scopes = <String>[
    "read-statuses",
    "read-notifications",
    "read-statistics",
    "read-search",
    "write-statuses",
    "write-likes",
    "write-notifications",
    "write-exports",
    "write-follows",
    "write-followers",
    "write-blocks",
    "write-event-suggestions",
    "write-support-tickets",
    "read-settings",
    "write-settings-profile",
    "read-settings-profile",
    "write-settings-mail",
    "write-settings-profile-picture",
    "write-settings-privacy",
    "read-settings-followers",
    "write-settings-calendar",
  ];
  static final _state = _generateState(64);

  static const _credentialsKey = 'token';
  static const _codeVerifierKey = 'ocv';
  final _secureStorage = const FlutterSecureStorage();

  oauth2.AuthorizationCodeGrant? _grant;

  static final AuthService _instance = AuthService._internal();
  factory AuthService() {
    return _instance;
  }
  AuthService._internal();

  Future<void> saveCredentials(oauth2.Credentials credentials) async {
    await _secureStorage.write(
      key: _credentialsKey,
      value: json.encode(credentials.toJson()),
    );
  }

  Future<oauth2.Credentials?> _loadCredentials() async {
    final jsonCredentials = await _secureStorage.read(key: _credentialsKey);
    if (jsonCredentials != null) {
      try {
        return oauth2.Credentials.fromJson(json.decode(jsonCredentials));
      } catch (e) {
        debugPrint('Error decoding credentials: $e');
        await _deleteCredentials();
        return null;
      }
    }
    return null;
  }

  Future<void> _deleteCredentials() async {
    await _secureStorage.delete(key: _credentialsKey);
    await _secureStorage.delete(key: _codeVerifierKey);
  }

  Future<bool> isLoggedIn() async {
    return await _secureStorage.containsKey(key: _credentialsKey);
  }

  Future<void> logout() async {
    await _deleteCredentials();
  }

  Future<oauth2.Client?> getAuthenticatedClient() async {
    final credentials = await _loadCredentials();
    if (credentials == null) {
      return null;
    }

    return oauth2.Client(
      credentials,
      identifier: clientId,
      secret: clientSecret,
      onCredentialsRefreshed: (refreshedCredentials) async {
        await saveCredentials(refreshedCredentials);
      },
    );
  }

  Future<void> loginWithPKCE() async {
    final pkcePair = PkcePair.generate();
    await _secureStorage.write(
      key: _codeVerifierKey,
      value: pkcePair.codeVerifier,
    );

    _grant = oauth2.AuthorizationCodeGrant(
      clientId,
      Uri.parse(_authEndpoint),
      Uri.parse(tokenEndpoint),
      secret: clientSecret,
      codeVerifier: pkcePair.codeVerifier,
    );

    Uri authUrl = _grant!.getAuthorizationUrl(
      Uri.parse(_redirectUri),
      scopes: _scopes,
      state: _state,
    );
    Map<String, String> webhookQuery = {
      "trwl_webhook_events": "notification",
      "trwl_webhook_url": _webHookUrl,
    };
    webhookQuery.addAll(authUrl.queryParameters);
    authUrl = authUrl.replace(queryParameters: webhookQuery);
    // It would be nicer to use a In-App Browser View, but I can't get that to work atm and this works good enough.
    SharedFunctions.launchURL(authUrl, launchMode: LaunchMode.externalApplication);
  }

  Future<oauth2.Client?> handleAuthorizationResponse(
    Map<String, String> queryParameters,
  ) async {
    if (queryParameters['state'] != _state) {
      throw Exception('Invalid state parameter in authorization response.');
    }

    // If the grant is null (e.g. app was restarted), recreate it.
    if (_grant == null) {
      final codeVerifier = await _secureStorage.read(key: _codeVerifierKey);
      if (codeVerifier == null) {
        throw Exception(
          'Code verifier not found. Authentication flow might have been interrupted.',
        );
      }
      _grant = oauth2.AuthorizationCodeGrant(
        clientId,
        Uri.parse(_authEndpoint),
        Uri.parse(tokenEndpoint),
        secret: clientSecret,
        codeVerifier: codeVerifier,
      );
    }

    try {
      final client = await _grant!.handleAuthorizationResponse(queryParameters);
      await saveCredentials(client.credentials);
      getIt<Config>().misc.needsRelogin = false;
      return client;
    } catch (e) {
      getIt<Logger>().e('Error handling authorization response: $e');
      return null;
    } finally {
            await _secureStorage.delete(
        key: _codeVerifierKey,
      );
      _grant = null;
    }
  }
}

String _generateState(int len) {
  final rand = Random.secure();
  final chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(len, (_) => chars[rand.nextInt(chars.length)]).join();
}
