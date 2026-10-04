import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/ride_quick_view.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class OverviewStats extends StatefulWidget {
  const OverviewStats({super.key, required this.statRange});
  final DateTimeRange<DateTime> statRange;

  @override
  State<OverviewStats> createState() => _OverviewStatsState();
}

class _OverviewStatsState extends State<OverviewStats>
    with AutomaticKeepAliveClientMixin {
  late Future<StatisticsOverview> stats;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    stats = getIt<ApiService>().statistics.getOverviewStatistics(
      widget.statRange,
    );
  }

  @override
  void didUpdateWidget(covariant OverviewStats oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statRange != widget.statRange) {
      _loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    super.build(context);
    return FutureBuilder(
      future: stats,
      builder: (ctx, snp) {
        if (snp.connectionState == .done) {
          if (snp.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.error, color: Colors.redAccent, size: 32),
                  Text(localize.statLoadFail(snp.error!.toString())),
                ],
              ),
            );
          }
          if (snp.hasData) {
            final stats = snp.data!;
            final tT = Theme.of(context).textTheme.bodyLarge!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                spacing: 4,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    localize.statsStatOverviewOverview(
                      widget.statRange.start,
                      widget.statRange.end,
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium!.copyWith(fontWeight: .w500),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        localize.statsStatOverviewOverviewTotalCheckins(
                          stats.totalCheckins,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        localize.statsStatOverviewOverviewActiveDays(
                          stats.activeDays,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        localize.statsStatOverviewOverviewTotalDistance(
                          stats.totalDistanceKm,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        localize.statsStatOverviewOverviewMeanDistance(
                          stats.meanDistanceKm,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    localize.statsStatOverviewLongestDistance,
                    style: tT.copyWith(fontWeight: .bold),
                  ),
                  if (stats.longestCheckinByDistance != null)
                    RideQuickView(
                      rideData: stats.longestCheckinByDistance!,
                      authUserId: 0,
                    )
                  else 
                    Text(
                      localize.statsStatOverviewStatusNotAvailable,
                      textAlign: .center,
                      style: tT.copyWith(fontStyle: .italic),
                    ),
                  Divider(),
                  Text(
                    localize.statsStatOverviewShortestDistance,
                    style: tT.copyWith(fontWeight: .bold),
                  ),
                  if (stats.shortestCheckinByDistance != null)
                    RideQuickView(
                      rideData: stats.shortestCheckinByDistance!,
                      authUserId: 0,
                    )
                  else
                    Text(
                      localize.statsStatOverviewStatusNotAvailable,
                      textAlign: .center,
                      style: tT.copyWith(fontStyle: .italic),
                    ),
                  Divider(),
                  Text(
                    localize.statsStatOverviewLongestTime,
                    style: tT.copyWith(fontWeight: .bold),
                  ),
                  if (stats.longestCheckinByDuration != null)
                    RideQuickView(
                      rideData: stats.longestCheckinByDuration!,
                      authUserId: 0,
                    )
                  else
                    Text(
                      localize.statsStatOverviewStatusNotAvailable,
                      textAlign: .center,
                      style: tT.copyWith(fontStyle: .italic),
                    ),
                  Divider(),
                  Text(
                    localize.statsStatOverviewShortestTime,
                    style: tT.copyWith(fontWeight: .bold),
                  ),
                  if (stats.shortestCheckinByDuration != null)
                    RideQuickView(
                      rideData: stats.shortestCheckinByDuration!,
                      authUserId: 0,
                    )
                  else
                    Text(
                      localize.statsStatOverviewStatusNotAvailable,
                      textAlign: .center,
                      style: tT.copyWith(fontStyle: .italic),
                    ),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                const CircularProgressIndicator(),
                Text(localize.waitForStatsMsgGeneric),
              ],
            ),
          );
        }
        return const SizedBox(height: 0);
      },
    );
  }
}
