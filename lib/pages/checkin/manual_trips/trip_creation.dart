import 'package:flutter/material.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/enums/depart_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class TripCreation extends StatefulWidget {
  const TripCreation({super.key});

  @override
  State<TripCreation> createState() => _TripCreationState();
}

class _TripCreationState extends State<TripCreation> {
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(localize.manualTripNewTrip),
      body: Column(
        children: [
          DropdownMenu(
            selectOnly: true,
            enableSearch: false,
            dropdownMenuEntries: DepartTypes.values
                .map<DropdownMenuEntry>(
                  (v) => DropdownMenuEntry(value: v.value, label: v.value),
                )
                .toList(),
          ),
          TextField(maxLength: 8, maxLengthEnforcement: .enforced,)
        ],
      ),
    );
  }
}
