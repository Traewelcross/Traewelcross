import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_info.dart';
import 'package:traewelcross/utils/shared.dart';

class MapStatForUser extends StatefulWidget {
  const MapStatForUser({super.key});

  @override
  State<MapStatForUser> createState() => _MapStatForUserState();
}

class _MapStatForUserState extends State<MapStatForUser> {
  DateTimeRange statRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 7)),
    end: DateTime.now(),
  );
  late Future<List<RideInfo>> rides;

  @override
  void initState() {
    super.initState();
    rides = _getRidesForUser();
  }
  Future<List<RideInfo>> _getRidesForUser(){
    final alt = getIt<Config>().behavior.alternativePolylineFetcher;
    rides = getIt<ApiService>().statistics.getPolylines(range: statRange, alternative: alt);
    return rides;
  }
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return FutureBuilder<List<RideInfo>>(
      future: rides,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return SingleChildScrollView(
            child: Text(asyncSnapshot.error!.toString()),
          );
        }
        if (asyncSnapshot.connectionState == .waiting) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                CircularProgressIndicator(),
                Text(localize.waitForStatsMsg, textAlign: .center),
              ],
            ),
          );
        }
        if (asyncSnapshot.connectionState == .done) {
          return Column(
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final rangeSelect = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now(),
                    initialDateRange: DateTimeRange(
                      start: DateTime.now().subtract(Duration(days: 28)),
                      end: DateTime.now(),
                    ),
                    currentDate: DateTime.now(),
                  );
                  if (rangeSelect == null) {
                    return;
                  }
                  setState(() {
                    statRange = rangeSelect;
                    rides = _getRidesForUser();
                  });
                },
                label: Text(
                  localize.dateSpan(
                    DateFormat.yMMMEd(
                      Localizations.localeOf(context).languageCode,
                    ).format(statRange.start),
                    DateFormat.yMMMEd(
                      Localizations.localeOf(context).languageCode,
                    ).format(statRange.end),
                  ),
                ),
                icon: const Icon(Icons.calendar_month),
              ),
              SizedBox(height: 8),
              Expanded(child: MapStat(rides: asyncSnapshot.data!)),
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}
