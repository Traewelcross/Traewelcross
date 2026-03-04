import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_info.dart';
import 'package:traewelcross/utils/shared.dart';

class MapStatForUser extends StatefulWidget {
  const MapStatForUser({super.key});

  @override
  State<MapStatForUser> createState() => _MapStatForUserState();
}

class _MapStatForUserState extends State<MapStatForUser> {
  DateTimeRange statRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 7)),
    end: DateTime.now(),
  );
  late Future<List<RideInfo>> rides;

  @override
  void initState() {
    super.initState();
    rides = _getRidesForUser();
  }

  Future<List<DateTime>> _getRiddenDays() async {
    // We could also go of prevDate in /statistics/daily, but I only see that after doing this, and also this way we get all available dates in one request
    final api = getIt<ApiService>();
    final req = await api.request(
      "/statistics?from=${statRange.start.toIso8601String()}&until=${statRange.end.toIso8601String()}",
      HttpRequestTypes.GET,
    );
    final times = jsonDecode(req.body)["data"]["time"] as List<dynamic>;
    List<DateTime> riddenDays = [];
    for (var date in times) {
      if (date["count"] > 0) {
        riddenDays.add(DateTime.parse(date["date"]));
      }
    }
    print(riddenDays);
    return riddenDays;
  }

  Future<List<RideInfo>> _getRidesForUser() async {
    final api = getIt<ApiService>();
    final List<List<LatLng>> coords = [];
    Map<String, dynamic>? userDetails;
    List<DateTime> riddenDays = await _getRiddenDays();
    for (DateTime date in riddenDays) {
      final req = await api.request(
        "/statistics/daily/${date.toIso8601String()}?withPolylines=true",
        HttpRequestTypes.GET,
      );
      final data = jsonDecode(req.body)["data"];
      if ((data["statuses"] as List<dynamic>).isEmpty ||
          data["polylines"] == null) {
        continue;
      }
      userDetails ??= (data["statuses"] as List<dynamic>).first["userDetails"];
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

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return FutureBuilder<List<RideInfo>>(
      future: rides,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return SingleChildScrollView(
            child: Text(asyncSnapshot.error!.toString()),
          );
        }
        if (asyncSnapshot.connectionState == .waiting) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                CircularProgressIndicator(),
                Text(localize.waitForStatsMsg, textAlign: .center,),
              ],
            ),
          );
        }
        if (asyncSnapshot.connectionState == .done) {
          return Column(
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final rangeSelect = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now(),
                    initialDateRange: DateTimeRange(
                      start: DateTime.now().subtract(Duration(days: 28)),
                      end: DateTime.now(),
                    ),
                    currentDate: DateTime.now(),
                  );
                  if (rangeSelect == null) {
                    return;
                  }
                  setState(() {
                    statRange = rangeSelect;
                    rides = _getRidesForUser();
                  });
                },
                label: Text(
                  localize.dateSpan(
                    DateFormat.yMMMEd(
                      Localizations.localeOf(context).languageCode,
                    ).format(statRange.start),
                    DateFormat.yMMMEd(
                      Localizations.localeOf(context).languageCode,
                    ).format(statRange.end),
                  ),
                ),
                icon: const Icon(Icons.calendar_month),
              ),
              SizedBox(height: 8),
              Expanded(child: MapStat(rides: asyncSnapshot.data!)),
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}
