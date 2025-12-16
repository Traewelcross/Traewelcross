enum MapTypeEnum {
  standard("standard"),
  signals("signals"),
  maxSpeed("maxspeed");

  final String value;
  const MapTypeEnum(this.value);

  @override
  String toString() => value;

  static MapTypeEnum fromValue(String val) {
    return MapTypeEnum.values.firstWhere((e) => e.value == val);
  }
}
