import 'package:json_annotation/json_annotation.dart';
import 'package:material_ui/material_ui.dart';

enum TripType {
  @JsonValue(0)
  private(0, Icons.person),
  @JsonValue(2)
  commute(2, Icons.home_work),
  @JsonValue(1)
  business(1, Icons.work);

  final int value;
  final IconData icon;
  const TripType(this.value, this.icon);
  
  @override
  String toString() => value.toString();
  
  static TripType fromValue(int val) {
    return TripType.values.firstWhere((e) => e.value == val);
  }
}
