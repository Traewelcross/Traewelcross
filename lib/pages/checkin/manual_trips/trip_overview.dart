import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class ManualTripOverview extends StatefulWidget {
  const ManualTripOverview({super.key});

  @override
  State<ManualTripOverview> createState() => _ManualTripOverviewState();
}

class _ManualTripOverviewState extends State<ManualTripOverview> {
  late Future<List<TripResource>> tripsF;

  @override
  void initState() {
    super.initState();
    tripsF = getIt<ApiService>().trip.getManualTrips();
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(localize.manualTripOverviewTitle),
      body: FutureBuilder(
        future: tripsF,
        builder: (ctx, snp) {
          if (snp.connectionState == .waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snp.connectionState == .done) {
            List<TripResource> trips;
            if (snp.data == null) {
              trips = [];
            } else {
              trips = snp.data!;
            }
            return ListView.builder(
              itemCount: trips.length + 1,
              itemBuilder: (ctx, idx) {
                if (idx >= trips.length) {
                  return Column(
                    children: [
                      Divider(),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: Text(localize.manualTripNewTrip),
                      ),
                    ],
                  );
                }
                final trip = snp.data![idx];
                return ListTile(
                  title: Text(
                    "${trip.lineName} (${trip.number}) - ${trip.operator?.name ?? "N/A"}",
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${trip.origin.name} (${trip.stopovers.first.departurePlanned})",
                        ),
                        const WidgetSpan(child: Icon(Icons.arrow_forward)),
                        TextSpan(
                          text:
                              "${trip.destination.name} (${trip.stopovers.last.arrivalPlanned})",
                        ),
                      ],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
