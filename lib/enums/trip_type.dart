import 'package:json_annotation/json_annotation.dart';

enum TripType {
  @JsonValue(0)
  private(0),
  @JsonValue(2)
  commute(2),
  @JsonValue(1)
  business(1);

  final int value;
  const TripType(this.value);

  static TripType fromValue(int val) {
    return TripType.values.firstWhere((e) => e.value == val);
  }
}
