import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class TagIcon extends StatelessWidget {
  const TagIcon({super.key, required this.tag});
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Icon(switch (tag) {
      final key when key == "trwl:journey_number" => Icons.route,
      "trwl:locomotive_class" => Icons.train,
      "trwl:passenger_rights" => Icons.gavel,
      "trwl:price" => Icons.euro,
      "trwl:role" => Icons.work,
      "trwl:seat" => Icons.airline_seat_recline_normal,
      "trwl:ticket" => Symbols.transit_ticket,
      "trwl:travel_class" => Icons.flight_class,
      "trwl:vehicle_number" => Icons.directions_subway,
      "trwl:wagon" => Icons.directions_bus,
      "trwl:wagon_class" => Icons.bus_alert,
      _ => Icons.question_mark,
    });
  }
}
