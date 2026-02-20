import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import "package:traewelcross/components/profile_link.dart";
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/ride_quick_view.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/color_scheme.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<LatLng>> _fetchAndParsePolyline(
  ApiService apiService,
  int rideId,
) async {
  final response = await apiService.request(
    "/polyline/$rideId",
    HttpRequestTypes.GET,
  );

  if (response.statusCode != 200) {
    return Future.error(
      Exception(
        'Failed to load polyline for ride $rideId: HTTP ${response.statusCode}',
      ),
    );
  }

  final jsonResponse = jsonDecode(response.body);

  final features = jsonResponse?['data']?['features'];
  List coordinates = [];
  if (features is List && features.isNotEmpty) {
    final feature = features.first;
    if (feature?['geometry']?['coordinates'] is List) {
      coordinates = feature['geometry']['coordinates'];
    }
  }

  try {
    return coordinates
        .whereType<List>()
        .where(
          (point) => point.length >= 2 && point[0] is num && point[1] is num,
        )
        .map((point) => LatLng(point[1], point[0]))
        .toList();
  } catch (e) {
    throw Exception('Failed to parse polyline coordinates: $e');
  }
}

class DetailedRideView extends StatefulWidget {
  const DetailedRideView({
    super.key,
    this.rideId,
    this.rideData,
    this.authUserId,
  });
  final int? rideId;
  final dynamic rideData;
  final int? authUserId;

  @override
  State<DetailedRideView> createState() => _DetailedRideViewState();
}

class _DetailedRideViewState extends State<DetailedRideView> {
  late final Future<List<LatLng>> _polylineFuture;
  late Future<List<dynamic>> _likes;
  late Future<Map<String, dynamic>> _rideData;
  late final int _rideId;
  bool isFound = true;

  Future<List<dynamic>> _getLikeData() async {
    final apiService = getIt<ApiService>();
    final request = await apiService.request(
      "/status/$_rideId/likes",
      HttpRequestTypes.GET,
    );
    if (request.statusCode == 200) {
      final json = jsonDecode(request.body);
      return json["data"] as List<dynamic>;
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> _getRideData() async {
    final apiService = getIt<ApiService>();
    http.Response res;
    try {
      res = await apiService.request("/status/$_rideId", HttpRequestTypes.GET);
    } on TimeoutException {
      if (!mounted) return {};
      SharedFunctions.handleRequestTimeout(context, _getRideData);
      return {};
    }

    switch (res.statusCode) {
      case 200:
        final json = jsonDecode(res.body);
        return json["data"] as Map<String, dynamic>;
      case 404:
        if (!mounted) throw Exception("Not found");
        throw Exception(AppLocalizations.of(context)!.statusNotFound);
      default:
        throw Exception(
          "${AppLocalizations.of(context)!.genericErrorSnackBar} ${res.statusCode}",
        );
    }
  }

  @override
  void initState() {
    super.initState();
    final apiService = getIt<ApiService>();
    if (widget.rideId == null) {
      _rideId = widget.rideData["id"];
    } else {
      _rideId = widget.rideId!;
    }
    _polylineFuture = _fetchAndParsePolyline(apiService, _rideId);
    _rideData = widget.rideData == null
        ? _getRideData()
        : Future.value(widget.rideData!);
    _likes = _getLikeData();
  }

  void _likeCallback() {
    setState(() {
      _likes = _getLikeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;

    return FutureBuilder<Map<String, dynamic>>(
      future: _rideData,
      builder: (context, rideSnapshot) {
        if (rideSnapshot.connectionState == ConnectionState.waiting) {
          return MainScaffold(
            title: AppBarTitle(localize.loading),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (rideSnapshot.hasError) {
          return MainScaffold(
            title: AppBarTitle("Error"),
            body: Center(child: Text("Error: ${rideSnapshot.error}")),
          );
        }
        if (!rideSnapshot.hasData || rideSnapshot.data!.isEmpty) {
          return MainScaffold(
            title: AppBarTitle(localize.rideNotFound),
            body: const Center(child: Text("Could not load ride details.")),
          );
        }

        final rideData = rideSnapshot.data!;
        final originName =
            rideData["train"]?["origin"]?["name"] ?? "Unknown Origin";
        final destinationName =
            rideData["train"]?["destination"]?["name"] ?? "Unknown Destination";
        final title = "$originName -> $destinationName";

        return MainScaffold(
          title: AppBarTitle(title),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _rideData = _getRideData();
                _likes = _getLikeData();
              });
            },
            child: ListView(
              children: [
                FutureBuilder<List<LatLng>>(
                  future: _polylineFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error loading map: ${snapshot.error}"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox(
                        height: 512,
                        child: _MapDisplay(polylinePoints: snapshot.data!),
                      );
                    }
                    return const SizedBox(height: 0);
                  },
                ),
                const SizedBox(height: 12),
                Hero(
                  tag: "rqv-${rideData["id"]}",
                  child: RideQuickView(
                    rideData: rideData,
                    authUserId: widget.authUserId ?? 0,
                    detailedView: true,
                    likeCallback: _likeCallback,
                  ),
                ),
                FutureBuilder(
                  future: _likes,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: ExpansionTile(
                          shape: Border.all(color: Colors.transparent),
                          title: Text(
                            "${asyncSnapshot.data!.length.toString()} ${localize.likes(asyncSnapshot.data!.length)}",
                          ),
                          dense: false,
                          enabled: asyncSnapshot.data!.isEmpty ? false : true,
                          children: List.generate(
                            asyncSnapshot.data!.length,
                            (int i) =>
                                ProfileLink(userData: asyncSnapshot.data![i]),
                          ),
                        ),
                      );
                    }
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: ExpansionTile(
                        shape: Border.all(color: Colors.transparent),
                        clipBehavior: Clip.hardEdge,
                        title: Text("0 ${localize.likes(0)}"),
                        enabled: false,
                        children: const [],
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            localize.operatedBy(
                              rideData["train"]["operator"]?["name"] ?? "N/A",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            localize.checkedInWith(
                              rideData["client"]?["name"] ?? "Träwelling",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            rideData["train"]["dataSource"]?["attribution"] ??
                                "N/A",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            SharedFunctions.launchURL(
                              Uri.parse(
                                "https://bahn.expert/details/${rideData["train"]["journeyNumber"]}/${rideData["train"]["origin"]["departurePlanned"]}?evaNumberAlongRoute=${rideData["train"]["origin"]["evaIdentifier"]}",
                              ),
                            );
                          },
                          label: Text(localize.bahnExpert),
                          icon: const Icon(Icons.train),
                        ),
                      ),
                    ],
                  ),
                ),
                if (kDebugMode)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Debug\nID: ${rideData["id"].toString()}\n\n${rideData.toString()}",
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MapDisplay extends StatelessWidget {
  const _MapDisplay({this.polylinePoints});

  final List<LatLng>? polylinePoints;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FlutterMap(
        options: MapOptions(
          initialCameraFit: polylinePoints != null
              ? CameraFit.bounds(
                  bounds: LatLngBounds.fromPoints(polylinePoints!),
                  padding: const EdgeInsets.all(50),
                )
              : null,
          minZoom: 5,
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
          if (polylinePoints != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: polylinePoints!,
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 5.0,
                ),
              ],
            ),
          if (polylinePoints != null)
            MarkerLayer(
              markers: List<Marker>.generate(
                polylinePoints!.length,
                (int i) => Marker(
                  point: polylinePoints![i],
                  child: Builder(
                    builder: (context) {
                      if (i == polylinePoints!.length - 1) {
                        return const Icon(Icons.flag, color: tcColorLight);
                      }
                      if (i == 0) {
                        return const Icon(Icons.start, color: Colors.redAccent);
                      }
                      return const SizedBox(height: 0);
                    },
                  ),
                  alignment: const Alignment(0, -0.6),
                ),
              ),
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
                "Style: CC-BY-SA 2.0",
                onTap: () => launchUrl(
                  Uri.parse("http://creativecommons.org/licenses/by-sa/2.0/"),
                ),
                prependCopyright: false,
              ),
              TextSourceAttribution(
                "OpenRailwayMap",
                onTap: () =>
                    launchUrl(Uri.parse("http://www.openrailwaymap.org/")),
                prependCopyright: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
