// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiscConfig _$MiscConfigFromJson(Map<String, dynamic> json) => MiscConfig()
  ..accountType =
      $enumDecodeNullable(_$AccountTypeEnumEnumMap, json['accountType']) ??
      AccountTypeEnum.traewelling
  ..lastBoot = json['lastBoot'] == null
      ? null
      : DateTime.parse(json['lastBoot'] as String)
  ..needsRelogin = json['needsRelogin'] as bool? ?? false
  ..launchCount = (json['launchCount'] as num?)?.toInt() ?? 0
  ..enableLogging = json['enableLogging'] as bool? ?? false
  ..logFile = json['logFile'] as String?
  ..logSuccessFull = json['logSuccessFull'] as bool? ?? false
  ..logBody = json['logBody'] as bool? ?? false;

Map<String, dynamic> _$MiscConfigToJson(MiscConfig instance) =>
    <String, dynamic>{
      'accountType': _$AccountTypeEnumEnumMap[instance.accountType]!,
      'lastBoot': instance.lastBoot?.toIso8601String(),
      'needsRelogin': instance.needsRelogin,
      'launchCount': instance.launchCount,
      'enableLogging': instance.enableLogging,
      'logFile': instance.logFile,
      'logSuccessFull': instance.logSuccessFull,
      'logBody': instance.logBody,
    };

const _$AccountTypeEnumEnumMap = {
  AccountTypeEnum.traewelling: 'traewelling',
  AccountTypeEnum.travelynx: 'travelynx',
};
