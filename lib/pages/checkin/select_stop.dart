import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
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
import "package:http/http.dart" as http;

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
      response = await apiService.train.getTrip(tripId: widget.tripId, lineName: widget.lineName, startStopId: widget.startStopId);
    } on TimeoutException {
      if (!mounted) return Future.error(TimeoutException(null));
      SharedFunctions.handleRequestTimeout(context, _fetchTrip);
      return Future.error(TimeoutException(null));
    }
    return response;
  }

  void _checkIn(int id, String name, String arrivalTime) {
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
            tripId: widget.tripId,
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
                    StopoverList(stopsFuture: _trip, callback: _checkIn),
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

class StopoverList extends StatelessWidget {
  const StopoverList({
    super.key,
    required this.stopsFuture,
    required this.callback,
  });
  final Future<TripResource> stopsFuture;
  final Function(int, String, String) callback;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: stopsFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error),
                  Text(asyncSnapshot.error.toString()),
                ],
              ),
            );
          }
          if (asyncSnapshot.hasData) {
            final trip = asyncSnapshot.data!;
            if (trip.stopovers.isEmpty) {
              return const Center(child: Text("No stops found."));
            }
            return ListView.builder(
              itemCount: trip.stopovers.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    callback.call(
                      trip.stopovers[i].id,
                      trip.stopovers[i].name,
                      trip.stopovers[i].arrivalPlanned!,
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
                            trip.stopovers[i].name,
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
                              planned: trip.stopovers[i].arrivalPlanned!,
                              real: trip.stopovers[i].arrivalReal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox(height: 0);
        },
      ),
    );
  }
}
