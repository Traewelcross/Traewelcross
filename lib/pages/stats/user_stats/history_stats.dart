import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class HistoryStats extends StatefulWidget {
  const HistoryStats({super.key});

  @override
  State<HistoryStats> createState() => _HistoryStatsState();
}

class _HistoryStatsState extends State<HistoryStats>
    with AutomaticKeepAliveClientMixin {
  late Future<StatisticsHistory> stats;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    stats = getIt<ApiService>().statistics.getHistoryStatistics();
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                spacing: 4,
                crossAxisAlignment: .start,
                children: [
                  for (StatisticsHistoryListEntry year in stats.yearly ?? [])
                    Card(
                      clipBehavior: .hardEdge,
                      child: ExpansionTile(
                        clipBehavior: .hardEdge,
                        shape: const Border.fromBorderSide(.new(color: Colors.transparent)),
                        title: Text(year.period),
                        children: [
                          ListTile(
                            leading: const Icon(Symbols.distance),
                            title: Text("${year.distanceKm} km"),
                          ),
                          ListTile(
                            leading: const Icon(Symbols.train),
                            title: Text(
                              localize.checkInCount(year.checkinCount),
                            ),
                          ),
                          for (StatisticsHistoryListEntry month
                              in stats.monthly?.where(
                                    (e) =>
                                        e.period.split("-")[0] == year.period,
                                  ) ??
                                  [])
                            Card(
                              clipBehavior: .hardEdge,
                              color: SharedFunctions.secondCard(context),
                              child: ExpansionTile(
                                clipBehavior: .hardEdge,
                                shape: Border.fromBorderSide(.new(color: Colors.transparent)),
                                title: Text(
                                  localize.monthYear(
                                    DateTime(
                                      int.parse(year.period, radix: 10),
                                      int.parse(
                                        month.period.split("-")[1],
                                        radix: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                children: [
                                  ListTile(
                                    leading: const Icon(Symbols.distance),
                                    title: Text("${month.distanceKm} km"),
                                  ),
                                  ListTile(
                                    leading: const Icon(Symbols.train),
                                    title: Text(
                                      localize.checkInCount(month.checkinCount),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
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
