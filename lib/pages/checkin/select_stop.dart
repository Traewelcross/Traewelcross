import 'dart:async';

import 'package:flutter/material.dart';
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
    response.stopovers = response.stopovers.reversed.toList();
    // Workaround https://github.com/Traewelling/traewelling/issues/3791
    for (var i = response.stopovers.length - 1; i >= 0; i--) {
      if (widget.startStopId == response.stopovers[i].id) {
        break;
      } else {
        response.stopovers.removeAt(i);
      }
    }
    response.stopovers.removeLast();
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

                              final hasContinuation = continuation != null && widget.editCallback == null;
                              final mainCount = mainStops.length;
                              final continuationCount = hasContinuation
                                  ? continuation.stopovers.length
                                  : 0;
                              final totalItems =
                                  mainCount +
                                  (hasContinuation ? 1 + continuationCount : 0);
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
                                            destination: mainStops[idx].name,
                                            destinationId: mainStops[idx].id,
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
                                            destination: mainStops.last.name,
                                            destinationId: mainStops.last.id,
                                            category: widget.category,
                                            departureTime: widget.departureTime,
                                            arrivalTime:
                                                mainStops.last.arrivalPlanned,
                                          ),
                                          continuation: .new(
                                            departureId:
                                                continuation.stopovers.first.id,
                                            tripId:
                                                trip.continuationTrip!.tripId,
                                            lineName:
                                                trip.continuationTrip!.lineName,
                                            destination: name,
                                            destinationId: id,
                                            category:
                                                trip.continuationTrip!.category,
                                            departureTime: continuation
                                                .stopovers.first
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
        callback.call(stop.id, stop.name, stop.arrivalPlanned!);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 6),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                stop.name,
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
