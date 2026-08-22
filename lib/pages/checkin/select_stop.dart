import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/checkin/checkin.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/departure_time.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/check_in_info.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';

class SelectStop extends StatefulWidget {
  const SelectStop({
    super.key,
    required this.lineName,
    required this.tripId,
    required this.destination,
    required this.startStopId,
    required this.category,
    required this.departureTime,
    this.editCallback,
  });
  final String lineName;
  final String tripId;
  final String destination;
  final int startStopId;
  final String category;
  final String departureTime;
  final void Function(Map<String, dynamic> destinationInfo)? editCallback;
  @override
  State<SelectStop> createState() => _SelectStopState();
}

class _SelectStopState extends State<SelectStop> {
  late Future<TripResource> _trip;

  @override
  void initState() {
    super.initState();
    _trip = _fetchTrip();
  }

  Future<TripResource> _fetchTrip() async {
    final apiService = getIt<ApiService>();
    TripResource response;
    try {
      response = await apiService.train.getTrip(
        tripId: widget.tripId,
        lineName: widget.lineName,
        startStopId: widget.startStopId,
      );
    } on TimeoutException {
      if (!mounted) return Future.error(TimeoutException(null));
      SharedFunctions.handleRequestTimeout(context, _fetchTrip);
      return Future.error(TimeoutException(null));
    }
    // This might yield empty results but trying to use Träwelling directly on the journeys where this happens, you're also unable to check in.
    // Since this happens rarely and I'm currently to lazy to find a fix (if there is one), ostrich algorithm is applied for now.
    // Example stopovers where this happens (when using station id 168741975):  "stopovers": [{"id": 168741975,"uuid": "09e0f739-4d9e-4819-88f2-02bf3c603b5f","stopoverId": 1093714859,"name": "Buxtehude, ZOB","rilIdentifier": null,"evaIdentifier": null,"arrival": "2026-08-07T19:35:00+00:00","arrivalPlanned": "2026-08-07T19:35:00+00:00","arrivalReal": null,"arrivalPlatformPlanned": "1","arrivalPlatformReal": null,"departure": "2026-08-07T19:35:00+00:00","departurePlanned": "2026-08-07T19:35:00+00:00","departureReal": null,"departurePlatformPlanned": "1","departurePlatformReal": null,"platform": "1","isArrivalDelayed": false,"isDepartureDelayed": false,"cancelled": false},{"id": 168897167,"uuid": "2c02d563-108c-4766-bbe0-13e516a9c7b4","stopoverId": 1093714860,"name": "Buxtehude Sagekuhle","rilIdentifier": null,"evaIdentifier": null,"arrival": "2026-08-07T19:40:00+00:00","arrivalPlanned": "2026-08-07T19:40:00+00:00","arrivalReal": null,"arrivalPlatformPlanned": "1","arrivalPlatformReal": null,"departure": "2026-08-07T19:40:00+00:00","departurePlanned": "2026-08-07T19:40:00+00:00","departureReal": null,"departurePlatformPlanned": "1","departurePlatformReal": null,"platform": "1","isArrivalDelayed": false,"isDepartureDelayed": false,"cancelled": false},{"id": 168931900,"uuid": "350b9b7e-4e35-420c-b7c2-7e8a33bf9f9b","stopoverId": 1093714861,"name": "Heitmannshausen, Ilskamp","rilIdentifier": null,"evaIdentifier": null,"arrival": "2026-08-07T19:45:00+00:00","arrivalPlanned": "2026-08-07T19:45:00+00:00","arrivalReal": null,"arrivalPlatformPlanned": "1","arrivalPlatformReal": null,"departure": "2026-08-07T19:45:00+00:00","departurePlanned": "2026-08-07T19:45:00+00:00","departureReal": null,"departurePlatformPlanned": "1","departurePlatformReal": null,"platform": "1","isArrivalDelayed": false,"isDepartureDelayed": false,"cancelled": false},{"id": 168771521,"uuid": "4c33bf0d-fb3b-45a2-9d76-3943147a5d78","stopoverId": 1093714862,"name": "Neukloster","rilIdentifier": null,"evaIdentifier": null,"arrival": "2026-08-07T19:50:00+00:00","arrivalPlanned": "2026-08-07T19:50:00+00:00","arrivalReal": null,"arrivalPlatformPlanned": "1","arrivalPlatformReal": null,"departure": "2026-08-07T19:50:00+00:00","departurePlanned": "2026-08-07T19:50:00+00:00","departureReal": null,"departurePlatformPlanned": "1","departurePlatformReal": null,"platform": "1","isArrivalDelayed": false,"isDepartureDelayed": false,"cancelled": false},{"id": 168931899,"uuid": "d18dddbd-752e-44e6-83c7-232f7be40d39","stopoverId": 1093714863,"name": "Hedendorf, Fuhrenkamp","rilIdentifier": null,"evaIdentifier": null,"arrival": "2026-08-07T19:55:00+00:00","arrivalPlanned": "2026-08-07T19:55:00+00:00","arrivalReal": null,"arrivalPlatformPlanned": "1","arrivalPlatformReal": null,"departure": "2026-08-07T19:55:00+00:00","departurePlanned": "2026-08-07T19:55:00+00:00","departureReal": null,"departurePlatformPlanned": "1","departurePlatformReal": null,"platform": "1","isArrivalDelayed": false,"isDepartureDelayed": false,"cancelled": false},{"id": 40190315,"uuid": "2ff2523b-f6a8-4b51-bae0-9e5ddd00c16d","stopoverId": 1093714864,"name": "Claustal, Nottensdorf","rilIdentifier": null,"evaIdentifier": null,"arrival": "2026-08-07T20:00:00+00:00","arrivalPlanned": "2026-08-07T20:00:00+00:00","arrivalReal": null,"arrivalPlatformPlanned": "1","arrivalPlatformReal": null,"departure": "2026-08-07T20:00:00+00:00","departurePlanned": "2026-08-07T20:00:00+00:00","departureReal": null,"departurePlatformPlanned": "1","departurePlatformReal": null,"platform": "1","isArrivalDelayed": false,"isDepartureDelayed": false,"cancelled": false}],
    response.stopovers = response.stopovers.reversed.toList();
    // Workaround https://github.com/Traewelling/traewelling/issues/3791
    for (var i = response.stopovers.length - 1; i >= 0; i--) {
      if (widget.startStopId == response.stopovers[i].id) {
        break;
      } else {
        response.stopovers.removeAt(i);
      }
    }
    if (response.stopovers.isNotEmpty) {
      response.stopovers.removeLast();
    }
    response.stopovers = response.stopovers.reversed.toList();
    return response;
  }

  /*void _checkIn(int id, String name, String arrivalTime, String tripId) {
    if (widget.editCallback != null) {
      widget.editCallback!({
        "name": name,
        "id": id,
        "arrivalTime": arrivalTime,
      });
      Navigator.pop(context);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CheckIn(
          checkInInfo: CheckInInfo(
            departureId: widget.startStopId,
            tripId: tripId,
            lineName: widget.lineName,
            destination: name,
            destinationId: id,
            category: widget.category,
            departureTime: widget.departureTime,
            arrivalTime: arrivalTime,
          ),
          isEdit: false,
        ),
      ),
    );
  }*/

  void _navigateToCheckIn({
    required CheckInInfo primary,
    CheckInInfo? continuation,
  }) {
    if (widget.editCallback != null) {
      // Use continuation details if available, otherwise fallback to primary
      final finalLeg = continuation ?? primary;

      widget.editCallback!({
        "name": finalLeg.destination,
        "id": finalLeg.destinationId,
        "arrivalTime": finalLeg.arrivalTime,
      });

      Navigator.pop(context);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CheckIn(
          checkInInfo: primary,
          continuationCheckInInfo: continuation,
          isEdit: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Move FutureBuilder up and apply trip routeColor
    return MainScaffold(
      title: AppBarTitle("${widget.lineName} -> ${widget.destination}"),
      body: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RideIconTag(
                          iconInfo: RideIconTagInfo(
                            category: widget.category,
                            width: 24,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${widget.lineName} -> ${widget.destination}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: FutureBuilder(
                        future: _trip,
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState == .waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.connectionState == .done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.error, size: 48),
                                    Text(snapshot.error.toString()),
                                  ],
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              final trip = snapshot.data!;
                              final mainStops = trip.stopovers;
                              final continuation = trip.continuationTrip;

                              final hasContinuation =
                                  continuation != null &&
                                  widget.editCallback == null;
                              final mainCount = mainStops.length;
                              final continuationCount = hasContinuation
                                  ? continuation.stopovers.length
                                  : 0;
                              final totalItems =
                                  mainCount +
                                  (hasContinuation ? 1 + continuationCount : 0);
                              if (totalItems == 0) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: .min,
                                    spacing: 8,
                                    children: [
                                      const Icon(Icons.error, size: 48),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.noStationsFound,
                                        textAlign: .center,
                                      ),
                                      FilledButton.icon(
                                        icon: const Icon(Icons.home),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        label: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.returnToDashboard,
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () => SharedFunctions.launchURL(
                                          Uri.parse(
                                            "https://traewelling.de/stationboard?stationId=${widget.startStopId}&when=${Uri.encodeComponent(widget.departureTime)}",
                                          ),
                                        ),
                                        label: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.openTraewelling,
                                        ),
                                        icon: const Icon(Icons.open_in_new),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: totalItems,
                                itemBuilder: (ctx, idx) {
                                  if (idx < mainCount) {
                                    return StopoverRow(
                                      callback: (id, name, arrival) {
                                        _navigateToCheckIn(
                                          primary: .new(
                                            departureId: widget.startStopId,
                                            tripId: widget.tripId,
                                            lineName: widget.lineName,
                                            destination:
                                                mainStops[idx].station?.name ??
                                                mainStops[idx].name ??
                                                "???",
                                            destinationId:
                                                mainStops[idx].station?.id ??
                                                mainStops[idx].id ??
                                                0,
                                            category: widget.category,
                                            departureTime: widget.departureTime,
                                            arrivalTime:
                                                mainStops[idx].arrivalPlanned,
                                          ),
                                        );
                                      },
                                      stop: mainStops[idx],
                                      tripId: trip.tripId,
                                    );
                                  } else if (hasContinuation &&
                                      idx == mainCount) {
                                    return ContinueHint(
                                      continuation: continuation,
                                    );
                                  } else {
                                    final continueIdx = idx - mainCount - 1;
                                    return StopoverRow(
                                      callback: (id, name, arrival) {
                                        _navigateToCheckIn(
                                          primary: .new(
                                            departureId: widget.startStopId,
                                            tripId: widget.tripId,
                                            lineName: widget.lineName,
                                            destination:
                                                mainStops.last.station?.name ??
                                                mainStops.last.name ??
                                                "???",
                                            destinationId:
                                                mainStops.last.station?.id ??
                                                mainStops.last.id ??
                                                0,
                                            category: widget.category,
                                            departureTime: widget.departureTime,
                                            arrivalTime:
                                                mainStops.last.arrivalPlanned,
                                          ),
                                          continuation: .new(
                                            departureId:
                                                continuation
                                                    .stopovers
                                                    .first
                                                    .station
                                                    ?.id ??
                                                continuation
                                                    .stopovers
                                                    .first
                                                    .id ??
                                                0,
                                            tripId:
                                                trip.continuationTrip!.tripId,
                                            lineName:
                                                trip.continuationTrip!.lineName,
                                            destination: name,
                                            destinationId: id,
                                            category:
                                                trip.continuationTrip!.category,
                                            departureTime: continuation
                                                .stopovers
                                                .first
                                                .departurePlanned,
                                            arrivalTime: continuation
                                                .stopovers[continueIdx]
                                                .arrivalPlanned,
                                          ),
                                        );
                                      },
                                      stop:
                                          continuation!.stopovers[continueIdx],
                                      tripId: continuation.tripId,
                                    );
                                  }
                                },
                              );
                            }
                            return Center(
                              child: Column(
                                children: [
                                  Icon(Icons.error, size: 48),
                                  Text("data object was null"),
                                ],
                              ),
                            );
                          }
                          return const SizedBox(height: 0);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContinueHint extends StatelessWidget {
  const ContinueHint({super.key, required this.continuation});

  final TripResource continuation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.continuationTrip(
              continuation.lineName,
              continuation.destination.name,
            ),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(fontStyle: .italic),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

/*class StopoverList extends StatelessWidget {
  const StopoverList({super.key, required this.stops, required this.callback});
  final List<Stopover> stops;
  final Function(int, String, String) callback;
  @override
  Widget build(BuildContext context) {
    if (stops.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            const Icon(Icons.not_listed_location, size: 48),
            Center(child: Text(AppLocalizations.of(context)!.noStopoversFound)),
          ],
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: stops.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int i) {
          return StopoverRow(callback: callback, stop: stops[i]);
        },
      ),
    );
  }
}*/

class StopoverRow extends StatelessWidget {
  const StopoverRow({
    super.key,
    required this.callback,
    required this.stop,
    required this.tripId,
  });

  final Function(int, String, String) callback;
  final Stopover stop;
  final String tripId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback.call(
          stop.station?.id ?? stop.id ?? 0,
          stop.station?.name ?? stop.name ?? "???",
          stop.arrivalPlanned!,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 6),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                stop.station?.name ?? stop.name ?? "???",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DepartureTime(
                  planned: stop.arrivalPlanned!,
                  real: stop.arrivalReal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
