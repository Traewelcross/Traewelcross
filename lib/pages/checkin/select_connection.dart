import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/departure_time.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/dialogs/cancelled_connection_dialog.dart';
import 'package:traewelcross/dialogs/manual_trip_info.dart';
import 'package:traewelcross/enums/depart_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/components/platform.dart';
import 'package:traewelcross/pages/checkin/manual_trips/trip_creation.dart';
import 'package:traewelcross/pages/checkin/select_stop.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:traewelcross/utils/volume_buttons.dart';

class SelectConnection extends StatefulWidget {
  const SelectConnection({
    super.key,
    required this.stationId,
    required this.stationName,
  });
  final int stationId;
  final String stationName;
  @override
  State<SelectConnection> createState() => _SelectConnectionState();
}

class _SelectConnectionState extends State<SelectConnection> {
  DateTime departureTime = DateTime.now().add(
    Duration(minutes: getIt<Config>().behavior.systemTimeDeviation),
  );
  DepartTypes departType = DepartTypes.all;
  late Future<List<Departure>> _departuresFuture;
  List<Departure>? _departures;
  StreamSubscription<VolumeEvent>? _volumeSubscription;
  int _selectedIndex = 0;
  final ScrollController _listScrollController = .new();

  void _scrollToSelected() {
    if (!_listScrollController.hasClients) return;
    const double estimatedHeight = 75;
    _listScrollController.animateTo(
      _selectedIndex * estimatedHeight,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void _listener(VolumeEvent e) {
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }

    final visibleDepartures = _getVisibleDepartures(_departures);
    final totalCount = (visibleDepartures?.length ?? 0) + 1;

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
      if (visibleDepartures == null) return;
      if (_selectedIndex < visibleDepartures.length) {
        _handleDepartureClick(visibleDepartures[_selectedIndex]);
      } else if (_selectedIndex == visibleDepartures.length) {
        _openManualTripCreation();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _volumeSubscription = VolumeButtonService().stream.listen(_listener);
    });
    _departuresFuture = _fetchDepartures();
  }

  @override
  void dispose() {
    _volumeSubscription?.cancel();
    _listScrollController.dispose();
    super.dispose();
  }

  List<Departure>? _getVisibleDepartures(List<Departure>? list) {
    if (list == null) return null;
    final showOtherStations = getIt<Config>().behavior.showAltDepartureStops;
    if (showOtherStations) return list;
    return list.where((d) => d.station.name == widget.stationName).toList();
  }

  void _resetSelection() {
    setState(() {
      _selectedIndex = 0;
      if (_listScrollController.hasClients) {
        _listScrollController.jumpTo(0);
      }
    });
  }

  Future<List<Departure>> _fetchDepartures() async {
    final apiService = getIt<ApiService>();
    List<Departure> response;
    try {
      response = await apiService.station.getDepartures(
        stationId: widget.stationId,
        when: departureTime,
        type: departType,
      );
      if (mounted) {
        setState(() {
          _departures = response;
        });
      }
    } on TimeoutException {
      if (!mounted) return Future.value([]);
      SharedFunctions.handleRequestTimeout(context, _fetchDepartures);
      return Future.value([]);
    } catch (e) {
      return Future.error(e);
    }
    return response;
  }

  void _updateTime() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now().add(Duration(days: 14)),
      initialDate: departureTime,
    );
    if (newDate == null) return;
    if (!mounted) return;
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime == null) {
      return;
    }
    if (!mounted) return;
    setState(() {
      departureTime = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        newTime.hour,
        newTime.minute,
      );
      _resetSelection();
      _departuresFuture = _fetchDepartures();
    });
  }

  void _onDepartTypeChanged(DepartTypes newDepartType) {
    setState(() {
      departType = newDepartType;
      _resetSelection();
      _departuresFuture = _fetchDepartures();
    });
  }

  void _setHome() {
    final apiService = getIt<ApiService>();
    apiService.user.setHome(widget.stationId, widget.stationName);
  }

  Future<void> _handleDepartureClick(Departure departure) async {
    _volumeSubscription?.cancel();
    try {
      if (departure.cancelled) {
        final ignore = await showDialog<bool>(
          context: context,
          builder: (ctx) => CancelledConnectionDialog(),
        );
        if (!context.mounted) return;
        if (ignore != true) return;
      }
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SelectStop(
            tripId: departure.tripId,
            destination: departure.direction,
            lineName: departure.line!.name!,
            startStopId: departure.station.id,
            category: departure.line!.product!,
            departureTime: departure.plannedWhen,
          ),
        ),
      );
    } finally {
      if (mounted) {
        _volumeSubscription = VolumeButtonService().stream.listen(_listener);
      }
    }
  }

  Future<void> _openManualTripCreation() async {
    _volumeSubscription?.cancel();
    try {
      if (getIt<Config>().dialog.manualTripInfo) {
        await showDialog(
          context: context,
          builder: (ctx) => ManualTripInfo(),
          barrierDismissible: false,
        );
      }
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => TripCreation()),
      );
    } finally {
      if (mounted) {
      _volumeSubscription = VolumeButtonService().stream.listen(_listener);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(widget.stationName),
      floatingActionButton: getIt<Config>().behavior.showVolBtnIndicator
          ? FloatingActionButton(
              onPressed: null,
              child: VolumeButtonService().buildHoldProgressIndicator(),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          localize.departuresFrom(widget.stationName),
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
                  const Divider(),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          _updateTime();
                        },
                        label: Text(
                          DateFormat.Hm(
                            Localizations.localeOf(context).languageCode,
                          ).format(departureTime.toLocal()),
                        ),
                        icon: const Icon(Icons.schedule),
                      ),
                      Spacer(),
                      IconButton.filledTonal(
                        onPressed: () {
                          _setHome();
                        },
                        icon: const Icon(Icons.home),
                      ),
                    ],
                  ),
                  const Divider(),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _DepartTypeChoiceChip(
                        label: localize.national,
                        iconCategory: "train",
                        value: DepartTypes.express,
                        groupValue: departType,
                        onChanged: _onDepartTypeChanged,
                      ),
                      _DepartTypeChoiceChip(
                        label: localize.regional,
                        iconCategory: "train",
                        value: DepartTypes.regional,
                        groupValue: departType,
                        onChanged: _onDepartTypeChanged,
                      ),
                      _DepartTypeChoiceChip(
                        label: localize.suburban,
                        iconCategory: "suburban",
                        value: DepartTypes.subUrban,
                        groupValue: departType,
                        onChanged: _onDepartTypeChanged,
                      ),
                      _DepartTypeChoiceChip(
                        label: localize.subway,
                        iconCategory: "subway",
                        value: DepartTypes.subway,
                        groupValue: departType,
                        onChanged: _onDepartTypeChanged,
                      ),
                      _DepartTypeChoiceChip(
                        label: localize.tram,
                        iconCategory: "tram",
                        value: DepartTypes.tram,
                        groupValue: departType,
                        onChanged: _onDepartTypeChanged,
                      ),
                      _DepartTypeChoiceChip(
                        label: localize.bus,
                        iconCategory: "bus",
                        value: DepartTypes.bus,
                        groupValue: departType,
                        onChanged: _onDepartTypeChanged,
                      ),
                      _DepartTypeChoiceChip(
                        label: localize.ferry,
                        iconCategory: "ferry",
                        value: DepartTypes.ferry,
                        groupValue: departType,
                        onChanged: _onDepartTypeChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: _DepartureList(
                  departuresFuture: _departuresFuture,
                  stationName: widget.stationName,
                  retryTrigger: () {
                    _resetSelection();
                    setState(() {
                      _departuresFuture = _fetchDepartures();
                    });
                  },
                  selectedIndex: _selectedIndex,
                  scrollController: _listScrollController,
                  onDepartureTap: _handleDepartureClick,
                  onManualTripTap: _openManualTripCreation,
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        departureTime = departureTime.subtract(
                          Duration(minutes: 15),
                        );
                        _resetSelection();
                        _departuresFuture = _fetchDepartures();
                      });
                    },
                    label: Text(localize.earlier),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        departureTime = departureTime.add(
                          Duration(minutes: 15),
                        );
                        _resetSelection();
                        _departuresFuture = _fetchDepartures();
                      });
                    },
                    label: Text(localize.later),
                    icon: const Icon(Icons.chevron_right),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DepartureList extends StatelessWidget {
  const _DepartureList({
    required this.departuresFuture,
    required this.stationName,
    required this.retryTrigger,
    required this.selectedIndex,
    required this.scrollController,
    required this.onDepartureTap,
    required this.onManualTripTap,
  });

  final Future<List<Departure>> departuresFuture;
  final String stationName;
  final VoidCallback retryTrigger;
  final ValueChanged<Departure> onDepartureTap;
  final VoidCallback onManualTripTap;
  final int selectedIndex;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: departuresFuture,
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
                Text(asyncSnapshot.error!.toString()),
                OutlinedButton.icon(
                  onPressed: retryTrigger,
                  label: Text(AppLocalizations.of(context)!.retry),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        }
        if (asyncSnapshot.connectionState == ConnectionState.done) {
          if (asyncSnapshot.hasData) {
            final showOtherStations =
                getIt<Config>().behavior.showAltDepartureStops;
            final departures = showOtherStations
                ? asyncSnapshot.data!
                : asyncSnapshot.data!
                      .where((d) => d.station.name == stationName)
                      .toList();

            if (departures.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, size: 48),
                    Text(
                      AppLocalizations.of(context)!.noRidesFound,
                      textAlign: .center,
                    ),
                  ],
                ),
              );
            }

            final isVolumeCtrl = getIt<Config>().behavior.volumeBtnCtrl;

            return ListView.builder(
              controller: scrollController,
              itemCount: departures.length + 1,
              itemBuilder: (BuildContext context, int i) {
                if (i >= departures.length) {
                  final bool isSelected = i == selectedIndex && isVolumeCtrl;
                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.manualTripCreationTile,
                      ),
                      leading: const Icon(Icons.add),
                      onTap: onManualTripTap,
                    ),
                  );
                }
                final departure = departures[i];
                final bool isSelected = i == selectedIndex && isVolumeCtrl;
                return InkWell(
                  onTap: () => onDepartureTap(departure),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.9)
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
                          Flexible(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RideIconTag(
                                      iconInfo: RideIconTagInfo(
                                        category: departure.line!.product,
                                        lineName: departure.line!.name,
                                        cancelled: departure.cancelled,
                                        width: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.arrow_forward),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        departure.direction,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: TextStyle(
                                          decoration: departure.cancelled
                                              ? .lineThrough
                                              : null,
                                          color: departure.cancelled
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.error
                                              : null,
                                          decorationColor: departure.cancelled
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.error
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (departure.station.name != stationName)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.startsAtDifferentStop(
                                            departure.station.name,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 1),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DepartureTime(
                                planned: departure.plannedWhen,
                                real: departure.when,
                                cancelled: departure.cancelled,
                              ),
                              if (departure.platform?.toString().isNotEmpty ==
                                  true)
                                Platform(
                                  platform: departure.platform!,
                                  plannedPlatform: departure.plannedPlatform!,
                                  cancelled: departure.cancelled,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _DepartTypeChoiceChip extends StatelessWidget {
  const _DepartTypeChoiceChip({
    required this.label,
    this.iconCategory,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final String? iconCategory;
  final DepartTypes value;
  final DepartTypes groupValue;
  final ValueSetter<DepartTypes> onChanged;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconCategory != null) ...[
            RideIconTag(
              iconInfo: RideIconTagInfo(category: iconCategory!, width: 24),
            ),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
      selected: value == groupValue,
      onSelected: (selected) {
        onChanged(selected ? value : DepartTypes.all);
      },
    );
  }
}
