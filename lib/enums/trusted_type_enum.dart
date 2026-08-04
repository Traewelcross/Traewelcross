enum TrustedTypeEnum {
  /// User defined list
  list("list"),

  /// Follows each other
  friends("friends"),

  /// No one
  forbidden("forbidden");

  final String value;
  const TrustedTypeEnum(this.value);
  @override
  String toString() => value;
  static TrustedTypeEnum fromValue(String val) {
    return TrustedTypeEnum.values.firstWhere((e) => e.value == val);
  }
}
