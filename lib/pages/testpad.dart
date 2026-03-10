import 'package:flutter/material.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/progress_bar.dart';

class Testpad extends StatelessWidget {
  const Testpad({super.key});
  @override
  Widget build(BuildContext context) {
    double progress = 0.4;
    return MainScaffold(
      title: AppBarTitle("Testpad"),
      body: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              double activeWidth = bounds.width * progress;
              return LinearGradient(
                colors: [
                  Colors.red, // Color 1
                  Colors.red, // End of Color 1
                  Colors.yellow, // Start of Color 2
                  Colors.yellow, // End of Color 2
                  Colors.green, // Start of Color 3
                  Colors.green, // End of Color 3
                ],
                stops: [
                  0.0, // Start Red
                  0.33, // End Red
                  0.33, // Start Yellow (Hard transition at 33%)
                  0.66, // End Yellow
                  0.66, // Start Green (Hard transition at 66%)
                  1.0, // End Green
                ],
              ).createShader(Rect.fromLTWH(0,0, activeWidth, bounds.height));
            },
            blendMode: BlendMode.srcIn,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Divider(),
          ProgressBar(value: progress)
        ],
      ),
    );
  }
}
