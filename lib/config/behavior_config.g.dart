// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'behavior_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BehaviorConfig _$BehaviorConfigFromJson(Map<String, dynamic> json) =>
    BehaviorConfig()
      ..overrideOnTimeTap = json['overrideOnTimeTap'] as bool? ?? true
      ..delaySystemTimeOverride =
          (json['delaySystemTimeOverride'] as num?)?.toInt() ?? -1
      ..confirmDelete = json['confirmDelete'] as bool? ?? true
      ..hideManualOnTimeOverride =
          json['hideManualOnTimeOverride'] as bool? ?? true
      ..defaultStatusText = json['defaultStatusText'] as String?
      ..volumeBtnCtrl = json['volumeBtnCtrl'] as bool? ?? false;

Map<String, dynamic> _$BehaviorConfigToJson(BehaviorConfig instance) =>
    <String, dynamic>{
      'overrideOnTimeTap': instance.overrideOnTimeTap,
      'delaySystemTimeOverride': instance.delaySystemTimeOverride,
      'confirmDelete': instance.confirmDelete,
      'hideManualOnTimeOverride': instance.hideManualOnTimeOverride,
      'defaultStatusText': instance.defaultStatusText,
      'volumeBtnCtrl': instance.volumeBtnCtrl,
    };
