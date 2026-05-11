import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class StatusApiProvider {
  final ApiService _api;

  StatusApiProvider(this._api);
  BuildContext? get _context =>
      getIt<GlobalKey<NavigatorState>>().currentState?.context;
  Future<LikeCountResponse> like(int id, int currentCount) async {
    final res = await _api.request("/status/$id/like", HttpRequestTypes.POST);
    final json = jsonDecode(res.body);
    if (res.statusCode == 201) {
      return LikeCountResponse(
        wasSuccess: true,
        newCount: json["data"]["count"],
      );
    } else {
      if (_context == null) {
        return LikeCountResponse(wasSuccess: false, newCount: currentCount);
      }
      switch (res.statusCode) {
        case 409:
          return LikeCountResponse(
            wasSuccess: true,
            newCount: currentCount + 1,
          );
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
        case 429:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.rateLimit,
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
        default:
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(_context!)!.genericErrorSnackBar} ${res.statusCode}',
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
      }
    }
  }

  Future<LikeCountResponse> unlike(int id, int currentCount) async {
    final res = await _api.request("/status/$id/like", HttpRequestTypes.DELETE);
    final json = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return LikeCountResponse(
        wasSuccess: true,
        newCount: json["data"]["count"],
      );
    } else {
      if (_context == null) {
        return LikeCountResponse(wasSuccess: false, newCount: currentCount);
      }
      switch (res.statusCode) {
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
        case 429:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.rateLimit,
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
        default:
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(_context!)!.genericErrorSnackBar} ${res.statusCode}',
          );
          return LikeCountResponse(wasSuccess: false, newCount: currentCount);
      }
    }
  }

  Future<Status?> update(int id, Map<String, dynamic> payload) async {
    final res = await _api.request(
      "/status/$id",
      HttpRequestTypes.PUT,
      body: jsonEncode(payload),
    );

    if (res.statusCode == 200) {
      return Status.fromJson(jsonDecode(res.body)["data"]);
    } else {
      if (_context == null) return null;
      switch (res.statusCode) {
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowed,
          );
          break;
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
          );
          break;
        default:
          final message =
              jsonDecode(res.body)["message"]?.toString() ??
              res.statusCode.toString();
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(_context!)!.genericErrorSnackBar} $message',
          );
      }
      return null;
    }
  }

  Future<bool> delete(int id) async {
    final res = await _api.request("/status/$id", HttpRequestTypes.DELETE);
    if (res.statusCode == 204) {
      if (_context != null) {
        SharedFunctions.sendSnackBar(
          AppLocalizations.of(_context!)!.statusDeletedSuccessful,
        );
      }
      return true;
    } else {
      if (_context == null) return false;
      switch (res.statusCode) {
        case 403:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
          break;
        case 404:
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
          );
          break;
        default:
          SharedFunctions.sendSnackBar(
            '${AppLocalizations.of(_context!)!.genericErrorSnackBar} ${res.statusCode}',
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
      if (_context != null) {
        SharedFunctions.sendSnackBar(
          AppLocalizations.of(_context!)!.reportSuccess,
        );
      }
      return true;
    } else {
      if (_context != null) {
        SharedFunctions.sendSnackBar(
          '${AppLocalizations.of(_context!)!.genericErrorSnackBar} ${res.statusCode}',
        );
      }
      return false;
    }
  }

  Future<Status?> getActiveRide() async {
    final res = await _api.request(
      "/user/statuses/active",
      HttpRequestTypes.GET,
    );
    if (res.statusCode == 200) {
      return Status.fromJson(jsonDecode(res.body)["data"]);
    } else {
      return null;
    }
  }

  Future<List<Status>> fetchRides({
    required StatusListType type,
    String? username,
    int? page,
  }) async {
    String endpoint;
    switch (type) {
      case .dashboard:
        endpoint = "/dashboard?page=$page";
        break;
      case .onTheMove:
        endpoint = "/statuses";
        break;
      case .user:
        endpoint = "/user/$username/statuses?page=$page";
        break;
    }
    final res = await _api.request(endpoint, .GET);
    if (res.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(res.body)["data"];
      final List<Status> statues = jsonData
          .map((u) => Status.fromJson(u as Map<String, dynamic>))
          .toList();
      return statues;
    }
    return Future.error(Exception("${res.statusCode} / ${res.body}"));
  }

  Future<Tag?> submitTag({required Tag tag, required int rideId}) async {
    final res = await _api.request(
      "/status/$rideId/tags",
      .POST,
      encoding: Encoding.getByName("UTF-8"),
      body: jsonEncode(tag),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)["data"];
      return Tag(
        key: data["key"],
        value: data["value"],
        visibility: TripVisibilityEnum.fromValue(data["visibility"]),
      );
    }
    switch (res.statusCode) {
      case 401 || 403:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
        }
        break;
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
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

  Future<Tag?> editTag({
    required Tag oldTag,
    required Tag newTag,
    required int rideId,
  }) async {
    final res = await _api.request(
      "/status/$rideId/tags/${oldTag.key}",
      .PUT,
      encoding: Encoding.getByName("UTF-8"),
      body: jsonEncode(newTag),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)["data"];
      return Tag(
        key: data["key"],
        value: data["value"],
        visibility: TripVisibilityEnum.fromValue(data["visibility"]),
      );
    }
    switch (res.statusCode) {
      case 401 || 403:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
        }
        break;
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
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

  Future<GenericStatusResponse> deleteTag({
    required Tag tag,
    required int rideId,
  }) async {
    final res = await _api.request("/status/$rideId/tags/${tag.key}", .DELETE);
    if (res.statusCode == 200) {
      return GenericStatusResponse(wasSuccess: true);
    }
    switch (res.statusCode) {
      case 401 || 403:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
        }
        break;
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
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
    return GenericStatusResponse(wasSuccess: false);
  }

  Future<Status> fetchRide(int rideId) async {
    final res = await _api.request("/status/$rideId", .GET);
    if (res.statusCode == 200) {
      return Status.fromJson(jsonDecode(res.body)["data"]);
    }
    switch (res.statusCode) {
      case 401 || 403:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
        }
        break;
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
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
    return Future.error("${res.statusCode} / ${res.body}");
  }

  Future<List<User>> getLikes(int rideId) async {
    final res = await _api.request("/status/$rideId/likes", .GET);
    if (res.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(res.body)["data"];
      final List<User> likes = jsonData
          .map((u) => User.fromJson(u as Map<String, dynamic>))
          .toList();
      return likes;
    }
    switch (res.statusCode) {
      case 401 || 403:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.noModifcationAllowedGeneric,
          );
        }
        break;
      case 404:
        if (_context != null) {
          SharedFunctions.sendSnackBar(
            AppLocalizations.of(_context!)!.statusNotFound,
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
    return Future.error("${res.statusCode} / ${res.body}");
  }

  Future<Station> getStationData({
    required int stationId,
    required bool withIdentifiers,
  }) async {
    final res = await _api.request(
      "/station/$stationId?withIdentifiers=${withIdentifiers.toString()}",
      .GET,
    );
    if (res.statusCode == 200) {
      return Station.fromJson(jsonDecode(res.body)["data"]);
    }
    return Future.error("${res.statusCode} / ${res.body}");
  }
}

enum StatusListType { dashboard(), onTheMove(), user() }

class LikeCountResponse {
  final bool wasSuccess;
  final int newCount;
  LikeCountResponse({required this.wasSuccess, required this.newCount});
}
