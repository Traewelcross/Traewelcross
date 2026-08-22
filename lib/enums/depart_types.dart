enum DepartTypes {
  express("express"),
  regional("regional"),
  subUrban("suburban"),
  subway("subway"),
  tram("tram"),
  bus("bus"),
  ferry("ferry"),
  taxi("taxi"),
  plane("plane"),
  freightTrain("freightTrain"),
  all("");

  final String value;
  const DepartTypes(this.value);

  @override
  String toString() => value;
}
