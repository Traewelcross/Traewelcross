enum DepartTypes {
  subUrban("suburban"),
  express("express"),
  regional("regional"),
  bus("bus"),
  ferry("ferry"),
  subway("subway"),
  tram("tram"),
  taxi("taxi"),
  plane("plane"),
  all("");

  final String value;
  const DepartTypes(this.value);

  @override
  String toString() => value;
}
