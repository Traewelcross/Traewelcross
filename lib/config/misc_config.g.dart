// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiscConfig _$MiscConfigFromJson(Map<String, dynamic> json) => MiscConfig()
  ..accountType =
      $enumDecodeNullable(_$AccountTypeEnumEnumMap, json['accountType']) ??
      AccountTypeEnum.traewelling
  ..showStats = json['showStats'] as bool? ?? false
  ..lastBoot = json['lastBoot'] == null
      ? null
      : DateTime.parse(json['lastBoot'] as String)
  ..needsRelogin = json['needsRelogin'] as bool? ?? false;

Map<String, dynamic> _$MiscConfigToJson(MiscConfig instance) =>
    <String, dynamic>{
      'accountType': _$AccountTypeEnumEnumMap[instance.accountType]!,
      'showStats': instance.showStats,
      'lastBoot': instance.lastBoot?.toIso8601String(),
      'needsRelogin': instance.needsRelogin,
    };

const _$AccountTypeEnumEnumMap = {
  AccountTypeEnum.traewelling: 'traewelling',
  AccountTypeEnum.travelynx: 'travelynx',
};
