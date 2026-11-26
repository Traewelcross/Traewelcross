import 'package:material_ui/material_ui.dart';

class RideIconTagInfo {
  String? category;
  double width = 24;
  bool? showCategoryIcon;
  String? operatorIdentifier;
  String? lineName;
  bool? cancelled;

  /// Supplied by API
  Color? routeColor;

  /// Supplied by API
  Color? routeTextColor;
  RideIconTagInfo({
    this.category,
    required this.width,
    this.operatorIdentifier,
    this.showCategoryIcon,
    this.lineName,
    this.cancelled,
    this.routeColor,
    this.routeTextColor,
  });
  @override
  String toString() {
    return "Line is: $lineName, of category $category, operated by $operatorIdentifier, routeColor is $routeColor, textColor is $routeTextColor. Line cancelled? $cancelled";
  }
}
