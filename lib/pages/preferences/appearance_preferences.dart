// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traewelcross/components/color_circle.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/config/enums/map_type_enum.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import "package:traewelcross/utils/color_scheme.dart";
import 'package:traewelcross/utils/shared.dart';

class AppearancePreferences extends StatefulWidget {
  const AppearancePreferences({super.key});

  @override
  State<AppearancePreferences> createState() => _AppearancePreferencesState();
}

class _AppearancePreferencesState extends State<AppearancePreferences> {
  late Future<bool> dynamicSupportFuture;
  @override
  void initState() {
    super.initState();
    dynamicSupportFuture = SharedFunctions.dynamicColorSupport();
        print(PlatformDispatcher.instance.systemFontFamily);

  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    Config config = getIt<Config>();
    return MainScaffold(
      title: Text(localize.appearance),
      body: FutureBuilder(
        future: dynamicSupportFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error!.toString()));
          }
          return ListView(
            shrinkWrap: true,
            children: [
              ListTile(title: Text(localize.selectMode)),
              ListTile(
                title: SegmentedButton(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: const Icon(Icons.sunny),
                      label: Text(localize.lightMode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: const Icon(Icons.settings),
                      label: Text(localize.systemMode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: const Icon(Icons.dark_mode),
                      label: Text(localize.darkMode),
                    ),
                  ],
                  selected: {config.appearance.themeMode},
                  onSelectionChanged: (val) =>
                      config.appearance.themeMode = val.first,
                ),
              ),
              Divider(),
              ListTile(
                title: Text(localize.useSystemAccent),
                trailing: Checkbox(
                  value: config.appearance.useSystemAccent,
                  onChanged: asyncSnapshot.data!
                      ? (val) => config.appearance.useSystemAccent = val!
                      : null,
                ),
                onTap: () => config.appearance.useSystemAccent =
                    !config.appearance.useSystemAccent,
                enabled: asyncSnapshot.data!,
              ),
              if (!config.appearance.useSystemAccent)
                Column(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        localize.selectAccent,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ColorCircleList(),
                    ),
                  ],
                ),
              Divider(),
              ExpansionTile(
                title: Text(localize.fontFamilyChooser),
                shape: Border.all(color: Colors.transparent),
                children: [
                  RadioGroup(
                    groupValue: config.appearance.fontFam,
                    onChanged: (value) => setState(() {
                      config.appearance.fontFam = value!;
                    }),
                    child: Column(
                      children: [
                        // this doesn't work
                        /*RadioListTile(
                          value:"system",
                          title: Text(localize.systemFont, style: TextStyle(fontFamily: PlatformDispatcher.instance.systemFontFamily),),
                          subtitle: Text(localize.systemFontDesc),
                        ),*/
                        RadioListTile(
                          value: "Outfit",
                          title: Text(
                            "Outfit",
                            style: TextStyle(fontFamily: "Outfit"),
                          ),
                          subtitle: Text(localize.outfitFontDesc),
                        ),
                        RadioListTile(
                          value: "Rubik",
                          title: Text(
                            "Rubik",
                            style: TextStyle(fontFamily: "Rubik"),
                          ),
                          subtitle: Text(localize.rubikFontDesc),
                        ),
                        RadioListTile(
                          value: "Nunito",
                          title: Text(
                            "Nunito",
                            style: TextStyle(fontFamily: "Nunito"),
                          ),
                          subtitle: Text(localize.nunitoFontDesc),
                        ),
                        RadioListTile(
                          value: "IntelOneMono",
                          title: Text(
                            "Intel One Mono",
                            style: TextStyle(fontFamily: "IntelOneMono"),
                          ),
                          subtitle: Text(localize.iomFontDesc),
                        ),
                        RadioListTile(
                          value: "SUSE",
                          title: Text(
                            "SUSE",
                            style: TextStyle(fontFamily: "SUSE"),
                          ),
                          subtitle: Text(localize.suseFontDesc),
                        ),
                        RadioListTile(
                          value: "Linefont",
                          title: Text(
                            "Linefont",
                            style: TextStyle(fontFamily: "Linefont"),
                          ),
                          subtitle: Text(localize.linefontFontDesc),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              ListTile(
                onTap: () => setState(() {
                  config.appearance.customLineIcons =
                      !config.appearance.customLineIcons;
                }),
                title: Text(localize.useLineIcons),
                trailing: Checkbox(
                  value: config.appearance.customLineIcons,
                  onChanged: (val) => setState(() {
                    config.appearance.customLineIcons = val!;
                  }),
                ),
              ),
              Divider(),
              ListTile(title: Text(localize.selectMapType)),
              RadioGroup(
                groupValue: config.appearance.mapType,
                onChanged: (value) => setState(() {
                  config.appearance.mapType = value as MapTypeEnum;
                }),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => setState(() {
                        config.appearance.mapType = MapTypeEnum.standard;
                      }),
                      leading: Radio(value: MapTypeEnum.standard),
                      title: Text(localize.selectMapStandard),
                    ),
                    ListTile(
                      onTap: () => setState(() {
                        config.appearance.mapType = MapTypeEnum.signals;
                      }),
                      leading: Radio(value: MapTypeEnum.signals),
                      title: Text(localize.selectMapSignals),
                    ),
                    ListTile(
                      onTap: () => setState(() {
                        config.appearance.mapType = MapTypeEnum.maxSpeed;
                      }),
                      leading: Radio(value: MapTypeEnum.maxSpeed),
                      title: Text(localize.selectMapMaxSpeed),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          );
        },
      ),
    );
  }
}

class ColorCircleList extends StatelessWidget {
  ColorCircleList({super.key});
  final List<Color> colors = [
    tcColorLight,
    const Color(0xFF0a2239),
    const Color(0xFF1D84B5), // Turquoise
    const Color(0xFFF87060), // Coral
    const Color(0xFFE53935), // Red
    const Color(0xFFD81B60), // Pink
    const Color(0xFF8E24AA), // Purple
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF1E88E5), // Blue
    const Color(0xFF03A9F4), // Light Blue
    const Color(0xFF009688), // Teal
    const Color(0xFF4CAF50), // Green
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFFCDDC39), // Lime
    const Color(0xFFFF9800), // Orange
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
    Colors.black,
  ];
  Widget? getIcon(Color color, Config config) {
    if ((color == tcColorDark || color == tcColorLight) &&
        color == config.appearance.accentColor) {
      return SvgPicture.asset(
        "icons/raw_icon.svg",
        width: 18,
        color: ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white,
      );
    }
    if (color == config.appearance.accentColor) {
      return Icon(
        Icons.check,
        color: ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final config = getIt<Config>();
    Color pickerColor = config.appearance.accentColor ?? Colors.white;
    List<ColorCircle> colorCircles = colors
        .map(
          (color) => ColorCircle(
            color: color,
            icon: getIcon(color, config),
            width: 48,
            onTap: (color) => config.appearance.accentColor = color,
          ),
        )
        .toList();
    colorCircles.add(
      ColorCircle(
        color: config.appearance.accentColor ?? Colors.white,
        icon: Icon(
          Icons.colorize,
          color:
              ThemeData.estimateBrightnessForColor(
                    config.appearance.accentColor ?? Colors.white,
                  ) ==
                  Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        width: 48,
        onTap: (color) => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(localize.selectAccent),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) => pickerColor = color,
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localize.cancel),
                ),
                FilledButton.icon(
                  onPressed: () {
                    config.appearance.accentColor = pickerColor;
                    Navigator.pop(context);
                  },
                  label: Text(localize.save),
                  icon: const Icon(Icons.save),
                ),
              ],
            );
          },
        ),
      ),
    );
    return Padding(
      padding:
          Theme.of(context).listTileTheme.contentPadding ?? EdgeInsets.all(0),
      child: Wrap(spacing: 8, runSpacing: 4, children: colorCircles),
    );
  }
}
