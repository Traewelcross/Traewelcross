import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/enums/depart_types.dart';
import 'package:traewelcross/enums/trip_type.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat.dart';
import 'package:traewelcross/utils/api_providers/statistics_api_provider.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_info.dart';
import 'package:traewelcross/utils/shared.dart';

class MapStatForUser extends StatefulWidget {
  const MapStatForUser({super.key});

  @override
  State<MapStatForUser> createState() => _MapStatForUserState();
}

class _MapStatForUserState extends State<MapStatForUser> {
  DateTimeRange statRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 7)),
    end: DateTime.now(),
  );
  late Future<List<RideInfo>> rides;
  MapFilters filters = .new(travelTypes: {
    .bus, .national, .nationalExpress, .regional, .regionalExp, .subUrban, .subway, .tram, .ferry,
  }, travelPurpose: {
    .business, .commute, .private
  });
  @override
  void initState() {
    super.initState();
    rides = _getRidesForUser();
  }

  Future<List<RideInfo>> _getRidesForUser() {
    final alt = false;
    rides = getIt<ApiService>().statistics.getPolylines(
      range: statRange,
      alternative: alt,
      filter: filters,
    );
    return rides;
  }

  void _modifyFilterTypes(DepartTypes type, bool selected) {
    setState(() {
      if (selected) {
        filters.travelTypes.add(type);
      } else {
        filters.travelTypes.remove(type);
      }
    });
  }

  void _modifyFilterPurpose(TripType type, bool selected) {
    setState(() {
      if (selected) {
        filters.travelPurpose.add(type);
      } else {
        filters.travelPurpose.remove(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return FutureBuilder<List<RideInfo>>(
      future: rides,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return SingleChildScrollView(
            child: Text(asyncSnapshot.error!.toString()),
          );
        }
        if (asyncSnapshot.connectionState == .waiting) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                CircularProgressIndicator(),
                Text(localize.waitForStatsMsg, textAlign: .center),
              ],
            ),
          );
        }
        if (asyncSnapshot.connectionState == .done) {
          return Column(
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final rangeSelect = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 365*5)),
                    lastDate: DateTime.now(),
                    initialDateRange: DateTimeRange(
                      start: DateTime.now().subtract(Duration(days: 28)),
                      end: DateTime.now(),
                    ),
                    currentDate: DateTime.now(),
                  );
                  if (rangeSelect == null) {
                    return;
                  }
                  setState(() {
                    statRange = rangeSelect;
                    rides = _getRidesForUser();
                  });
                },
                label: Text(
                  localize.dateSpan(
                    DateFormat.yMMMEd(
                      Localizations.localeOf(context).languageCode,
                    ).format(statRange.start),
                    DateFormat.yMMMEd(
                      Localizations.localeOf(context).languageCode,
                    ).format(statRange.end),
                  ),
                ),
                icon: const Icon(Icons.calendar_month),
              ),
              SizedBox(height: 8),
              Expanded(
                child: MapStat(
                  rides: asyncSnapshot.data!,
                  footer: Card(
                          clipBehavior: .hardEdge,
                          child: ExpansionTile(
                            shape: Border.all(color: Colors.transparent),
                            clipBehavior: Clip.hardEdge,
                            expandedCrossAxisAlignment: .start,
                            title: Row(
                              spacing: 4,
                              children: [
                                const Icon(Icons.filter_alt),
                                Text(localize.filter),
                              ],
                            ),
                            childrenPadding: .all(8),
                            children: [
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    localize.filterTravelTypes,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      TravelTypeFilterChip(
                                        text:
                                            localize.filterTravelTypesHighSpeed,
                                        type: .nationalExpress,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.nationalExpress,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesIC,
                                        type: .national,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.national,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesIR,
                                        type: .regionalExp,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.regionalExp,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text:
                                            localize.filterTravelTypesRegional,
                                        type: .regional,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.regional,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text:
                                            localize.filterTravelTypesSuburban,
                                        type: .subUrban,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.subUrban,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesSubway,
                                        type: .subway,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.subway,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesTram,
                                        type: .tram,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.tram,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesBus,
                                        type: .bus,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.bus,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesFerry,
                                        type: .ferry,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.ferry,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesPlane,
                                        type: .plane,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.plane,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize.filterTravelTypesTaxi,
                                        type: .taxi,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.taxi,
                                        ),
                                      ),
                                      TravelTypeFilterChip(
                                        text: localize
                                            .filterTravelTypesFreightTrain,
                                        type: .freightTrain,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterTypes(t, s),
                                        selected: filters.travelTypes.contains(
                                          DepartTypes.freightTrain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    localize.filterTravelPurpose,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      TravelPurposeFilterChip(
                                        text: localize.private,
                                        type: .private,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterPurpose(t, s),
                                        selected: filters.travelPurpose
                                            .contains(TripType.private),
                                      ),
                                      TravelPurposeFilterChip(
                                        text: localize.commuteTrip,
                                        type: .commute,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterPurpose(t, s),
                                        selected: filters.travelPurpose
                                            .contains(TripType.commute),
                                      ),
                                      TravelPurposeFilterChip(
                                        text: localize.businessTrip,
                                        type: .business,
                                        modifyFunction: (t, s) =>
                                            _modifyFilterPurpose(t, s),
                                        selected: filters.travelPurpose
                                            .contains(TripType.business),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              ListTile(
                                onTap: () => setState(
                                  () => filters.includeApprox =
                                      !filters.includeApprox,
                                ),
                                leading: Switch(
                                  value: filters.includeApprox,
                                  onChanged: (s) =>
                                      setState(() => filters.includeApprox = s),
                                ),
                                title: Text(localize.filterApproxRoutes),
                              ),
                              Divider(),
                              FilledButton.icon(
                                onPressed: () {
                                  setState(() {
                                    rides = _getRidesForUser();
                                  });
                                },
                                label: Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Text(
                                      localize.filterApply,
                                      textAlign: .center,
                                    ),
                                  ],
                                ),
                                icon: const Icon(Icons.check),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}

class TravelTypeFilterChip extends StatelessWidget {
  const TravelTypeFilterChip({
    super.key,
    required this.text,
    required this.type,
    required this.modifyFunction,
    required this.selected,
  });

  final String text;
  final DepartTypes type;
  final Function(DepartTypes type, bool selected) modifyFunction;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RideIconTag(iconInfo: .new(category: type.value, width: 24)),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
      selected: selected,
      onSelected: (s) => modifyFunction(type, s),
    );
  }
}

class TravelPurposeFilterChip extends StatelessWidget {
  const TravelPurposeFilterChip({
    super.key,
    required this.text,
    required this.type,
    required this.modifyFunction,
    required this.selected,
  });

  final String text;
  final TripType type;
  final Function(TripType type, bool selected) modifyFunction;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          switch (type) {
            .private => const Icon(Icons.person),
            .commute => const Icon(Icons.commute),
            .business => const Icon(Icons.work),
          },
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
      selected: selected,
      onSelected: (s) => modifyFunction(type, s),
    );
  }
}
