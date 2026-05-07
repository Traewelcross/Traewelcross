import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class UserApiProvider {
  final ApiService _api;
  UserApiProvider(this._api);
  final navKeyContext =
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
      SharedFunctions.sendSnackBar(
        AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar +
            res.statusCode.toString(),
      );
      return Future.error("${res.statusCode} / ${res.body}");
    }
  }
  Future<GenericStatusResponse> denyFollowRequest(int userId) async {
    final res = await _api.request("/user/self/follow-requests/$userId", .DELETE);
    if (res.statusCode == 200) {
      return GenericStatusResponse(wasSuccess: true);
    } else {
      SharedFunctions.sendSnackBar(
        AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar +
            res.statusCode.toString(),
      );
      return Future.error("${res.statusCode} / ${res.body}");
    }
  }
  Future<GenericStatusResponse> unfollow(int userId) async {
        final res = await _api.request("/user/$userId/follow", .DELETE);
    if (res.statusCode == 200) {
      return GenericStatusResponse(wasSuccess: true);
    } else {
      SharedFunctions.sendSnackBar(
        AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar +
            res.statusCode.toString(),
      );
      return Future.error("${res.statusCode} / ${res.body}");
    }
  }
  Future<GenericStatusResponse> removeFollower(int userId) async {
        final res = await _api.request("/user/self/followers/$userId", .DELETE);
    if (res.statusCode == 200) {
      return GenericStatusResponse(wasSuccess: true);
    } else {
      SharedFunctions.sendSnackBar(
        AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar +
            res.statusCode.toString(),
      );
      return Future.error("${res.statusCode} / ${res.body}");
    }
  }
}
