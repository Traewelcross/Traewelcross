import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DepartureTime extends StatelessWidget {
  const DepartureTime({super.key, required this.planned, required this.real});
  final String planned;
  final String? real;

  @override
  Widget build(BuildContext context) {
    final stationText = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
    final DateTime plannedTime = DateTime.parse(planned);
    final DateTime? realTime = real != null ? DateTime.parse(real!) : null;

    final bool isDelayed =
        realTime != null && !realTime.isAtSameMomentAs(plannedTime);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isDelayed)
              Text(
                DateFormat.Hm(
                  Localizations.localeOf(context).languageCode,
                ).format(realTime.toLocal()),
                style: stationText.copyWith(color: Colors.red),
              ),
            Text(
              DateFormat.Hm(
                Localizations.localeOf(context).languageCode,
              ).format(plannedTime.toLocal()),
              style: isDelayed
                  ? stationText.copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )
                  : stationText,
            ),
          ],
        ),
      ],
    );
  }
}
