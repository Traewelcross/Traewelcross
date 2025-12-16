enum TripType {
  private(0),
  commute(2),
  business(1);

  final int value;
  const TripType(this.value);

  static TripType fromValue(int val) {
    return TripType.values.firstWhere((e) => e.value == val);
  }
}
