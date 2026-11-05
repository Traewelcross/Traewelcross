import 'dart:async';
import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class AlertApiProvider {
  final ApiService _api;
  static const appAlertUrl = "https://alerts.traewelcross.de/alerts/";
  AlertApiProvider(this._api);

  Future<List<Alert>> get() async {
    final response = await _api.request("/alerts", .GET);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<Alert> alerts = jsonData
          .map((u) => Alert.fromJson(u as Map<String, dynamic>))
          .toList();
      return alerts;
    } else {
      return [];
    }
  }
  Future<List<Alert>> getAppAlerts() async {
    final client = await getIt<ApiService>().getAuthenticatedClient();
    final response = await client!.get(Uri.parse(appAlertUrl+(await PackageInfo.fromPlatform()).buildNumber));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Alert> alerts = jsonData
          .map((u) => Alert.fromJson(u as Map<String, dynamic>))
          .toList();
      return alerts;
    } else {
      return [];
    }
  }
}
