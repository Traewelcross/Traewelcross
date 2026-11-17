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

class MapStringIterableColorConverter
    implements JsonConverter<Map<String, List<Color>>, Map<String, dynamic>> {
  const MapStringIterableColorConverter();
  @override
  Map<String, List<Color>> fromJson(Map<String, dynamic> json) {
    Map<String, List<Color>> flags = {};
    json.forEach((k, v) {
      flags[k] = (v as List<dynamic>).map((e) => Color(e as int)).toList();
    });
    return flags;
  }

  @override
  Map<String, List<int>> toJson(Map<String, List<Color>> object) {
    Map<String, List<int>> flags = {};
    object.forEach((k, v) => flags[k] = v.map((e) => e.toARGB32()).toList());
    return flags;
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
