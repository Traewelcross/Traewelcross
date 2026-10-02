import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/enums/trip_type.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/shared.dart';

class PersonalStatsPurpose extends StatelessWidget {
  const PersonalStatsPurpose({super.key, required this.stats});
  final StatisticsPersonal stats;

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (var s in stats.purpose!)
            Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  spacing: 4,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        Icon(TripType.fromValue(s.name).icon),
                        Text(
                          switch (s.name) {
                            final pur when pur == 0 => localize.private,
                            1 => localize.businessTrip,
                            2 => localize.commuteTrip,
                            _ => "???",
                          },
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: .bold),
                        ),
                      ],
                    ),
                    Card(
                      color: SharedFunctions.secondCard(context),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 4,
                          mainAxisSize: .max,
                          children: [
                            const Icon(Icons.timer_outlined),
                            Text(
                              SharedFunctions.getDurationString(
                                s.duration,
                                context,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: SharedFunctions.secondCard(context),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 4,
                          mainAxisSize: .max,
                          children: [
                            Icon(TripType.fromValue(s.name).icon),
                            Text(localize.checkInCount(s.count)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
