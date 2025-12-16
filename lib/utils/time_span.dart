class TimeSpan {
  final int duration;

  late final int _minutes;
  late final int _totalHours;
  late final int _days;
  late final int _hours;

  TimeSpan(this.duration) {
    _minutes = duration % 60;
    _totalHours = duration ~/ 60;
    _days = _totalHours ~/ 24;
    _hours = _totalHours % 24;
  }

  int get days => _days;
  int get hours => _hours;
  int get minutes => _minutes;
}
