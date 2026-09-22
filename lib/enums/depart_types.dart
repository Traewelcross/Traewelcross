enum DepartTypes {
  express("express"),
  nationalExpress("nationalExpress"),
  national("national"),
  regionalExp("regionalExp"),
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
