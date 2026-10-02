import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class FavoriteStats extends StatefulWidget {
  const FavoriteStats({super.key, required this.statRange});
  final DateTimeRange<DateTime> statRange;

  @override
  State<FavoriteStats> createState() => _FavoriteStatsState();
}

class _FavoriteStatsState extends State<FavoriteStats>
    with AutomaticKeepAliveClientMixin {
  late Future<StatisticsFavorites> stats;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    stats = getIt<ApiService>().statistics.getFavoritesStatistics(
      widget.statRange,
    );
  }

  @override
  void didUpdateWidget(covariant FavoriteStats oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statRange != widget.statRange) {
      setState(() {
        _loadStats();
      });
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
                    localize.statsStatFavortiesStops,
                    style: tT.copyWith(fontWeight: .bold),
                  ),
                  if (stats.stations == null || stats.stations!.isEmpty)
                    Text(
                      localize.statsStatFavoritesNotAvailable,
                      textAlign: .center,
                      style: tT.copyWith(fontStyle: .italic),
                    )
                  else
                    Column(
                      children: List.generate(
                        stats.stations!.length,
                        (idx) => Card(
                          child: ListTile(
                            leading: Text("${idx + 1}."),
                            title: Text(
                              "${stats.stations![idx].name} (${stats.stations![idx].count.toString()})",
                            ),
                          ),
                        ),
                      ),
                    ),
                  Text(
                    localize.statsStatFavortiesLines,
                    style: tT.copyWith(fontWeight: .bold),
                  ),
                  if (stats.lines == null || stats.lines!.isEmpty)
                    Text(
                      localize.statsStatFavoritesNotAvailable,
                      textAlign: .center,
                      style: tT.copyWith(fontStyle: .italic),
                    )
                  else
                    Column(
                      children: List.generate(
                        stats.lines!.length,
                        (idx) => Card(
                          child: ListTile(
                            leading: Text("${idx + 1}."),
                            title: Text(
                              "${stats.lines![idx].linename} (${stats.lines![idx].count.toString()} - ${stats.lines![idx].distanceKm.toString()} km)",
                            ),
                          ),
                        ),
                      ),
                    ),
                  Text(
                    localize.statsStatFavortiesRoutes,
                    style: tT.copyWith(fontWeight: .bold),
                  ),
                  if (stats.routes == null || stats.routes!.isEmpty)
                    Text(
                      localize.statsStatFavoritesNotAvailable,
                      textAlign: .center,
                      style: tT.copyWith(fontStyle: .italic),
                    )
                  else
                    Column(
                      children: List.generate(
                        stats.routes!.length,
                        (idx) => Card(
                          child: ListTile(
                            leading: Text("${idx + 1}."),
                            title: Text(
                              "${stats.routes![idx].origin} - ${stats.routes![idx].destination} (${stats.routes![idx].count.toString()} - ${stats.routes![idx].distanceKm.toString()} km)",
                            ),
                          ),
                        ),
                      ),
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
