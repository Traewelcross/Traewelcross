import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late final Future<Map<String, dynamic>> _stats;
  Future<Map<String, dynamic>> _getGlobalStats() async {
    final response = await getIt<ApiService>().request(
      "/statistics/global",
      HttpRequestTypes.GET,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    }
    return Future.value({});
  }

  @override
  void initState() {
    super.initState();
    _stats = _getGlobalStats();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _stats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          num maxValue = snapshot.data!.values.reduce((a, b) => a > b ? a : b);
          return LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: snapshot.data!.entries.map((entry) {
                  double ratio = entry.value / maxValue;
                  return Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: ratio,
                            child: Container(width: 40, color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(entry.key),
                    ],
                  );
                }).toList(),
              );
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Placeholder();
      },
    );
  }
}
