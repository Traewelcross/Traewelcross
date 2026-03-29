class RideIconTagInfo {
  String? category;
  double width = 24;
  bool? showCategoryIcon;
  String? operatorIdentifier;
  String? lineName;
  RideIconTagInfo({
    this.category,
    required this.width,
    this.operatorIdentifier,
    this.showCategoryIcon,
    this.lineName,
  });
}
