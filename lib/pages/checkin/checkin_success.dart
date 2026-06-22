import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/profile_link_button.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/app.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';

class CheckinSuccess extends StatelessWidget {
  const CheckinSuccess({super.key, required this.statusInfo, this.continueSuccess});
  final CheckinResponse statusInfo;
  final bool? continueSuccess;
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final materialLocalize = MaterialLocalizations.of(context);
    return MainScaffold(
      title: AppBarTitle(localize.checkIn),
      backButton: false,
      body: Center(
        child: Builder(
          builder: (context) {
            return ListView(
              shrinkWrap: true,
              children: [
                const Icon(Icons.check_circle, size: 64),
                Text(
                  localize.checkInSuccessful,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  statusInfo.status.checkin.origin.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Icon(Icons.arrow_downward),
                Text(
                  statusInfo.status.checkin.destination.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Symbols.kid_star),
                        const SizedBox(width: 4),
                        Text(
                          localize.points(
                            statusInfo.points.points.toString(),
                            statusInfo.points.points,
                          ),
                        ),
                      ],
                    ),
                    if (statusInfo.points.calculation.reason == 2)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                localize.morePointsNotice,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (statusInfo.status.event != null) ...[
                  const SizedBox(height: 6),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 4),
                        Text(statusInfo.status.event!.name),
                      ],
                    ),
                  ),
                ],
                if (statusInfo.alsoOnThisConnection != null &&
                    statusInfo.alsoOnThisConnection!.isNotEmpty)
                         ...[
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(localize.alsoOnThisConnection),
                      shape: Border.all(color: Colors.transparent),
                      children: [
                        for (var user
                            in statusInfo.alsoOnThisConnection!)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: ProfileLinkButton(
                              user: user.user.promoteToUser(),
                              subTitle:
                                  "${user.checkin.origin.name} -> ${user.checkin.destination.name}",
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 72),
                ],
                if(continueSuccess == true)
                Card.filled(color: Color.alphaBlend(
                    Colors.blue.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.surface,
                  ),child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.info),
                        SizedBox(width: 8,),
                        Expanded(child: Text(localize.secondCheckInSuccess)),
                      ],
                    ),
                  ),),
                if(continueSuccess == false)
                Card.filled(color: Color.alphaBlend(
                    Colors.red.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.surface,
                  ), child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.error),
                        SizedBox(width: 8,),

                        Expanded(child: Text(localize.secondCheckInFailure)),
                      ],
                    ),
                  ))

              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Chrome()),
          (Route<dynamic> route) => false,
        ),
        icon: const Icon(Icons.check),
        label: Text(materialLocalize.closeButtonLabel),
      ),
    );
  }
}
