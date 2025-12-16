import 'package:flutter/material.dart';
import 'package:traewelcross/dialogs/add_tag_dialog.dart';
import 'package:traewelcross/components/tag_icon.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class StatusTag extends StatelessWidget {
  const StatusTag({
    super.key,
    required this.tag,
    required this.rideId,
    required this.deleteCallback,
    this.addCallback,
    required this.canEdit,
  });
  final Map<String, dynamic> tag;
  final int rideId;
  final void Function(String key) deleteCallback;
  final void Function(Map<String, dynamic> data)? addCallback;
  final bool canEdit;
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      message: switch (tag["key"]) {
        final key when key == "trwl:journey_number" =>
          localize.tagTipJourneyNumber,
        "trwl:locomotive_class" => localize.tagTipLocomotiveClass,
        "trwl:passenger_rights" => localize.tagTipPassengerRights,
        "trwl:price" => localize.tagTipPrice,
        "trwl:role" => localize.tagTipRole,
        "trwl:seat" => localize.tagTipSeat,
        "trwl:ticket" => localize.tagTipTicket,
        "trwl:travel_class" => localize.tagTipTravelClass,
        "trwl:vehicle_number" => localize.tagTipVehicleNumber,
        "trwl:wagon" => localize.tagTipWagon,
        "trwl:wagon_class" => localize.tagTipWagonClass,
        _ => localize.tagUnknownTip(tag["key"]),
      },
      child: GestureDetector(
        onTap: canEdit
            ? () {
                showDialog(
                  context: context,
                  builder: (context) => AddTagDialog(
                    tags: [],
                    rideId: rideId,
                    tagCanChange: false,
                    tagType: tag["key"],
                    tagValue: tag["value"],
                    tagVisibility: TripVisibilityEnum.fromValue(
                      tag["visibility"],
                    ),
                    deleteCallback: deleteCallback,
                    addCallback: addCallback,
                  ),
                );
              }
            : null,
        child: Chip(
          avatar: TagIcon(tag: tag["key"]),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          labelPadding: const EdgeInsets.symmetric(horizontal: 2),
          label: Text(tag["value"]),
        ),
      ),
    );
  }
}
