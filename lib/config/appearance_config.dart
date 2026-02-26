import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:traewelcross/config/converters.dart';
import 'package:traewelcross/config/enums/map_type_enum.dart';

part 'appearance_config.g.dart';

@JsonSerializable()
class AppearanceConfig with ChangeNotifier {
  AppearanceConfig();

  factory AppearanceConfig.fromJson(Map<String, dynamic> json) =>
      _$AppearanceConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AppearanceConfigToJson(this);

  /// If available use the System provided Accent Color
  bool _useSystemAccent = true;
  @JsonKey(defaultValue: true)
  bool get useSystemAccent => _useSystemAccent;
  set useSystemAccent(bool value) {
    _useSystemAccent = value;
    notifyListeners();
  }

  /// Fallback accent color; Will use Träwelcross provieded green if null
  @ColorConverter()
  Color? _accentColor;
  @ColorConverter()
  Color? get accentColor => _accentColor;
  set accentColor(Color? value) {
    _accentColor = value;
    notifyListeners();
  }

  /// Which theme to use
  ThemeMode _themeMode = ThemeMode.system;
  @JsonKey(defaultValue: ThemeMode.system)
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  /// Should custom line icons be displayed?
  bool _customLineIcons = true;
  @JsonKey(defaultValue: true)
  bool get customLineIcons => _customLineIcons;
  set customLineIcons(bool val) {
    _customLineIcons = val;
    notifyListeners();
  }

  /// The style of OpenRailwayMap to use
  MapTypeEnum _mapType = MapTypeEnum.standard;
  @JsonKey(defaultValue: MapTypeEnum.standard)
  MapTypeEnum get mapType => _mapType;
  set mapType(MapTypeEnum value) {
    _mapType = value;
    notifyListeners();
  }

  /// Custom font
  String _fontFam = "Outfit";
  @JsonKey(defaultValue: "Outfit")
  String get fontFam => _fontFam;
  set fontFam(String val) {
    _fontFam = val;
    notifyListeners();
  }
}
