import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_info.dart';

class StatisticsApiProvider {
  final ApiService _api;
  StatisticsApiProvider(this._api);

  Future<List<RideInfo>> getPolylines({
    bool alternative = false,
    required DateTimeRange range,
  }) async {
    if (alternative) {
      print("using alternative");
      return _getRidesForUser(range);
    }
    final response = await _api.request(
      "/route-map?from=${range.start.toIso8601String()}&until=${range.end.toIso8601String()}&includeApproximated=true",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<RouteMapEntry> entries = jsonData
          .map((u) => RouteMapEntry.fromJson(u as Map<String, dynamic>))
          .toList();
      final List<List<LatLng>> polylines = .empty(growable: true);
      for (var e in entries) {
        polylines.add(_parseEncodedPolyline(e.polyline));
      }
      final userInfo = jsonDecode(
        (await SharedPreferencesAsync().getString("userinfo"))!,
      );
      return polylines
          .map(
            (cords) => RideInfo.fromCoords(LightUser.fromJson(userInfo), cords),
          )
          .toList();
    }
    return [];
  }

  List<LatLng> _parseEncodedPolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double finalLat = lat / 1e6;
      double finalLng = lng / 1e6;

      points.add(LatLng(finalLat, finalLng));
    }
    return points;
  }

  Future<List<DateTime>> _getRiddenDays(DateTimeRange statRange) async {
    // We could also go of prevDate in /statistics/daily, but I only see that after doing this, and also this way we get all available dates in one request
    final req = await _api.request(
      "/statistics?from=${statRange.start.toIso8601String()}&until=${statRange.end.toIso8601String()}",
      .GET,
    );
    final times = jsonDecode(req.body)["data"]["time"] as List<dynamic>;
    List<DateTime> riddenDays = [];
    for (var date in times) {
      if (date["count"] > 0) {
        riddenDays.add(DateTime.parse(date["date"]));
      }
    }
    //print(riddenDays);
    return riddenDays;
  }

  Future<List<RideInfo>> _getRidesForUser(DateTimeRange statRange) async {
    final List<List<LatLng>> coords = [];
    LightUser? userDetails;
    List<DateTime> riddenDays = await _getRiddenDays(statRange);
    for (DateTime date in riddenDays) {
      final req = await _api.request(
        "/statistics/daily/${date.toIso8601String()}?withPolylines=true",
        .GET,
      );
      final data = jsonDecode(req.body)["data"];
      if ((data["statuses"] as List<dynamic>).isEmpty ||
          data["polylines"] == null) {
        continue;
      }
      userDetails ??= LightUser.fromJson(
        (data["statuses"] as List<dynamic>).first["user"],
      );
      final polyFeatures = data["polylines"]["features"] as List<dynamic>;
      for (var feat in polyFeatures) {
        var lineCoords = feat["geometry"]["coordinates"] as List<dynamic>;
        List<LatLng> line = lineCoords.map((point) {
          return LatLng(point[1], point[0]);
        }).toList();
        coords.add(line);
      }
      await Future.delayed(Duration(milliseconds: 30));
    }
    if (userDetails == null) return [];
    return coords
        .map((cords) => RideInfo.fromCoords(userDetails!, cords))
        .toList();
  }
}
