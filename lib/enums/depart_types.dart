import 'package:json_annotation/json_annotation.dart';

enum DepartTypes {
  @JsonValue("express")
  express("express"),

  @JsonValue("nationalExpress")
  nationalExpress("nationalExpress"),

  @JsonValue("national")
  national("national"),

  @JsonValue("regionalExp")
  regionalExp("regionalExp"),
  
  @JsonValue("regional")
  regional("regional"),

  @JsonValue("suburban")
  subUrban("suburban"),

  @JsonValue("subway")
  subway("subway"),

  @JsonValue("tram")
  tram("tram"),

  @JsonValue("bus")
  bus("bus"),

  @JsonValue("ferry")
  ferry("ferry"),

  @JsonValue("taxi")
  taxi("taxi"),

  @JsonValue("plane")
  plane("plane"),

  @JsonValue("freightTrain")
  freightTrain("freightTrain"),

  all("");

  final String value;
  const DepartTypes(this.value);

  @override
  String toString() => value;
}
