import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:traewelcross/components/color_circle.dart';
import 'package:traewelcross/components/profile_link.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/ride_info.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class MapStat extends StatelessWidget {
  const MapStat({super.key, required this.rides});

  final List<RideInfo> rides;

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;

    final allPoints = rides.expand((r) => r.coordinates!).toList();

    final uniqueUsers = rides
        .map((r) => r.userInfo)
        .fold<Map<int, Map<String, dynamic>>>({}, (map, userInfo) {
          map[userInfo["id"]] = userInfo;
          return map;
        })
        .values
        .toList();
    return ListView(
      children: [
        SizedBox(
          height: 512,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FlutterMap(
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: allPoints.isNotEmpty ? LatLngBounds.fromPoints(allPoints) : LatLngBounds(const LatLng(53.879,7.671), const LatLng(47.680,13.002)),
                  padding: const EdgeInsets.all(50),
                ),
                minZoom: 2,
                initialZoom: 5,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "de.traewelcross",
                ),
                TileLayer(
                  urlTemplate:
                      "https://{s}.tiles.openrailwaymap.org/${getIt<Config>().appearance.mapType.value}/{z}/{x}/{y}.png",
                  userAgentPackageName: "de.traewelcross",
                ),
                if(rides.isNotEmpty)
                PolylineLayer(
                  polylines: rides.map((ride) {
                    return Polyline(
                      points: ride.coordinates!,
                      color: SharedFunctions.getColorById(
                        id: ride.userInfo["id"],
                      ),
                      strokeWidth: 5.0,
                    );
                  }).toList(),
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      "OpenStreetMap",
                      onTap: () => launchUrl(
                        Uri.parse("https://www.openstreetmap.org/copyright"),
                      ),
                    ),
                    TextSourceAttribution(
                      "OpenRailwayMap",
                      onTap: () => launchUrl(
                        Uri.parse("http://www.openrailwaymap.org/"),
                      ),
                      prependCopyright: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if(uniqueUsers.isNotEmpty)
        Card(
          clipBehavior: Clip.hardEdge,
          child: ExpansionTile(
            shape: Border.all(color: Colors.transparent),
            clipBehavior: Clip.hardEdge,
            title: Text("${uniqueUsers.length} ${localize.users}"),
            enabled: true,
            children: uniqueUsers
                .map(
                  (user) => ProfileLink(
                    userData: user,
                    enableNavigateToProfile: false,
                    action: ColorCircle(
                      color: SharedFunctions.getColorById(id: user["id"]),
                      width: 24,
                      onTap: (_) => "",
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
