import 'package:flutter/material.dart';

const tcColorLight = Color(0xFF03bd72);

final tcColorSchemeLight = ColorScheme.fromSeed(
  seedColor: tcColorLight,
  dynamicSchemeVariant: DynamicSchemeVariant.content,
);
/*final tcColorSchemeLight = const ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 75, 25, 210),
  onPrimary: Colors.white,
  secondary: Color.fromARGB(255, 107, 61, 232),
  onSecondary: Colors.black,
  surface: Color.fromARGB(255, 240, 240, 240),
  onSurface: Color.fromARGB(255, 5, 2, 15),
  error: Colors.red,
  onError: Colors.white,
).harmonized();*/
const tcColorDark = Color(0xFF17AB70);

final tcColorSchemeDark = ColorScheme.fromSeed(
  seedColor: tcColorDark,
  dynamicSchemeVariant: DynamicSchemeVariant.content,
  brightness: Brightness.dark,
);
/*final tcColorSchemeDark = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 134, 97, 236),
  onPrimary: Colors.white,
  secondary: Color.fromARGB(255, 107, 61, 232),
  onSecondary: Colors.black,
  surface: Color.fromARGB(255, 5, 2, 15),
  onSurface: Color.fromARGB(255, 240, 240, 240),
  error: Colors.red,
  onError: Colors.white,
).harmonized();*/
