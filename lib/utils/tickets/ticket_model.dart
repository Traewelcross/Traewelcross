import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:traewelcross/config/converters.dart';
import "package:traewelcross/utils/api_providers/api_models.dart";

part "ticket_model.g.dart";

@JsonSerializable()
class Ticket {
  String uuid;
  @Uint8ListConverter()
  Uint8List data;
  DateTime? expire;
  DateTime? begin;
  Operator? operator;
  int format;
  String? name;
  App? overriddenAppPackage;
  String? notes;
  Ticket({
    required this.uuid,
    required this.data,
    this.expire,
    this.begin,
    this.operator,
    required this.format,
    this.name,
    this.overriddenAppPackage,
    this.notes
  });
    factory Ticket.fromJson(Map<String, dynamic> json) =>
      _$TicketFromJson(json);
  Map<String, dynamic> toJson() => _$TicketToJson(this); 
}

@JsonSerializable()
class App {
  final String packageName;
  final String name;
  const App({required this.packageName, required this.name});
      factory App.fromJson(Map<String, dynamic> json) =>
      _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this); 
}