import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';

class LineColors {
  //Map<String, Map<String, Map<String, String>>> cachedLineColors = {};
  Map<String, dynamic> cachedLineColors = {};
  Future<LineColor?> getLineData({
    required String? operatorIdentifier,
    required String? lineName,
  }) async {
    if (operatorIdentifier == null || lineName == null) {
      return null;
    }

    final sanitizedOperator = operatorIdentifier.toLowerCase();
    final sanitizedLine = lineName.replaceAll(" ", "");

    if (cachedLineColors.isEmpty) {
      final dir = (await getApplicationSupportDirectory()).path;
      final file = File(join(dir, "line_colors.json"));
      if (await file.exists()) {
        cachedLineColors = jsonDecode(await file.readAsString());
      } else {
        cachedLineColors = jsonDecode(
          await rootBundle.loadString("assets/line_colors/line_colors.json"),
        );
      }
    }

    final line = cachedLineColors[sanitizedOperator]?[sanitizedLine];
    if (line != null) {
      return LineColor.fromJson(line);
    }

    return null;
  }

  Future<void> updateLineColors({
    String updateUrl =
        "https://raw.githubusercontent.com/Traewelling/line-colors/refs/heads/main/line-colors.csv",
  }) async {
    final client = http.Client();
    final res = await client.get(Uri.parse(updateUrl));
    if (res.statusCode != 200) {
      return Future.error("Not 200");
    }
    final csv = Csv().decode(res.body);
    final delfiNameIdx = csv[0].indexWhere((r) => r == "delfiAgencyName");
    final backgroundColorIdx = csv[0].indexWhere((r) => r == "backgroundColor");
    final textColorIdx = csv[0].indexWhere((r) => r == "textColor");
    final borderColorIdx = csv[0].indexWhere((r) => r == "borderColor");
    final shapeIdx = csv[0].indexWhere((r) => r == "shape");
    final lineNameIdx = csv[0].indexWhere((r) => r == "lineName");

    Map<String, Map<String, Map<String, String>>> lineData = {};
    for (int i = 1; i < csv.length; i++) {
      final row = csv[i];
      if (row[delfiNameIdx] == null ||
          (row[delfiNameIdx] as String?)?.isEmpty == true) {
        continue;
      }
      final hafasCode = (row[delfiNameIdx] as String).toLowerCase();
      final Map<String, String> lineDetails = {
        "background":
            (row[backgroundColorIdx] as String?)?.replaceAll("#", "") ?? "",
        "text": (row[textColorIdx] as String?)?.replaceAll("#", "") ?? "",
        "border": (row[borderColorIdx] as String?)?.replaceAll("#", "") ?? "",
        "shape": (row[shapeIdx] as String?) ?? "",
      };
      final operatorData = lineData.putIfAbsent(hafasCode, () => {});
      operatorData[(row[lineNameIdx] as String).replaceAll(" ", "")] =
          lineDetails;
      lineData[hafasCode] = operatorData;
    }
    final dir = (await getApplicationSupportDirectory()).path;
    final file = File(join(dir, "line_colors.json"));
    await file.writeAsString(jsonEncode(lineData));
    print(dir);
    cachedLineColors = lineData;
  }
}
