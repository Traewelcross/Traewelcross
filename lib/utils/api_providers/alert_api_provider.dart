import 'dart:async';
import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';

class AlertApiProvider {
  final ApiService _api;

  AlertApiProvider(this._api);

  Future<List<Alert>> get() async {
    final response = await _api.request(
      "/alerts",
      .GET,
    );
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
}
