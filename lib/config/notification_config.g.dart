// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationConfig _$NotificationConfigFromJson(Map<String, dynamic> json) =>
    NotificationConfig()
      ..notificationsEnabled = json['notificationsEnabled'] as bool? ?? false
      ..notificationsAvailable =
          json['notificationsAvailable'] as bool? ?? false
      ..fcmToken = json['fcmToken'] as String? ?? ''
      ..hasBeenRegistered = json['hasBeenRegistered'] as bool? ?? false;

Map<String, dynamic> _$NotificationConfigToJson(NotificationConfig instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'notificationsAvailable': instance.notificationsAvailable,
      'fcmToken': instance.fcmToken,
      'hasBeenRegistered': instance.hasBeenRegistered,
    };
