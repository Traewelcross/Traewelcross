import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class StatusProvider {
  final ApiService _api;

  StatusProvider(this._api);
  final navKeyContext =
      getIt<GlobalKey<NavigatorState>>().currentState?.context;
  Future<LikeResponse> like(int id, int currentCount) async {
    final res = await _api.request("/status/$id/like", HttpRequestTypes.POST);
    final json = jsonDecode(res.body);
    if (res.statusCode == 201) {
      return LikeResponse(wasSuccess: true, newCount: json["data"]["count"]);
    } else {
      if (navKeyContext == null) {
        return LikeResponse(wasSuccess: false, newCount: currentCount);
      }
      switch (res.statusCode) {
        case 409:
          return LikeResponse(wasSuccess: true, newCount: currentCount + 1);
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.noModifcationAllowedGeneric,
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.statusNotFound,
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
        case 429:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.rateLimit,
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
        default:
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar} ${res.statusCode}',
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
      }
    }
  }

  Future<LikeResponse> unlike(int id, int currentCount) async {
    final res = await _api.request("/status/$id/like", HttpRequestTypes.DELETE);
    final json = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return LikeResponse(wasSuccess: true, newCount: json["data"]["count"]);
    } else {
      if (navKeyContext == null) {
        return LikeResponse(wasSuccess: false, newCount: currentCount);
      }
      switch (res.statusCode) {
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.noModifcationAllowedGeneric,
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.statusNotFound,
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
        case 429:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.rateLimit,
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
        default:
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar} ${res.statusCode}',
          );
          return LikeResponse(wasSuccess: false, newCount: currentCount);
      }
    }
  }

  Future<Map<String, dynamic>?> update(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final res = await _api.request(
      "/status/$id",
      HttpRequestTypes.PUT,
      body: jsonEncode(payload),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["data"];
    } else {
      if (navKeyContext == null) return null;
      switch (res.statusCode) {
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.noModifcationAllowed,
          );
          break;
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.statusNotFound,
          );
          break;
        default:
          final message =
              jsonDecode(res.body)["message"]?.toString() ??
              res.statusCode.toString();
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar} $message',
          );
      }
      return null;
    }
  }

  Future<bool> delete(int id) async {
    final res = await _api.request("/status/$id", HttpRequestTypes.DELETE);
    if (res.statusCode == 204) {
      if (navKeyContext != null) {
        SharedFunctions.sendSnackBar(
          AppLocalizations.of(navKeyContext!)!.statusDeletedSuccessful,
        );
      }
      return true;
    } else {
      if (navKeyContext == null) return false;
      switch (res.statusCode) {
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.noModifcationAllowedGeneric,
          );
          break;
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(navKeyContext!)!.statusNotFound,
          );
          break;
        default:
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar} ${res.statusCode}',
          );
      }
      return false;
    }
  }

  Future<bool> report({
    required int id,
    required String reason,
    required String description,
  }) async {
    final res = await _api.request(
      "/reports",
      HttpRequestTypes.POST,
      body: jsonEncode({
        "subjectType": "Status",
        "subjectId": id,
        "reason": reason,
        "description": description,
      }),
    );
    if (res.statusCode == 201) {
      if (navKeyContext != null) {
        SharedFunctions.sendSnackBar(
          AppLocalizations.of(navKeyContext!)!.reportSuccess,
        );
      }
      return true;
    } else {
      if (navKeyContext != null) {
        SharedFunctions.sendSnackBar(
          '${AppLocalizations.of(navKeyContext!)!.genericErrorSnackBar} ${res.statusCode}',
        );
      }
      return false;
    }
  }
}

class LikeResponse {
  final bool wasSuccess;
  final int newCount;
  LikeResponse({required this.wasSuccess, required this.newCount});
}
