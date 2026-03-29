import 'dart:async';
import 'package:flutter/material.dart';
import 'package:traewelcross/components/progress_bar.dart';
import 'package:traewelcross/utils/shared.dart';

class TimeProgress extends StatefulWidget {
  const TimeProgress({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.rideId,
  });
  final DateTime startDate;
  final DateTime endDate;
  final int rideId;
  @override
  State<TimeProgress> createState() => _TimeProgressState();
}
class _TimeProgressState extends State<TimeProgress> {
  DateTime? _startDate;
  DateTime? _endDate;
  double progress = 0.0;
  Timer? _timer;
  int? _totalDuration;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _totalDuration = _endDate!.difference(_startDate!).inMilliseconds;
    _updateProgress();
    _startProgressLoop();
  }

  void _updateProgress() {
    final now = DateTime.now();
    final elapsed = now.difference(_startDate!).inMilliseconds;
    if (mounted) {
      setState(() {
        progress = (elapsed / _totalDuration!).clamp(0.0, 1.0);
      });
    }
  }

  void _startProgressLoop() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateProgress();
      if (progress >= 1.0) {
        timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(TimeProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startDate != oldWidget.startDate ||
        widget.endDate != oldWidget.endDate) {
      _timer?.cancel();
      _startDate = widget.startDate;
      _endDate = widget.endDate;
      _totalDuration = _endDate!.difference(_startDate!).inMilliseconds;
      _updateProgress();
      _startProgressLoop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (progress >= 1.0) {
      return ProgressBar(
        value: 1.0,
        seed: SharedFunctions.stableSeed ^ widget.rideId,
        borderRadius: BorderRadius.circular(99999999),
      );
    } else {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: progress),
        duration: Duration(seconds: 1),
        builder: (context, value, child) {
          return ProgressBar(
            seed: SharedFunctions.stableSeed ^ widget.rideId,
            value: value,
            borderRadius: BorderRadius.circular(99999999),
          );
        },
      );
    }
  }
}