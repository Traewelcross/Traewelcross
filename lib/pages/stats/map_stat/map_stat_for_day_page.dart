import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_info.dart';
import 'package:traewelcross/utils/shared.dart';

class MapStatForDayPage extends StatefulWidget {
  const MapStatForDayPage({super.key, required this.rideInfo, required this.date});
  @override
  State<MapStatForDayPage> createState() => _MapStatForDayPageState();
  final List<RideInfo> rideInfo;
  final DateTime date;
}

class _MapStatForDayPageState extends State<MapStatForDayPage> {
  late Future<List<RideInfo>> _polylineFuture;

  @override
  void initState() {
    super.initState();
    _polylineFuture = _loadAllPolylines();
  }

  Future<List<RideInfo>> _loadAllPolylines() async {
    final api = getIt<ApiService>();
    if (widget.rideInfo.isEmpty) {
      return [];
    }

    const int chunkSize = 20;
    final allRides = widget.rideInfo;
    try {
      for (int i = 0; i < allRides.length; i += chunkSize) {
        int end =
            (i + chunkSize < allRides.length) ? i + chunkSize : allRides.length;
        var chunk = allRides.sublist(i, end);
        String ids = chunk.map((ride) => ride.rideId).join(',');
        final response = await api.request(
          "/polyline/$ids",
          HttpRequestTypes.GET,
        );
        final json = jsonDecode(response.body)["data"]["features"];
        for (var feat in json) {
          int rideId = feat["properties"]["statusId"];
          final ride = allRides.firstWhere((r) => r.rideId == rideId);
          final List<dynamic> coords = feat["geometry"]["coordinates"];
          ride.coordinates =
              coords.map((c) {
                return LatLng(c[1] as double, c[0] as double);
              }).toList();
        }
      }
      return allRides;
    } catch (e) {
      return Future.error("Failed to fetch polylines");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(
        localize.mapPageTitle(
          DateFormat.yMMMEd(
            Localizations.localeOf(context).languageCode,
          ).format(widget.date),
        ),
      ),
      body: FutureBuilder<List<RideInfo>>(
        future: _polylineFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final ridesWithCoords =
              snapshot.data
                  ?.where(
                    (r) => r.coordinates != null && r.coordinates!.isNotEmpty,
                  )
                  .toList() ??
              [];
          return MapStat(rides: ridesWithCoords);
        },
      ),
    );
  }
}
