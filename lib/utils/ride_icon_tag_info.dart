import 'package:material_ui/material_ui.dart';

class RideIconTagInfo {
  String? category;
  double width = 24;
  bool? showCategoryIcon;
  String? operatorIdentifier;
  String? lineName;
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
    this.routeColor,
    this.routeTextColor,
  });
}
