// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialogConfig _$DialogConfigFromJson(Map<String, dynamic> json) => DialogConfig()
  ..manualTripInfo = json['manualTripInfo'] as bool? ?? true
  ..notifyFixInfoDisplayCount =
      (json['notifyFixInfoDisplayCount'] as num?)?.toInt() ?? 0;

Map<String, dynamic> _$DialogConfigToJson(DialogConfig instance) =>
    <String, dynamic>{
      'manualTripInfo': instance.manualTripInfo,
      'notifyFixInfoDisplayCount': instance.notifyFixInfoDisplayCount,
    };
