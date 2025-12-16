import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:watch_it/watch_it.dart';

class RideIconTag extends WatchingStatefulWidget {
  const RideIconTag({super.key, required this.iconInfo});
  final RideIconTagInfo iconInfo;

  @override
  State<RideIconTag> createState() => _RideIconTagState();
}

class _RideIconTagState extends State<RideIconTag> {
  Future<dynamic>? _lineDataFuture;
  @override
  void initState() {
    super.initState();
    if (widget.iconInfo.hafasId != null) {
      _lineDataFuture = _getLine();
    }
  }

  @override
  Widget build(BuildContext context) {
    final customLineIcons = watchPropertyValue(
      (Config c) => c.appearance.customLineIcons,
    );
    return Row(
      children: [
        switch (widget.iconInfo.category) {
          final category
              when category == "tram" ||
                  category == "bus" ||
                  category == "suburban" ||
                  category == "subway" =>
            Row(
              children: [
                SvgPicture.asset(
                  "icons/ic_$category.svg",
                  width: widget.iconInfo.width,
                ),
              ],
            ),

          "ferry" => const Icon(Icons.directions_ferry),
          "taxi" => const Icon(Icons.local_taxi),
          "plane" => const Icon(Icons.airplanemode_active),
          final category? when category.isNotEmpty => Icon(
            Icons.train,
            size: widget.iconInfo.width,
            opticalSize: widget.iconInfo.width,
            applyTextScaling: true,
          ),
          _ => const Icon(Icons.train),
        },
        const SizedBox(width: 6),
        if (customLineIcons) ...[
          FutureBuilder(
            future: _lineDataFuture,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.done &&
                  asyncSnapshot.hasData) {
                final data = asyncSnapshot.data!;
                return switch (data["shape"]) {
                  final shape
                      when shape == "rectangle" ||
                          shape == "rectangle-rounded-corner" ||
                          shape == "pill" ||
                          shape == "circle" =>
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: widget.iconInfo.width,
                      ),
                      child: Container(
                        height: widget.iconInfo.width,
                        decoration: BoxDecoration(
                          shape: _getShape(shape),
                          borderRadius: _getRadius(shape),
                          color: Color(int.parse("0xFF${data["background"]}")),
                          border: Border.all(
                            width: 1.5,
                            color: Color(
                              int.parse(
                                "0xFF${data["border"] ?? data["background"]}",
                              ),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: _getPadding(shape),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.iconInfo.lineName!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(
                                    int.parse("0xFF${data["text"]}"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  _ => Text(widget.iconInfo.lineName ?? ""),
                };
              }
              return Text(widget.iconInfo.lineName ?? "");
            },
          ),
        ] else ...[
          Text(widget.iconInfo.lineName ?? ""),
        ],
      ],
    );
  }

  Future<dynamic> _getLine() async {
    return jsonDecode(
      await rootBundle.loadString("assets/line_colors/line_colors.json"),
    )[widget.iconInfo.hafasId][widget.iconInfo.lineName?.replaceAll(" ", "")];
  }

  BorderRadius _getRadius(String shape) {
    if (shape == "rectangle") {
      return BorderRadius.zero;
    }
    if (shape == "rectangle-rounded-corner") {
      return BorderRadius.circular(4);
    }
    if (shape == "pill") {
      return BorderRadius.circular(999999);
    }
    return BorderRadius.zero;
  }

  EdgeInsetsGeometry _getPadding(String shape) {
    if (shape == "rectangle") {
      return EdgeInsetsGeometry.zero;
    }
    if (shape == "rectangle-rounded-corner") {
      return EdgeInsetsGeometry.all(2);
    }
    if (shape == "pill") {
      return EdgeInsetsGeometry.symmetric(horizontal: 8);
    }
    return EdgeInsetsGeometry.zero;
  }

  BoxShape _getShape(String shape) {
    if (shape == "circle") {
      return BoxShape.circle;
    } else {
      return BoxShape.rectangle;
    }
  }
}
