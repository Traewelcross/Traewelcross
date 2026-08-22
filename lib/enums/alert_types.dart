import 'package:json_annotation/json_annotation.dart';

enum AlertTypes {
  @JsonValue("info")
  info("info"),
  @JsonValue("warning")
  warning("warning"),
  @JsonValue("danger")
  danger("danger"),
  @JsonValue("success")
  success("success");

  final String value;
  const AlertTypes(this.value);

  @override
  String toString() => value;

  static AlertTypes fromValue(String val) {
    return AlertTypes.values.firstWhere((e) => e.value == val);
  }
}
