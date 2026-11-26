import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class FlagCreator extends StatefulWidget {
  const FlagCreator({super.key});

  @override
  State<FlagCreator> createState() => _FlagCreatorState();
}

class _FlagCreatorState extends State<FlagCreator> {
  List<Color> colors = .empty(growable: true);
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return AlertDialog(
      icon: const Icon(Icons.color_lens),
      title: Text(localize.customFlag),
      content: SizedBox(
        width: double.maxFinite,
        child: ReorderableListView.builder(
          onReorderItem: (oldIndex, newIndex) {
            setState(() {
              final Color item = colors.removeAt(oldIndex);
              colors.insert(newIndex, item);
            });
          },
          itemCount: colors.length,
          itemBuilder: (ctx, idx) {
            Color c = colors[idx];
            return Container(
              key: ValueKey("${c.hashCode.toString()}+$idx"),
              color: colors[idx],
              child: ListTile(
                onTap: () async {
                  final newC = await showDialog<Color>(
                    context: context,
                    builder: (context) => _ColorPickerDialog(initColor: c),
                  );
                  if (newC != null) {
                    if (!mounted) return;
                    setState(() {
                      colors[idx] = newC;
                    });
                  }
                },
                title: Text(
                  "#${(c.r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, "0")}${(c.g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, "0")}${(c.b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, "0")} - ${localize.customFlagTapToMod}",
                  style: .new(
                    color: ThemeData.estimateBrightnessForColor(c) == .dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: .min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: ThemeData.estimateBrightnessForColor(c) == .dark
                          ? Colors.white
                          : Colors.black,
                      onPressed: () => setState(() => colors.removeAt(idx)),
                    ),
                    //const Padding(padding: .symmetric(horizontal: 8)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => setState(
            () => colors.add(
              Color(Random().nextInt(1 << 32)).withValues(alpha: 1),
            ),
          ),
          label: Text(localize.customFlagAddColor),
          icon: const Icon(Icons.add),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context, colors);
          },
          label: Text(localize.save),
          icon: const Icon(Icons.save),
        ),
      ],
      actionsAlignment: .spaceBetween,
      actionsOverflowAlignment: .center,
      actionsOverflowButtonSpacing: 8,
    );
  }
}

class _ColorPickerDialog extends StatelessWidget {
  const _ColorPickerDialog({required this.initColor});
  final Color initColor;
  @override
  Widget build(BuildContext context) {
    Color color = initColor;
    return AlertDialog(
      content: SingleChildScrollView(
        child: ColorPicker(
          color: initColor,
          onColorChanged: (c) => color = c,
          pickersEnabled: const {
            ColorPickerType.both: false,
            ColorPickerType.primary: false,
            ColorPickerType.accent: false,
            ColorPickerType.bw: false,
            ColorPickerType.custom: false,
            ColorPickerType.customSecondary: false,
            ColorPickerType.wheel: true,
          },
          enableShadesSelection: false,
          enableTooltips: false,
          showColorCode: true,
          colorCodeHasColor: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, color),
          child: Text(AppLocalizations.of(context)!.done),
        ),
      ],
    );
  }
}
