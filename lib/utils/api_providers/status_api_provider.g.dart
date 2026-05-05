// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_api_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  key: json['key'] as String?,
  value: json['value'] as String?,
  visibility: $enumDecodeNullable(
    _$TripVisibilityEnumEnumMap,
    json['visibility'],
  ),
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
  'visibility': _$TripVisibilityEnumEnumMap[instance.visibility],
};

const _$TripVisibilityEnumEnumMap = {
  TripVisibilityEnum.public: 0,
  TripVisibilityEnum.loggedInUser: 4,
  TripVisibilityEnum.followerOnly: 2,
  TripVisibilityEnum.notListed: 1,
  TripVisibilityEnum.private: 3,
};
