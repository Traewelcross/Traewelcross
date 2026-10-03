import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/stats/personal_stats/personal_stats_operator.dart';
import 'package:traewelcross/pages/stats/personal_stats/personal_stats_purpose.dart';
import 'package:traewelcross/pages/stats/personal_stats/personal_stats_transport_mode.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat_for_user.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class PersonalStatsWrap extends StatefulWidget {
  const PersonalStatsWrap({super.key});

  @override
  State<PersonalStatsWrap> createState() => _PersonalStatsWrapState();
}

class _PersonalStatsWrapState extends State<PersonalStatsWrap> {
  DateTimeRange statRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
  late Future<StatisticsPersonal> statistic;
    @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    statistic = getIt<ApiService>().statistics.getPersonalStatistics(statRange);
  }
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Column(
      children: [
        DateSelectButton(
          statRange: statRange,
          onNewDate: (r) {
            setState((){statRange = r; _loadStats();});
          },
        ),
        Expanded(
          child: FutureBuilder(
            future: statistic,
            builder: (ctx, snp) {
              if (snp.connectionState == .done) {
                if (snp.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      mainAxisSize: .min,
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.redAccent,
                          size: 32,
                        ),
                        Text(localize.statLoadFail(snp.error!.toString())),
                      ],
                    ),
                  );
                }
                if (snp.hasData) {
                  final stats = snp.data!;
                  return ListView(
                    children: [
                      Text(
                        localize.filterTravelTypes,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge!.copyWith(fontWeight: .bold),
                        textAlign: .center,
                      ),
                      const Divider(height: 16, thickness: 3),
                      PersonalStatsTransportMode(stats: stats),
                      const Divider(height: 16, thickness: 3),
                      Text(
                        localize.filterTravelPurpose,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge!.copyWith(fontWeight: .bold),
                        textAlign: .center,
                      ),
                      const Divider(height: 16, thickness: 3),
                      PersonalStatsPurpose(stats: stats),
                      const Divider(height: 16, thickness: 3),
                                            Text(
                        localize.operator,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge!.copyWith(fontWeight: .bold),
                        textAlign: .center,
                      ),
                      const Divider(height: 16, thickness: 3),
PersonalStatsOperator(stats: stats)
                    ],
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
          ),
        ),
      ],
    );
  }
}
