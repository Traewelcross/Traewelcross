import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/dialogs/cancelled_connection_dialog.dart';
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
import 'package:traewelcross/utils/volume_buttons.dart';

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
  TripResource? _loadedTrip;
  late String attribution = "";
  StreamSubscription<VolumeEvent>? _volumeSubscription;
  int _selectedIndex = 0;
  final ScrollController _listScrollController = .new();

  void _scrollToSelected() {
    if (!_listScrollController.hasClients) return;
    const double estimatedHeight = 50;
    _listScrollController.animateTo(
      _selectedIndex * estimatedHeight,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _trip = _fetchTrip();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _volumeSubscription = VolumeButtonService().stream.listen(_listener);
    });
  }

  @override
  void dispose() {
    _volumeSubscription?.cancel();
    _listScrollController.dispose();
    super.dispose();
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
      if (widget.startStopId == response.stopovers[i].station.id) {
        break;
      } else {
        response.stopovers.removeAt(i);
      }
    }
    if (response.stopovers.isNotEmpty) {
      response.stopovers.removeLast();
    }
    response.stopovers = response.stopovers.reversed.toList();
    if (!mounted) return response;
    setState(() {
      _loadedTrip = response;
      attribution = response.dataSource?.attribution ?? "";
    });
    return response;
  }

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

  int _getTotalItems(TripResource? trip) {
    if (trip == null) return 0;
    final mainCount = trip.stopovers.length;
    final hasContinuation =
        trip.continuationTrip != null && widget.editCallback == null;
    final continuationCount = hasContinuation
        ? trip.continuationTrip!.stopovers.length
        : 0;
    return mainCount + (hasContinuation ? 1 + continuationCount : 0);
  }

  Future<void> _handleStopSelect(int index) async {
    final trip = _loadedTrip;
    if (trip == null) return;
    final mainStops = trip.stopovers;
    final continuation = trip.continuationTrip;
    final hasContinuation = continuation != null && widget.editCallback == null;
    final mainCount = mainStops.length;

    Stopover stop;
    CheckInInfo primary;
    CheckInInfo? cont;

    if (index < mainCount) {
      stop = mainStops[index];
      primary = CheckInInfo(
        departureId: widget.startStopId,
        tripId: widget.tripId,
        lineName: widget.lineName,
        destination: stop.station.name,
        destinationId: stop.station.id,
        category: widget.category,
        departureTime: widget.departureTime,
        arrivalTime: stop.arrivalPlanned,
      );
    } else if (hasContinuation && index > mainCount) {
      final continueIdx = index - mainCount - 1;
      stop = continuation.stopovers[continueIdx];
      primary = CheckInInfo(
        departureId: widget.startStopId,
        tripId: widget.tripId,
        lineName: widget.lineName,
        destination: mainStops.last.station.name,
        destinationId: mainStops.last.station.id,
        category: widget.category,
        departureTime: widget.departureTime,
        arrivalTime: mainStops.last.arrivalPlanned,
      );
      cont = CheckInInfo(
        departureId: continuation.stopovers.first.station.id,
        tripId: trip.continuationTrip!.tripId,
        lineName: trip.continuationTrip!.lineName,
        destination: stop.station.name,
        destinationId: stop.station.id,
        category: trip.continuationTrip!.category,
        departureTime: continuation.stopovers.first.departurePlanned,
        arrivalTime: stop.arrivalPlanned,
      );
    } else {
      return;
    }

    _volumeSubscription?.cancel();
    try {
      if (stop.cancelled) {
        final ignore = await showDialog<bool>(
          context: context,
          builder: (ctx) => CancelledConnectionDialog(),
        );
        if (!context.mounted) return;
        if (ignore != true) return;
      }
      if (!mounted) return;
      _navigateToCheckIn(primary: primary, continuation: cont);
    } finally {
      if (mounted) {
        _volumeSubscription = VolumeButtonService().stream.listen(_listener);
      }
    }
  }

  void _listener(VolumeEvent e) {
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }

    final totalCount = _getTotalItems(_loadedTrip);
    if (totalCount == 0) return;

    if (e.action == .pressed) {
      setState(() {
        if (e.button == .up) {
          if (_selectedIndex > 0) {
            _selectedIndex--;
            _scrollToSelected();
          }
        } else if (e.button == .down) {
          if (_selectedIndex < totalCount - 1) {
            _selectedIndex++;
            _scrollToSelected();
          }
        }
      });
    } else if (e.action == .held) {
      if (_selectedIndex < totalCount) {
        _handleStopSelect(_selectedIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Move FutureBuilder up and apply trip routeColor
    return MainScaffold(
      floatingActionButton: getIt<Config>().behavior.showVolBtnIndicator
          ? FloatingActionButton(
              onPressed: null,
              child: VolumeButtonService().buildHoldProgressIndicator(),
            )
          : null,
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
                                    Text(snapshot.error!.toString()),
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
                              final isVolumeCtrl =
                                  getIt<Config>().behavior.volumeBtnCtrl;

                              return ListView.builder(
                                controller: _listScrollController,
                                itemCount: totalItems,
                                itemBuilder: (ctx, idx) {
                                  final bool isSelected =
                                      idx == _selectedIndex && isVolumeCtrl;
                                  if (idx < mainCount) {
                                    return StopoverRow(
                                      isSelected: isSelected,
                                      callback: (id, name, arrival) {
                                        _navigateToCheckIn(
                                          primary: .new(
                                            departureId: widget.startStopId,
                                            tripId: widget.tripId,
                                            lineName: widget.lineName,
                                            destination:
                                                mainStops[idx].station.name,
                                            destinationId:
                                                mainStops[idx].station.id,
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
                                      isSelected: isSelected,
                                      callback: (id, name, arrival) {
                                        _navigateToCheckIn(
                                          primary: .new(
                                            departureId: widget.startStopId,
                                            tripId: widget.tripId,
                                            lineName: widget.lineName,
                                            destination:
                                                mainStops.last.station.name,
                                            destinationId:
                                                mainStops.last.station.id,
                                            category: widget.category,
                                            departureTime: widget.departureTime,
                                            arrivalTime:
                                                mainStops.last.arrivalPlanned,
                                          ),
                                          continuation: .new(
                                            departureId: continuation
                                                .stopovers
                                                .first
                                                .station
                                                .id,
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
                    Text(
                      attribution,
                      textAlign: .center,
                      style: .new(fontStyle: .italic),
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
            textAlign: .center,
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
    this.isSelected = false,
  });

  final Function(int, String, String) callback;
  final Stopover stop;
  final String tripId;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (stop.cancelled) {
          final ignore = await showDialog<bool>(
            context: context,
            builder: (ctx) => CancelledConnectionDialog(),
          );
          if (!context.mounted) return;
          if (ignore == null) return;
          if (!ignore) {
            return;
          }
        }
        callback.call(stop.station.id, stop.station.name, stop.arrivalPlanned!);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.9)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 6,
                color: stop.cancelled ? Colors.red : null,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  stop.station.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: stop.cancelled ? Colors.red : null,
                    decorationColor: stop.cancelled ? Colors.red : null,
                    decoration: stop.cancelled ? .lineThrough : null,
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
                    cancelled: stop.cancelled,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
