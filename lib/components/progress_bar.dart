import 'package:flutter/material.dart';
import 'package:traewelcross/components/pride_gradient.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/utils/shared.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, this.value, this.borderRadius, this.seed});
  final double? value;
  final BorderRadius? borderRadius;
  final int? seed;
  @override
  Widget build(BuildContext context) {
    final prideMode = getIt<Config>().appearance.isPrideActive;
    if(prideMode){
    return PrideGradient(
      rotation: 0,
      progress: value,
      seed: seed,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.white24,
        borderRadius: borderRadius,
        valueColor: AlwaysStoppedAnimation(Colors.white)),
    );
    } else {
      return LinearProgressIndicator(
        value: value,
        borderRadius: borderRadius,
      );
    }

  }
}