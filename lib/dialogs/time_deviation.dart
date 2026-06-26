import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class TimeDeviationDialog extends StatefulWidget {
  const TimeDeviationDialog({super.key});

  @override
  State<TimeDeviationDialog> createState() => _TimeDeviationDialogState();
}

class _TimeDeviationDialogState extends State<TimeDeviationDialog> {
  final textEdit = TextEditingController();
  final now = DateTime.now();
  String mode = "subtract";
  @override
  void initState() {
    super.initState();
    if(!getIt<Config>().behavior.systemTimeDeviation.isNegative){
      mode = "add";
    }
    textEdit.text = getIt<Config>().behavior.systemTimeDeviation.abs().toString();
    textEdit.addListener(() {
      print(mode);
      if(textEdit.text.isEmpty){
        getIt<Config>().behavior.systemTimeDeviation = 0;
        setState(() {});
        return;
      }
      if(mode == "add"){
        getIt<Config>().behavior.systemTimeDeviation = int.parse(textEdit.text);
      } else {
        getIt<Config>().behavior.systemTimeDeviation = (int.parse(textEdit.text) / -1).toInt();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localize.systemTimeDeviationPreferenceTitle),
      content: Column(
        spacing: 8,
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisSize: .max,
            spacing: 8,
            children: [
              Flexible(
                child: TextField(
                  keyboardType: .number,
                  controller: textEdit,
                  inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], 
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffix: Text(localize.abrvMinute),
                    prefix: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,8,0),
                      child: DropdownButton(
                        isDense: true,
                        value: mode,
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem(value: "subtract", child: Text("-")),
                          DropdownMenuItem(value: "add", child: Text("+")),
                        ],
                        onChanged: (value) =>
                            setState(() => mode = value ?? mode),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            localize.systemTimeDeviationExample(
              DateFormat.Hm(
                Localizations.localeOf(context).languageCode,
              ).format(now),
              DateFormat.Hm(
                Localizations.localeOf(context).languageCode,
              ).format(
                now.add(
                  Duration(
                    minutes: getIt<Config>().behavior.systemTimeDeviation,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: FilledButton.icon(onPressed: () => Navigator.pop(context), label: Text(localize.done), icon: const Icon(Icons.check_circle))),
            ],
          )
        ],
      ),
    );
  }
}
