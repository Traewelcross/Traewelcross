// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appearance_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppearanceConfig _$AppearanceConfigFromJson(Map<String, dynamic> json) =>
    AppearanceConfig()
      ..useSystemAccent = json['useSystemAccent'] as bool? ?? true
      ..accentColor = _$JsonConverterFromJson<int, Color>(
        json['accentColor'],
        const ColorConverter().fromJson,
      )
      ..themeMode =
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system
      ..customLineIcons = json['customLineIcons'] as bool? ?? true
      ..mapType =
          $enumDecodeNullable(_$MapTypeEnumEnumMap, json['mapType']) ??
          MapTypeEnum.standard;

Map<String, dynamic> _$AppearanceConfigToJson(AppearanceConfig instance) =>
    <String, dynamic>{
      'useSystemAccent': instance.useSystemAccent,
      'accentColor': _$JsonConverterToJson<int, Color>(
        instance.accentColor,
        const ColorConverter().toJson,
      ),
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'customLineIcons': instance.customLineIcons,
      'mapType': _$MapTypeEnumEnumMap[instance.mapType]!,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$MapTypeEnumEnumMap = {
  MapTypeEnum.standard: 'standard',
  MapTypeEnum.signals: 'signals',
  MapTypeEnum.maxSpeed: 'maxSpeed',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
