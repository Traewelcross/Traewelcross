// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  uuid: json['uuid'] as String,
  data: const Uint8ListConverter().fromJson(json['data'] as List),
  expire: json['expire'] == null
      ? null
      : DateTime.parse(json['expire'] as String),
  begin: json['begin'] == null ? null : DateTime.parse(json['begin'] as String),
  operator: json['operator'] == null
      ? null
      : Operator.fromJson(json['operator'] as Map<String, dynamic>),
  format: (json['format'] as num).toInt(),
  name: json['name'] as String?,
  overriddenAppPackage: json['overriddenAppPackage'] == null
      ? null
      : App.fromJson(json['overriddenAppPackage'] as Map<String, dynamic>),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'data': const Uint8ListConverter().toJson(instance.data),
  'expire': instance.expire?.toIso8601String(),
  'begin': instance.begin?.toIso8601String(),
  'operator': instance.operator,
  'format': instance.format,
  'name': instance.name,
  'overriddenAppPackage': instance.overriddenAppPackage,
  'notes': instance.notes,
};

App _$AppFromJson(Map<String, dynamic> json) => App(
  packageName: json['packageName'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
  'packageName': instance.packageName,
  'name': instance.name,
};
