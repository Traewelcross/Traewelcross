import 'dart:async';
import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:http/http.dart' as http;

class TrainApiProvider {
  final ApiService _api;

  TrainApiProvider(this._api);

  Future<TripResource> getTrip({required String tripId, required String lineName, required int startStopId}) async {
    http.Response response;
    try {
      response = await _api.request("/trains/trip?hafasTripId=${Uri.encodeComponent(tripId)}&lineName=${Uri.encodeComponent(lineName)}&start=${Uri.encodeComponent(startStopId.toString())}", .GET);
    } on TimeoutException {
      throw TimeoutException(null);
    }
    if (response.statusCode == 200){
      return TripResource.fromJson(jsonDecode(response.body)["data"]);
    } else {
      return Future.error(Exception(response.statusCode.toString()));
    }
  }
}