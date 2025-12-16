// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiscConfig _$MiscConfigFromJson(Map<String, dynamic> json) => MiscConfig()
  ..accountType =
      $enumDecodeNullable(_$AccountTypeEnumEnumMap, json['accountType']) ??
      AccountTypeEnum.traewelling;

Map<String, dynamic> _$MiscConfigToJson(MiscConfig instance) =>
    <String, dynamic>{
      'accountType': _$AccountTypeEnumEnumMap[instance.accountType]!,
    };

const _$AccountTypeEnumEnumMap = {
  AccountTypeEnum.traewelling: 'traewelling',
  AccountTypeEnum.travelynx: 'travelynx',
};
