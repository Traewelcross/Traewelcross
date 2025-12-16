import 'dart:math';

import 'package:flutter/widgets.dart';

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    super.key,
    required this.color,
    required this.icon,
    required this.width,
    required this.onTap,
  });
  final Color color;
  final Widget? icon;
  final double width;
  final Function(Color color) onTap;
  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return GestureDetector(
      onTap: () => onTap.call(color),
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: hsl.withLightness(max(hsl.lightness - 0.1, 0.1)).toColor(),
            width: 2,
          ),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
