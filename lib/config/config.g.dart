// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config()
  ..appearance = json['appearance'] == null
      ? AppearanceConfig()
      : AppearanceConfig.fromJson(json['appearance'] as Map<String, dynamic>)
  ..behavior = json['behavior'] == null
      ? BehaviorConfig()
      : BehaviorConfig.fromJson(json['behavior'] as Map<String, dynamic>)
  ..misc = json['misc'] == null
      ? MiscConfig()
      : MiscConfig.fromJson(json['misc'] as Map<String, dynamic>)
  ..notification = json['notification'] == null
      ? NotificationConfig()
      : NotificationConfig.fromJson(
          json['notification'] as Map<String, dynamic>,
        );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
  'appearance': instance.appearance,
  'behavior': instance.behavior,
  'misc': instance.misc,
  'notification': instance.notification,
};
