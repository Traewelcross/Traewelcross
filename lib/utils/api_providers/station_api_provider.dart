import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';

class StationApiProvider {
  final ApiService _api;

  StationApiProvider(this._api);

  Future<List<Station>> autocomplete({required String query}) async {
    final response = await _api.request(
      "/trains/station/autocomplete/${Uri.encodeComponent(query.replaceAll("/", " "))}",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<Station> stations = jsonData
          .map((u) => Station.fromJson(u as Map<String, dynamic>))
          .toList();
      return stations;
    } else {
      return Future.error("${response.statusCode} / ${response.body}");
    }
  }
}
