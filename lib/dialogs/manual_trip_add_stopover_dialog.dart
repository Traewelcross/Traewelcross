import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/time_override_field.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class ManualTripAddStopoverDialog extends StatefulWidget {
  const ManualTripAddStopoverDialog({
    super.key,
    required this.edit,
    this.editStation,
    required this.isDestination
  });
  final bool edit;
  final bool isDestination;
  final StopoverDraft? editStation;

  @override
  State<ManualTripAddStopoverDialog> createState() =>
      _ManualTripAddStopoverDialogState();
}

class _ManualTripAddStopoverDialogState
    extends State<ManualTripAddStopoverDialog> {
  late StopoverDraft selectedStation;
  @override
  void initState() {
    super.initState();
    selectedStation = widget.editStation == null
        ? .new(stationId: -1, name: "", departure: "")
        : StopoverDraft(
            stationId: widget.editStation!.stationId,
            name: widget.editStation!.name,
            departure: widget.editStation!.departure,
            arrival: widget.editStation!.arrival,
          );
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    localize.addStopover,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            StationAutocomplete(selectedCallback: (s) {selectedStation.name = s.name; selectedStation.stationId = s.id;}, label: localize.searchStopover, initSelection: widget.editStation?.name,),
            Divider(),
            TimeOverrideField(
              initialDate: DateTime.tryParse(widget.editStation?.arrival ?? ""),
              onDateChanged: (d) =>
                  setState(()=>selectedStation.arrival = d?.toIso8601String()),
              watermark: localize.manualTripArrival,
              showDelete: widget.isDestination == true ? false : true,
            ),
            TimeOverrideField(
              initialDate: DateTime.tryParse(
                widget.editStation?.departure ?? "",
              ),
              onDateChanged: (d) => setState(
                () => selectedStation.departure =
                    d?.toIso8601String() ?? DateTime.now().toIso8601String(),
              ),
              watermark: localize.manualTripDeparture,
              showDelete: widget.isDestination == true ? true : false,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: .end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localize.cancel),
                ),
                if (widget.edit)
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                      StopoverDraft(stationId: -2, name: "", departure: ""),
                    ),
                    child: Text(localize.removeStopover),
                  ),
                if (!widget.edit)
                  FilledButton(
                    onPressed: (selectedStation.departure.isNotEmpty && !widget.isDestination) || (selectedStation.arrival?.isNotEmpty == true && widget.isDestination)
                        ? () => Navigator.pop(context, selectedStation)
                        : null,
                    child: Text(localize.addStopover),
                  ),
                if (widget.edit)
                  FilledButton(
                    onPressed: () => Navigator.pop(context, selectedStation),
                    child: Text(localize.editStopover),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StationAutocomplete extends StatelessWidget {
  const StationAutocomplete({super.key, required this.selectedCallback, this.initSelection, required this.label});
  final Function(Station selectedStation) selectedCallback;
  final String? initSelection;
  final String label;
  Future<Iterable<Station>> searchStations(String query) async {
    return await getIt<ApiService>().station.autocomplete(query: query);
  }

  @override
  Widget build(BuildContext context) {
  late Iterable<Station> lastOptions = <Station>[];
    return Autocomplete<Station>(
      optionsBuilder: (textEditValue) {
        final query = textEditValue.text;
        if (query.isEmpty) {
          lastOptions = [];
          return const Iterable<Station>.empty();
        }
        final completer = Completer<Iterable<Station>>();
        EasyDebounce.debounce(
          'se_op',
          const Duration(milliseconds: 400),
          () async {
            try {
              final options = await searchStations(query);
              lastOptions = options;

              if (!completer.isCompleted) {
                completer.complete(options);
              }
            } catch (error) {
              if (!completer.isCompleted) {
                completer.complete(lastOptions);
              }
            }
          },
        );
        return completer.future;
      },
      displayStringForOption: (o) => o.name,
      onSelected: (o) => selectedCallback(o),
      initialValue: .new(text: initSelection ?? ""),
      fieldViewBuilder: (ctx, textEditC, focusN, onFieldSubmit) {
        return TextFormField(
          controller: textEditC,
          focusNode: focusN,
          onFieldSubmitted: (_) => onFieldSubmit(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            counterText: "",
          ),
        );
      },
    );
  }
}
