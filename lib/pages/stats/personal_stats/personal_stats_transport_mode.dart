import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/shared.dart';

class PersonalStatsTransportMode extends StatelessWidget {
  const PersonalStatsTransportMode({super.key, required this.stats});
  final StatisticsPersonal stats;

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        spacing: 4,
        //runSpacing: 4,
        children: [
          for (var s in stats.categories!)
            Card(
              margin: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: .start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.copyWith(fontWeight: .bold),
                        children: [
                          WidgetSpan(
                            alignment: .middle,
                            child: RideIconTag(
                              iconInfo: .new(width: 24, category: s.name.value),
                            ),
                          ),
                          TextSpan(
                            text: switch (s.name) {
                              final cat when cat == .express =>
                                localize.national,
                              .regional => localize.regional,
                              .tram => localize.tram,
                              .subUrban => localize.suburban,
                              .bus => localize.bus,
                              .ferry => localize.ferry,
                              .subway => localize.subway,
                              .plane => localize.plane,
                              .freightTrain => localize.freightTrain,
                              .nationalExpress =>
                                localize.filterTravelTypesHighSpeed,
                              .taxi => localize.taxi,
                              .express => localize.national,
                              .national => localize.national,
                              .regionalExp => localize.filterTravelTypesIR,
                              .all => "",
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
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
                            RideIconTag(
                              iconInfo: .new(width: 24, category: s.name.value),
                            ),
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
