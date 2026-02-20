import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/departure_time.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/depart_types.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/components/platform.dart';
import 'package:traewelcross/pages/checkin/select_stop.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';
import "package:http/http.dart" as http;

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
  DateTime departureTime = DateTime.now();
  DepartTypes departType = DepartTypes.all;
  late Future<List<dynamic>> _departuresFuture;

  @override
  void initState() {
    super.initState();
    _departuresFuture = _fetchDepartures();
  }

  Future<List<dynamic>> _fetchDepartures() async {
    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request(
        "/station/${widget.stationId}/departures?when=${departureTime.toUtc().toIso8601String()}&travelType=$departType",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      if (!mounted) return Future.value([]);
      SharedFunctions.handleRequestTimeout(context, _fetchDepartures);
      return Future.value([]);
    } catch (e) {
      return Future.error(e);
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    } else {
      return Future.error(response.body);
    }
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
    setState(() {
      departureTime = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        newTime.hour,
        newTime.minute,
      );
      _departuresFuture = _fetchDepartures();
    });
  }

  void _onDepartTypeChanged(DepartTypes newDepartType) {
    setState(() {
      departType = newDepartType;
      _departuresFuture = _fetchDepartures();
    });
  }

  void _setHome() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/station/${widget.stationId}/home",
      HttpRequestTypes.PUT,
    );
    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.newHomeSuccessful(widget.stationName),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.genericErrorSnackBar +
                response.statusCode.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(widget.stationName),
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
                  retryTrigger: () => _departuresFuture = _fetchDepartures(),
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
  });

  final Future<List<dynamic>> departuresFuture;
  final String stationName;
  final Function() retryTrigger;
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
                Text(asyncSnapshot.error.toString()),
                OutlinedButton.icon(onPressed: () => retryTrigger.call(), label: Text(AppLocalizations.of(context)!.retry), icon: const Icon(Icons.refresh))
              ],
            ),
          );
        }
        if (asyncSnapshot.connectionState == ConnectionState.done) {
          if (asyncSnapshot.hasData) {
            if (asyncSnapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, size: 48),
                    Text(AppLocalizations.of(context)!.noRidesFound),
                  ],
                ),
              );
            }
            final departures = asyncSnapshot.data!;
            final showOtherStations = getIt<Config>().behavior.showAltDepartureStops;
            return ListView.builder(
              itemCount: departures.length,
              itemBuilder: (BuildContext context, int i) {
                final departure = departures[i];
                if(!showOtherStations && departure["stop"]["name"] != stationName){
                  return SizedBox(height: 0,);
                }
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SelectStop(
                          tripId: departure["tripId"],
                          destination: departure["destination"]["name"],
                          lineName: departure["line"]["name"],
                          startStopId: departure["stop"]["id"],
                          category: departure["line"]["product"],
                          departureTime: departure["plannedWhen"],
                        ),
                      ),
                    );
                  },
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
                                      category: departure["line"]["product"],
                                      lineName: departure["line"]["name"],
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
                                      departure["destination"]["name"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.startsAtDifferentStop(
                                          departure["stop"]["name"],
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
                              planned: departure["plannedWhen"],
                              real: departure["when"],
                            ),
                            if (departure["platform"].toString().isNotEmpty)
                              Platform(
                                platform: departure["platform"],
                                plannedPlatform: departure["plannedPlatform"],
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
