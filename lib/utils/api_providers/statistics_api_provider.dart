import 'dart:convert';
import 'dart:math' as math;

import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:traewelcross/enums/depart_types.dart';
import 'package:traewelcross/enums/trip_type.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_info.dart';

class MapFilters {
  Set<DepartTypes> travelTypes;
  Set<TripType> travelPurpose;
  bool includeApprox;
  MapFilters({
    required this.travelTypes,
    required this.travelPurpose,
    this.includeApprox = true
  });
}

class StatisticsApiProvider {
  final ApiService _api;
  StatisticsApiProvider(this._api);

  Future<List<RideInfo>> getPolylines({
    required DateTimeRange range,
    MapFilters? filter
  }) async {
    filter ??= MapFilters(travelTypes: {}, travelPurpose: {});
    String endpoint = "/route-map?from=${range.start.toIso8601String()}&until=${range.end.toIso8601String()}&includeApproximated=${filter.includeApprox.toString()}";
    if(filter.travelPurpose.isNotEmpty){
      for(TripType p in filter.travelPurpose){
        endpoint += "&travelPurposes%5B%5D=${p.value}";
      }
    }
    if(filter.travelTypes.isNotEmpty){
      for(DepartTypes d in filter.travelTypes){
        endpoint += "&travelTypes%5B%5D=${d.value}";
      }
    }
    final response = await _api.request(
      endpoint,
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<RouteMapEntry> entries = jsonData
          .map((u) => RouteMapEntry.fromJson(u as Map<String, dynamic>))
          .toList();
      final List<List<LatLng>> polylines = .empty(growable: true);
      for (var e in entries) {
        polylines.add(_parseEncodedPolyline(e.polyline, e.polylinePrecision));
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

  List<LatLng> _parseEncodedPolyline(String encoded, int precision) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    final double factor = math.pow(10, precision).toDouble();
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

      double finalLat = lat / factor;
      double finalLng = lng / factor;

      points.add(LatLng(finalLat, finalLng));
    }
    return points;
  }
}
