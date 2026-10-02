import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat_for_day_page.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/ride_info.dart';
import 'package:traewelcross/utils/shared.dart';

class DayStat extends StatelessWidget {
  const DayStat({
    super.key,
    required this.rides,
    required this.currentRideDate,
  });
  final Iterable<Status> rides;
  final DateTime currentRideDate;
  @override
  Widget build(BuildContext context) {
    final points = rides.fold(0, (p, s) => p += s.checkin.points);
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(
        localize.mapPageTitle(
          DateFormat.yMMMEd(
            Localizations.localeOf(context).languageCode,
          ).format(currentRideDate),
        ),
      ),
      body: MapStatForDayPage(
        rideInfo: rides
            .map((rideItem) => RideInfo.fromRides(rideItem))
            .toList(),
        footer: Card(
          child: Padding(
            padding: .all(8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.train),
                  title: Text(localize.checkInCount(rides.length)),
                ),
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: Text(
                    SharedFunctions.getDurationString(
                      rides.fold(0, (d, s) => d += s.checkin.duration),
                      context,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Symbols.kid_star),
                  title: Text(localize.points(points.toString(), points)),
                ),
                ListTile(
                  leading: const Icon(Symbols.distance),
                  title: Text(
                    "${(rides.fold(0.0, (d, s) => d += s.checkin.distance) / 1000).toStringAsFixed(0)} km",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
