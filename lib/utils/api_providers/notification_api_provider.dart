import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';
import "package:traewelcross/utils/api_providers/api_models.dart" as models;

class NotificationApiProvider {
  final ApiService _api;
  final navKeyContext =
      getIt<GlobalKey<NavigatorState>>().currentState?.context;
  NotificationApiProvider(this._api);
  Future<int> getNotificationCount() async {
    final res = await _api.request(
      "/notifications/unread/count",
      HttpRequestTypes.GET,
    );
    if (res.statusCode == 200) {
      if (!navKeyContext!.mounted) return Future.value(0);
      return jsonDecode(res.body)["data"];
    }
    return Future.value(0);
  }

  Future<void> markAllRead() async {
    await _api.request("/notifications/read/all", HttpRequestTypes.PUT);
  }

  Future<List<models.Notification>> fetchNotifications({
    required int page,
  }) async {
    final response = await _api.request(
      "/notifications?page=$page",
      HttpRequestTypes.GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<models.Notification> notifications = jsonData
          .map((u) => models.Notification.fromJson(u as Map<String, dynamic>))
          .toList();
      return notifications;
    } else {
      return Future.error("${response.statusCode} / ${response.body}");
    }
  }
}
