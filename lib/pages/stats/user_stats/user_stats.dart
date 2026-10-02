import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/stats/user_stats/favorite_stats.dart';
import 'package:traewelcross/pages/stats/user_stats/history_stats.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat_for_user.dart';
import 'package:traewelcross/pages/stats/user_stats/overview_stats.dart';

class UserStats extends StatefulWidget {
  const UserStats({super.key});

  @override
  State<UserStats> createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  DateTimeRange statRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Column(
      children: [
        DateSelectButton(
          statRange: statRange,
          onNewDate: (r) {
            setState(() => statRange = r);
          },
        ),
        Expanded(
          child: ListView(
            children: [
              Text(localize.statsStatOverviewOverviewTitle, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: .bold), textAlign: .center,),
              const Divider(height: 16, thickness: 3,),
              OverviewStats(statRange: statRange),
              const Divider(height: 16, thickness: 3,),
              Text(localize.statsStatFavoritesTitle, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: .bold), textAlign: .center,),
              Text(localize.statsStatFavoritesSubtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: .center,),
              const Divider(height: 16, thickness: 3,),
              FavoriteStats(statRange: statRange),
              const Divider(height: 16, thickness: 3,),
              Text(localize.statsStatHistoryTitle, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: .bold), textAlign: .center,),
              const Divider(height: 16, thickness: 3,),
              const HistoryStats()
            ],
          )
        ),
      ],
    );
  }
}