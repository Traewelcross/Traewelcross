import 'package:logger/logger.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/line_colors.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:watch_it/watch_it.dart';

class RideIconTag extends WatchingStatefulWidget {
  const RideIconTag({super.key, required this.iconInfo});
  final RideIconTagInfo iconInfo;

  @override
  State<RideIconTag> createState() => _RideIconTagState();
}

class _RideIconTagState extends State<RideIconTag> {
  Future<LineColor?>? _lineDataFuture;
  @override
  void initState() {
    super.initState();
    if (widget.iconInfo.operatorIdentifier != null) {
      _lineDataFuture = getIt<LineColors>().getLineData(
        operatorIdentifier: widget.iconInfo.operatorIdentifier,
        lineName: widget.iconInfo.lineName,
      );
    }
    getIt<Logger>().d(widget.iconInfo.toString());
  }

  @override
  Widget build(BuildContext context) {
    final customLineIcons = watchPropertyValue(
      (Config c) => c.appearance.customLineIcons,
    );
    return Row(
      mainAxisSize: .min,
      children: [
        if (widget.iconInfo.showCategoryIcon ?? true)
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
          FutureBuilder<LineColor?>(
            future: _lineDataFuture,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.done &&
                  asyncSnapshot.hasData &&
                  asyncSnapshot.data != null) {
                final data = asyncSnapshot.data!;
                return switch (data.shape) {
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
                          color:
                              widget.iconInfo.routeColor ??
                              Color(int.parse("0xFF${data.background}")),
                          border: Border.all(
                            width: 1.5,
                            color: Color(
                              int.parse(
                                "0xFF${data.border.isNotEmpty ? data.border : data.background}",
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
                                  color:
                                      widget.iconInfo.routeTextColor ??
                                      Color(int.parse("0xFF${data.text}")),
                                  decoration: widget.iconInfo.cancelled == true
                                      ? .lineThrough
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  _ => Text(
                    widget.iconInfo.lineName ?? "",
                    style: TextStyle(
                      decoration: widget.iconInfo.cancelled == true
                          ? .lineThrough
                          : null,
                    ),
                  ),
                };
              }
              return Text(
                widget.iconInfo.lineName ?? "",
                style: TextStyle(
                  decoration: widget.iconInfo.cancelled == true
                      ? .lineThrough
                      : null,
                ),
              );
            },
          ),
        ] else ...[
          Text(
            widget.iconInfo.lineName ?? "",
            style: TextStyle(
              decoration: widget.iconInfo.cancelled == true
                  ? .lineThrough
                  : null,
            ),
          ),
        ],
      ],
    );
  }

  BorderRadius? _getRadius(String shape) {
    if (shape == "rectangle") {
      return BorderRadius.zero;
    }
    if (shape == "rectangle-rounded-corner") {
      return BorderRadius.circular(4);
    }
    if (shape == "pill") {
      return BorderRadius.circular(999999);
    }
    if (shape == "circle") {
      return null;
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
