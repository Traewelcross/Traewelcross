import 'package:flutter/material.dart';
import 'package:traewelcross/components/pride_gradient.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/utils/shared.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value, this.borderRadius});
  final double value;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    final prideMode = getIt<Config>().appearance.isPrideActive;
    if(prideMode){
    return PrideGradient(
      rotation: 0,
      progress: value,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.transparent,
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