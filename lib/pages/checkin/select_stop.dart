import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/pages/checkin/checkin.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/departure_time.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
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
  late Future<List<dynamic>> _stops;

  @override
  void initState() {
    super.initState();
    _stops = _fetchStops();
  }

  Future<List<dynamic>> _fetchStops() async {
    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request(
        "/trains/trip?hafasTripId=${Uri.encodeComponent(widget.tripId)}&lineName=${Uri.encodeComponent(widget.lineName)}&start=${Uri.encodeComponent(widget.startStopId.toString())}",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      if (!mounted) return [];
      SharedFunctions.handleRequestTimeout(context, _fetchStops);
      return [];
    }

    if (response.statusCode == 200) {
      List<dynamic> stopovers = jsonDecode(response.body)["data"]["stopovers"];
      stopovers = stopovers.reversed.toList();
      // Workaround https://github.com/Traewelling/traewelling/issues/3791
      for (var i = stopovers.length - 1; i >= 0; i--) {
        if (widget.startStopId == stopovers[i]["id"]) {
          break;
        } else {
          stopovers.removeAt(i);
        }
      }
      stopovers.removeLast();
      return stopovers.reversed.toList();
    }
    return Future.error(response.body);
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
                    StopoverList(stopsFuture: _stops, callback: _checkIn),
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
  final Future<List<dynamic>> stopsFuture;
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
            final stopovers = asyncSnapshot.data!;
            if (stopovers.isEmpty) {
              return const Center(child: Text("No stops found."));
            }
            return ListView.builder(
              itemCount: stopovers.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    callback.call(
                      stopovers[i]["id"],
                      stopovers[i]["name"],
                      stopovers[i]["arrivalPlanned"],
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
                            stopovers[i]["name"],
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
                              planned: stopovers[i]["arrivalPlanned"],
                              real: stopovers[i]["arrivalReal"],
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
          return const Center(child: LinearProgressIndicator());
        },
      ),
    );
  }
}
