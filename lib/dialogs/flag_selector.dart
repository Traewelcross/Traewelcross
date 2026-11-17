import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/color_circle.dart';
import 'package:traewelcross/components/pride_gradient.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class PrideFlagSelector extends StatefulWidget {
  const PrideFlagSelector({super.key});

  @override
  State<PrideFlagSelector> createState() => _PrideFlagSelectorState();
}

class _PrideFlagSelectorState extends State<PrideFlagSelector> {
  final Map<String, List<Color>?> selected =
      getIt<Config>().appearance.selectedPrideFlags ?? {};
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.looks),
      title: Text(localize.customizePride),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          children: [
            Text(localize.customizePrideDialogSubtitle, textAlign: .center),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "rainbow",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.rainbowFlag),
              trailing: Checkbox(
                value: selected.containsKey("rainbow"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["rainbow"] = null;
                    } else {
                      selected.remove("rainbow");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "trans",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.transFlag),
              trailing: Checkbox(
                value: selected.containsKey("trans"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["trans"] = null;
                    } else {
                      selected.remove("trans");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "inter",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.interFlag),
              trailing: Checkbox(
                value: selected.containsKey("inter"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["inter"] = null;
                    } else {
                      selected.remove("inter");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "lesbian",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.lesbianFlag),
              trailing: Checkbox(
                value: selected.containsKey("lesbian"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["lesbian"] = null;
                    } else {
                      selected.remove("lesbian");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "gay",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.gayFlag),
              trailing: Checkbox(
                value: selected.containsKey("gay"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["gay"] = null;
                    } else {
                      selected.remove("gay");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "nb",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.nbFlag),
              trailing: Checkbox(
                value: selected.containsKey("nb"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["nb"] = null;
                    } else {
                      selected.remove("nb");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "pan",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.panFlag),
              trailing: Checkbox(
                value: selected.containsKey("pan"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["pan"] = null;
                    } else {
                      selected.remove("pan");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "bi",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.biFlag),
              trailing: Checkbox(
                value: selected.containsKey("bi"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["bi"] = null;
                    } else {
                      selected.remove("bi");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "asex",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.asexFlag),
              trailing: Checkbox(
                value: selected.containsKey("asex"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["asex"] = null;
                    } else {
                      selected.remove("asex");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const PrideGradient(
                rotation: 90,
                name: "arom",
                child: ColorCircle(color: Colors.black, width: 32),
              ),
              title: Text(localize.aromFlag),
              trailing: Checkbox(
                value: selected.containsKey("arom"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected["arom"] = null;
                    } else {
                      selected.remove("arom");
                    }
                  });
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add, size: 32),
              title: Text("Eigene Flagge hinzufügen"),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.icon(
          onPressed: () {
            getIt<Config>().appearance.selectedPrideFlags = selected;
            Navigator.pop(context);
          },
          label: Text(localize.save),
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }
}
