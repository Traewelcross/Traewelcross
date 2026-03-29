import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:traewelcross/utils/pride_flags.dart';

/// Will use a randomly selected (or user defined) pride flag (presentent as gradient) to act as a Color replacement through ShaderMask
/// the backgroundColor (or equivalent) should be transparent, the actual color something else (like white) at full alpha
class PrideGradient extends StatefulWidget {
  const PrideGradient({super.key, required this.child, this.progress, this.rotation});
  final Widget child;
  final double? progress;
  /// In degrees
  final double? rotation;

  @override
  State<PrideGradient> createState() => _PrideGradientState();
}

class _PrideGradientState extends State<PrideGradient> {
  late List<Color> _selectedFlag;
  List<Color> _randomFlag() {
    final random = math.Random();
    final flagList = PrideFlags.getFlags();
    return flagList[random.nextInt(flagList.length)];
  }
  @override
  void initState(){
    super.initState();
    _selectedFlag = _randomFlag();
  }
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        double activeWidth = bounds.width * (widget.progress ?? 1);
        return LinearGradient(
          transform: GradientRotation((widget.rotation ?? 0)*(math.pi/180)),
          // double the colors to get hard transitions
          colors: PrideFlags.getColors(_selectedFlag).toList(),
          stops: PrideFlags.getStops(_selectedFlag),
        ).createShader(Rect.fromLTWH(0, 0, activeWidth, bounds.height));
      },
      blendMode: .srcIn,
      child: widget.child,
    );
  }

}
