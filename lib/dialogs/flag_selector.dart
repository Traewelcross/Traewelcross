import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/color_circle.dart';
import 'package:traewelcross/components/pride_gradient.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/dialogs/flag_creator.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:uuid/v4.dart';

class PrideFlagSelector extends StatefulWidget {
  const PrideFlagSelector({super.key});

  @override
  State<PrideFlagSelector> createState() => _PrideFlagSelectorState();
}

class _PrideFlagSelectorState extends State<PrideFlagSelector> {
  final List<String> selected = getIt<Config>().appearance.selectedPrideFlags;
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
                value: selected.contains("rainbow"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("rainbow");
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
                value: selected.contains("trans"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("trans");
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
                value: selected.contains("inter"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("inter");
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
                value: selected.contains("lesbian"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("lesbian");
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
                value: selected.contains("gay"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("gay");
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
                value: selected.contains("nb"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("nb");
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
                value: selected.contains("pan"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("pan");
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
                value: selected.contains("bi"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("bi");
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
                value: selected.contains("asex"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("asex");
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
                value: selected.contains("arom"),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selected.add("arom");
                    } else {
                      selected.remove("arom");
                    }
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.add, size: 32),
              title: Text(localize.customFlag),
              onTap: () async {
                final colorList = await showDialog<List<Color>>(
                  context: context,
                  builder: (ctx) => FlagCreator(),
                );
                if (colorList == null || colorList.isEmpty) return;
                if (!mounted) return;
                getIt<Config>().appearance.customPrideFlags[UuidV4()
                        .generate()] =
                    colorList;
                setState(() {});
              },
            ),
            for (var (idx, flag)
                in getIt<Config>().appearance.customPrideFlags.keys.indexed)
              ListTile(
                key: ValueKey(flag),
                leading: PrideGradient(
                  rotation: 90,
                  gradient: getIt<Config>().appearance.customPrideFlags[flag],
                  child: ColorCircle(color: Colors.black, width: 32),
                ),
                trailing: IconButton(
                  onPressed: () => setState(
                    () => getIt<Config>().appearance.customPrideFlags.remove(
                      flag,
                    ),
                  ),
                  icon: const Icon(Icons.delete),
                ),
                title: Text(localize.customFlagTitle(idx + 1)),
              ),
            Text(localize.customFlagNote, textAlign: .center),
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
