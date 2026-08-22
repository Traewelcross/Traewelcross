import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';

class TripApiProvider {
  final ApiService _api;
  TripApiProvider(this._api);

  /// Returns all statuses visible to the (un)authenticated user for a given trip
  Future<List<Status>> getSharedStatus(int tripId) async {
    final response = await _api.request(
      "/trips/${Uri.encodeComponent(tripId.toString())}/statuses",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<Status> statuses = jsonData
          .map((u) => Status.fromJson(u as Map<String, dynamic>))
          .toList();
      return statuses;
    }
    return [];
  }

  Future<List<TripResource>> getManualTrips() async {
    final response = await _api.request("/trips", .GET);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<TripResource> trips = jsonData
          .map((t) => TripResource.fromJson(t as Map<String, dynamic>))
          .toList();
      return trips;
    }
    return [];
  }

  Future<TripResource> createTrip(TripDraft tD) async {
    final response = await _api.request(
      "trips",
      .POST,
      body: jsonEncode(tD.toJson()),
    );
    if (response.statusCode == 201) {
      return TripResource.fromJson(jsonDecode(response.body)["data"]);
    } else {
      return Future.error("${response.statusCode} / ${response.body}");
    }
  }
}
