import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/dialogs/manual_trip_add_stopover_dialog.dart';
import 'package:traewelcross/enums/depart_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/checkin/select_stop.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';

class TripCreation extends StatefulWidget {
  const TripCreation({super.key});

  @override
  State<TripCreation> createState() => _TripCreationState();
}

class _TripCreationState extends State<TripCreation> {
  Future<Iterable<Operator>> _searchOperators(String query) async {
    List<Operator> response = await getIt<ApiService>().operator
        .autocompleteOperator(query);
    return response;
  }

  Future<void> _addStopover() async {
    final stop = await showDialog<StopoverDraft>(
      context: context,
      builder: (ctx) =>
          const ManualTripAddStopoverDialog(edit: false, isDestination: false),
    );
    if (stop?.stationId == -1 || stop == null) {
      return;
    }
    setState(() {
      stopovers.add(stop);
    });
  }

  Future<void> _editStopover(int initId) async {
    final idx = stopovers.indexWhere((s) => s.stationId == initId);
    final stop = await showDialog<StopoverDraft>(
      context: context,
      builder: (ctx) => ManualTripAddStopoverDialog(
        edit: true,
        editStation: stopovers.firstWhere((s) => s.stationId == initId),
        isDestination: false,
      ),
    );
    if (stop == null) return;
    setState(() {
      if (stop.stationId == -2) {
        stopovers.removeAt(idx);
        return;
      }
      stopovers[idx] = stop;
    });
  }

  Future<void> _editOriginStop() async {
    final stop = await showDialog<StopoverDraft>(
      context: context,
      builder: (ctx) => ManualTripAddStopoverDialog(
        edit: originStop.stationId != -1,
        editStation: originStop,
        isDestination: false,
      ),
    );
    if (stop == null || stop.stationId == -2) return;
    setState(() {
      originStop = stop;
    });
  }

  Future<void> _editDestinationStop() async {
    final stop = await showDialog<StopoverDraft>(
      context: context,
      builder: (ctx) => ManualTripAddStopoverDialog(
        edit: destinationStop.stationId != -1,
        editStation: destinationStop,
        isDestination: true,
      ),
    );
    if (stop == null || stop.stationId == -2) return;
    setState(() {
      destinationStop = stop;
    });
  }

  TripDraft tD = .new(category: .express);
  late Iterable<Operator> _lastOptions = <Operator>[];
  List<StopoverDraft> stopovers = [];
  StopoverDraft originStop = .new(stationId: -1, name: "", departure: "");
  StopoverDraft destinationStop = .new(stationId: -1, name: "", departure: "");
  Future<void> _createTrip() async {
    if (stopovers.isNotEmpty) {
      stopovers.sort((a, b) => a.compareTo(b));
    }
    tD.originId = originStop.stationId;
    tD.destinationId = destinationStop.stationId;
    tD.destinationArrivalPlanned = destinationStop.arrival;
    tD.originDeparturePlanned = originStop.departure;
    tD.lineName = lineName.text;
    tD.stopovers = stopovers;
    if (int.tryParse(journeyNumber.text) != null) {
      tD.journeyNumber = int.parse(journeyNumber.text);
    }
    final response = await getIt<ApiService>().trip.createTrip(tD);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => SelectStop(
          lineName: response.lineName,
          tripId: response.tripId,
          destination: response.destination.name,
          startStopId: originStop.stationId,
          category: response.category,
          departureTime: originStop.departure,
        ),
      ),
    );
  }

  TextEditingController lineName = TextEditingController();
  TextEditingController journeyNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(localize.manualTripNewTrip),
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            const SizedBox(height: 8),
            InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: localize.trainDetails,
              ),
              child: Column(
                spacing: 6,
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  DropdownMenu(
                    selectOnly: true,
                    initialSelection: tD.category,
                    onSelected: (v) => setState(() => tD.category = v),
                    leadingIcon: Row(
                      mainAxisSize: .min,
                      children: [
                        const SizedBox(width: 8),
                        RideIconTag(
                          iconInfo: RideIconTagInfo(
                            category: tD.category?.value,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                    enableSearch: false,
                    dropdownMenuEntries: DepartTypes.values
                        .where((v) => v.value != "")
                        .map<DropdownMenuEntry>((v) {
                          return DropdownMenuEntry(
                            value: v,
                            label: switch (v.value) {
                              final cat when cat == "express" =>
                                localize.national,
                              "regional" => localize.regional,
                              "tram" => localize.tram,
                              "suburban" => localize.suburban,
                              "bus" => localize.bus,
                              "ferry" => localize.ferry,
                              "subway" => localize.subway,
                              "plane" => localize.plane,
                              "freightTrain" => localize.freightTrain,
                              "taxi" => localize.taxi,
                              _ => localize.unknown,
                            },
                            leadingIcon: RideIconTag(
                              iconInfo: RideIconTagInfo(
                                category: v.value,
                                width: 24,
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                  TextField(
                    maxLength: 8,
                    maxLengthEnforcement: .enforced,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: localize.lineNumber,
                      counterText: "",
                    ),
                    controller: lineName,
                  ),
                  TextField(
                    keyboardType: .number,
                    maxLength: 10,
                    maxLengthEnforcement: .enforced,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: localize.journeyNumber,
                      counterText: "",
                    ),
                    controller: journeyNumber,
                  ),
                  const Divider(),
                  Autocomplete<Operator>(
                    optionsBuilder: (textEditValue) {
                      final query = textEditValue.text;
                      if (query.isEmpty) {
                        _lastOptions = [];
                        return const Iterable<Operator>.empty();
                      }
                      final completer = Completer<Iterable<Operator>>();
                      EasyDebounce.debounce(
                        'se_op',
                        const Duration(milliseconds: 400),
                        () async {
                          try {
                            final options = await _searchOperators(query);
                            _lastOptions = options;

                            if (!completer.isCompleted) {
                              completer.complete(options);
                            }
                          } catch (error) {
                            if (!completer.isCompleted) {
                              completer.complete(_lastOptions);
                            }
                          }
                        },
                      );
                      return completer.future;
                    },
                    displayStringForOption: (o) => o.name,
                    onSelected: (o) => tD.operatorId = o.uuid,
                    fieldViewBuilder: (ctx, textEditC, focusN, onFieldSubmit) {
                      return TextFormField(
                        controller: textEditC,
                        focusNode: focusN,
                        onFieldSubmitted: (_) => onFieldSubmit(),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: localize.operator,
                          counterText: "",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: localize.routeDetails,
                counterText: "",
              ),
              child: Column(
                spacing: 8,
                children: [
                  StopoverField(
                    onPressed: _editOriginStop,
                    s: originStop,
                    labelText: localize.manualTripOriginStop,
                  ),
                  Divider(),
                  Column(
                    spacing: 8,
                    children:
                        stopovers
                            .map<Widget>(
                              (s) => StopoverField(
                                onPressed: () => _editStopover(s.stationId),
                                s: s,
                              ),
                            )
                            .toList()
                          ..add(
                            TextButton.icon(
                              onPressed: () => _addStopover(),
                              label: Text(localize.addStopover),
                              icon: const Icon(Icons.add),
                            ),
                          ),
                  ),
                  Divider(),
                  StopoverField(
                    onPressed: _editDestinationStop,
                    s: destinationStop,
                    labelText: localize.manualTripDestinationStop,
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _createTrip(),
              label: Text(localize.manualTripCreateTrip),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class StopoverField extends StatelessWidget {
  const StopoverField({
    super.key,
    required this.onPressed,
    required this.s,
    this.labelText,
  });

  final Function() onPressed;
  final StopoverDraft s;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onPressed,
      readOnly: true,
      key: ValueKey('${s.stationId}${s.departure}'),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        counterText: "",
        suffixIcon: Row(
          mainAxisSize: .min,
          children: [
            const SizedBox(height: 24, child: VerticalDivider()),
            IconButton(onPressed: onPressed, icon: const Icon(Icons.edit)),
            const SizedBox(width: 8),
          ],
        ),
      ),
      initialValue: s.name,
    );
  }
}
