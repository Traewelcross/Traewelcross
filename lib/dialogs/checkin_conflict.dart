import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class CheckinConflict extends StatelessWidget {
  const CheckinConflict({super.key, required this.forceCallback, this.lineName, this.statusID});
  final Function forceCallback;
  final String? lineName;
  final String? statusID;
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Symbols.swords),
      iconColor: Colors.amber,
      title: Text(localize.checkinConflictTitle),
      content: Text(localize.checkinConflictBody(lineName ?? localize.unknown, statusID ?? localize.unknown), textAlign: .center,),
      actions: [
        OutlinedButton.icon(onPressed: () {forceCallback.call(); Navigator.pop(context);}, label: Text(localize.yes), icon: const Icon(Icons.check)),
        FilledButton.icon(onPressed: (){Navigator.pop(context);}, label: Text(localize.no), icon: const Icon(Icons.close)),
      ],
    );
  }
}