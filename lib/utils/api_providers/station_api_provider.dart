import 'dart:async';
import 'dart:convert';

import 'package:traewelcross/enums/depart_types.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:http/http.dart' as http;

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
  Future<Station> getNearestStation(double latitude, double longitude) async {
    http.Response response;
    try {
     response = await _api.request(
      "/trains/station/nearby?latitude=$latitude&longitude=$longitude", .GET
      );
    } on TimeoutException {
      throw TimeoutException("");
    }
    if(response.statusCode == 200){
      return Station.fromJson(jsonDecode(response.body)["data"]);
    }
    throw TimeoutException("");
  }
  Future<List<Departure>> getDepartures({required int stationId, required DateTime when, required DepartTypes type}) async{
        http.Response response;
    try {
     response = await _api.request(
      "/station/$stationId/departures?when=${when.toUtc().toIso8601String()}&travelType=$type", .GET
      );
    } on TimeoutException {
      throw TimeoutException("");
    }
    if(response.statusCode == 200){
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<Departure> departures = jsonData
          .map((u) => Departure.fromJson(u as Map<String, dynamic>))
          .toList();
      return departures;
    }
    throw TimeoutException("");
  }
}
