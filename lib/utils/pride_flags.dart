import 'package:flutter/material.dart';

class PrideFlags {
  static const List<Color> trans = [
    Color.fromRGBO(97, 205, 246, 1),
    Color.fromRGBO(246, 169, 184, 1),
    Colors.white,
    Color.fromRGBO(246, 169, 184, 1),
    Color.fromRGBO(97, 205, 246, 1),
  ];
  static const List<Color> rainbow = [
    Color.fromRGBO(250, 0, 0, 1),
    Color.fromRGBO(255, 133, 0, 1),
    Color.fromRGBO(255, 237, 0, 1),
    Color.fromRGBO(0, 130, 13, 1),
    Color.fromRGBO(0, 74, 255, 1),
    Color.fromRGBO(130, 0, 140, 1),
  ];
  static const List<Color> inter = [
    Color.fromRGBO(255, 216, 0, 1),
    Color.fromRGBO(121, 2, 170, 1),
    Color.fromRGBO(255, 216, 0, 1),
  ];
  static const List<Color> lesbian = [
    Color.fromRGBO(213, 45, 0, 1),
    Color.fromRGBO(255, 154, 86, 1),
    Colors.white,
    Color.fromRGBO(211, 98, 164, 1),
    Color.fromRGBO(163, 2, 98, 1),
  ];
  static const List<Color> gay = [
    Color.fromRGBO(7, 141, 112, 1),
    Color.fromRGBO(38, 206, 170, 1),
    Colors.white,
    Color.fromRGBO(123, 173, 226, 1),
    Color.fromRGBO(61, 26, 120, 1),
  ];
  static const List<Color> nonbinary = [
    Color.fromRGBO(255, 244, 48, 1),
    Colors.white,
    Color.fromRGBO(156, 89, 209, 1),
    Colors.black,
  ];
  static const List<Color> pan = [
    Color.fromRGBO(255, 33, 140, 1),
    Color.fromRGBO(255, 216, 0, 1),
    Color.fromRGBO(33, 177, 255, 1),
  ];
  static const List<Color> bi = [
    Color.fromRGBO(214, 2, 112, 1),
    Color.fromRGBO(155, 79, 150, 1),
    Color.fromRGBO(0, 56, 168, 1),
  ];
  static const List<Color> asex = [
    Colors.black,
    Color.fromRGBO(163, 163, 163, 1),
    Colors.white,
    Color.fromRGBO(128, 0, 128, 1),
  ];
  static const List<Color> arom = [
    Color.fromRGBO(61, 165, 66, 1),
    Color.fromRGBO(167, 211, 121, 1),
    Colors.white,
    Color.fromRGBO(169, 169, 169, 1),
    Colors.black,
  ];
  static List<List<Color>> getFlags() {
    return const [
      trans,
      rainbow,
      inter,
      lesbian,
      gay,
      nonbinary,
      pan,
      bi,
      asex,
      arom,
    ];
  }

  static Iterable<Color> getColors(List<Color> sF) => sF.expand((c) => [c, c]);
  static List<double> getStops(List<Color> sF) {
    return [
      for (int i = 0; i < sF.length; i++) ...[
        i / sF.length,
        (i + 1) / sF.length,
      ],
    ];
  }
}
