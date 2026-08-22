import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import "dart:typed_data";

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();
  @override
  Color fromJson(int json) {
    return Color(json);
  }

  @override
  int toJson(Color object) {
    return object.toARGB32();
  }
}
class Uint8ListConverter implements JsonConverter<Uint8List, List<dynamic>> {
  const Uint8ListConverter();
  @override
  Uint8List fromJson(List<dynamic> json) {
    return Uint8List.fromList(json.map((e) => (e as num).toInt()).toList());
  }
  @override
  List<dynamic> toJson(Uint8List object) {
    return object.toList();
  }
}