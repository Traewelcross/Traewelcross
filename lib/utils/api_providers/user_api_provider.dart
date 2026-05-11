import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class UserApiProvider {
  final ApiService _api;
  UserApiProvider(this._api);
  BuildContext? get _context =>
      getIt<GlobalKey<NavigatorState>>().currentState?.context;
  Future<List<User>> searchUser(String query) async {
    final response = await _api.request(
      "/user/search/${Uri.encodeComponent(query)}",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<User> users = jsonData
          .map((u) => User.fromJson(u as Map<String, dynamic>))
          .toList();
      return users;
    }
    return Future.error("${response.statusCode} / ${response.body}");
  }

  Future<List<User>> getFollowers({required int page}) async {
    final response = await _api.request(
      "/user/self/followers?page=$page",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<User> users = jsonData
          .map((u) => User.fromJson(u as Map<String, dynamic>))
          .toList();
      return users;
    }
    return Future.error("${response.statusCode} / ${response.body}");
  }

  Future<List<User>> getFollowing({required int page}) async {
    final response = await _api.request(
      "/user/self/followings?page=$page",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<User> users = jsonData
          .map((u) => User.fromJson(u as Map<String, dynamic>))
          .toList();
      return users;
    }
    return Future.error("${response.statusCode} / ${response.body}");
  }

  Future<List<User>> getFollowRequests({required int page}) async {
    final response = await _api.request(
      "/user/self/follow-requests?page=$page",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<User> users = jsonData
          .map((u) => User.fromJson(u as Map<String, dynamic>))
          .toList();
      return users;
    }
    return Future.error("${response.statusCode} / ${response.body}");
  }

  Future<GenericStatusResponse> acceptFollowRequest(int userId) async {
    final res = await _api.request("/user/self/follow-requests/$userId", .PUT);
    if (res.statusCode == 200) {
      return GenericStatusResponse(wasSuccess: true);
    } else {
      if (_context != null) {
        SharedFunctions.sendSnackBar(
          AppLocalizations.of(_context!)!.genericErrorSnackBar +
              res.statusCode.toString(),
        );
      }
      return Future.error("${res.statusCode} / ${res.body}");
    }
  }

  Future<GenericStatusResponse> denyFollowRequest(int userId) async {
    final res = await _api.request(
      "/user/self/follow-requests/$userId",
      .DELETE,
    );
    if (res.statusCode == 200) {
      return GenericStatusResponse(wasSuccess: true);
    } else {
      if (_context != null) {
        SharedFunctions.sendSnackBar(
          AppLocalizations.of(_context!)!.genericErrorSnackBar +
              res.statusCode.toString(),
        );
      }
      return Future.error("${res.statusCode} / ${res.body}");
    }
  }

  Future<GenericStatusResponse> removeFollower(int userId) async {
    final res = await _api.request("/user/self/followers/$userId", .DELETE);
    if (res.statusCode == 200) {
      return GenericStatusResponse(wasSuccess: true);
    } else {
      SharedFunctions.sendSnackBar(
        AppLocalizations.of(_context!)!.genericErrorSnackBar +
            res.statusCode.toString(),
      );
      return Future.error("${res.statusCode} / ${res.body}");
    }
  }

  Future<User> fetchUserInfo({String? username}) async {
    String endpoint;
    if (username == null) {
      endpoint = "/auth/user";
    } else {
      endpoint = "/user/$username";
    }
    final res = await _api.request(endpoint, .GET);
    if (res.statusCode == 200) {
      if (username == null) {
        return UserAuth.fromJson(jsonDecode(res.body)["data"]);
      }
      return User.fromJson(jsonDecode(res.body)["data"]);
    }
    if (res.statusCode == 403) {
      final reason = jsonDecode(res.body)["meta"]["reason"];
      if (reason == "PRIVATE_PROFILE" || reason == "USER_BLOCKED") {
        return User.fromJson(jsonDecode(res.body)["meta"]["user"]);
      }
    }
    return Future.error("${res.statusCode} / ${res.body}");
  }

  Future<User?> mute({required int id}) async {
    final res = await _api.request("/user/$id/mute", .POST);
    switch (res.statusCode) {
      case 201:
        return User.fromJson(jsonDecode(res.body)["data"]);
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.userNotFoundSnack,
          );
        }
        break;
      default:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.genericErrorSnackBar +
                res.statusCode.toString(),
          );
        }
        break;
    }
    return null;
  }

  Future<User?> unmute({required int id}) async {
    final res = await _api.request("/user/$id/mute", .DELETE);
    switch (res.statusCode) {
      case 200:
        return User.fromJson(jsonDecode(res.body)["data"]);
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.userNotFoundSnack,
          );
        }
        break;
      default:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.genericErrorSnackBar +
                res.statusCode.toString(),
          );
        }
        break;
    }
    return null;
  }

  Future<User?> block({required int id}) async {
    final res = await _api.request("/user/$id/block", .POST);
    switch (res.statusCode) {
      case 201:
        return User.fromJson(jsonDecode(res.body)["data"]);
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.userNotFoundSnack,
          );
        }
        break;
      default:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.genericErrorSnackBar +
                res.statusCode.toString(),
          );
        }
        break;
    }
    return null;
  }

  Future<User?> unblock({required int id}) async {
    final res = await _api.request("/user/$id/block", .DELETE);
    switch (res.statusCode) {
      case 200:
        return User.fromJson(jsonDecode(res.body)["data"]);
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.userNotFoundSnack,
          );
        }
        break;
      default:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.genericErrorSnackBar +
                res.statusCode.toString(),
          );
        }
        break;
    }
    return null;
  }

  Future<User?> follow({required int id}) async {
    final res = await _api.request("/user/$id/follow", .POST);
    switch (res.statusCode) {
      case 201:
        return User.fromJson(jsonDecode(res.body)["data"]);
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.userNotFoundSnack,
          );
        }
        break;
      default:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.genericErrorSnackBar +
                res.statusCode.toString(),
          );
        }
        break;
    }
    return null;
  }

  Future<User?> unfollow({required int id}) async {
    final res = await _api.request("/user/$id/follow", .DELETE);
    switch (res.statusCode) {
      case 200:
        return User.fromJson(jsonDecode(res.body)["data"]);
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.userNotFoundSnack,
          );
        }
        break;
      default:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.genericErrorSnackBar +
                res.statusCode.toString(),
          );
        }
        break;
    }
    return null;
  }

  Future<List<Station>> getHistory() async {
    // Refresh User Info to potentially update
    await _api.getUserFull(withId: false);
    final userInfo = await SharedFunctions.getUserInfoFromCache();
    final response = await _api.request("/trains/station/history", .GET);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final history = List<Station>.empty(growable: true);
      if (userInfo["home"] != null) {
        userInfo["home"]["home"] = true;
        history.add(Station.fromJson(userInfo["home"]));
      }
      for (var item in jsonData) {
        item["history"] = true;
      }
      final List<Station> stations = jsonData
          .map((u) => Station.fromJson(u as Map<String, dynamic>))
          .toList();
      history.addAll(stations);
      return history;
    } else {
      return Future.error("${response.statusCode} / ${response.body}");
    }
  }
}
