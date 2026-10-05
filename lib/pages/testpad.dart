// ignore_for_file: avoid_print

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/progress_bar.dart';
import 'package:traewelcross/utils/volume_buttons.dart';


class Testpad extends StatefulWidget {
  const Testpad({super.key});

  @override
  State<Testpad> createState() => _TestpadState();
}

class _TestpadState extends State<Testpad> {
  StreamSubscription<VolumeEvent>? _volumeSubscription;
  @override
  void initState(){
    super.initState();
    _volumeSubscription = VolumeButtonService().stream.listen((e) {
      print(e);
    });
  }
  @override dispose(){
    _volumeSubscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double progress = 0.4;
    return MainScaffold(
      title: AppBarTitle("Testpad"),
      body: Column(
        spacing: 6,
        children: [
          SizedBox(height: 6,),
          CircularProgressIndicator(value: 0.5,),
          VolumeButtonService().buildHoldProgressIndicator( size: 24),
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
              ).createShader(Rect.fromLTWH(0, 0, activeWidth, bounds.height));
            },
            blendMode: BlendMode.srcIn,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Divider(),
          ProgressBar(value: progress),
        ],
      ),
    );
  }
}
