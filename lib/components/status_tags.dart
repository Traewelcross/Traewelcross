import 'package:flutter/material.dart';
import 'package:traewelcross/dialogs/add_tag_dialog.dart';
import 'package:traewelcross/components/status_tag.dart';
import 'package:traewelcross/components/tag_icon.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class StatusTags extends StatelessWidget {
  const StatusTags({
    super.key,
    required this.tags,
    required this.canAdd,
    required this.rideId,
    required this.onAddTag,
    required this.onDeleteTag,
  });
  final List<dynamic> tags;
  final bool canAdd;
  final int rideId;
  final Function(Map<String, dynamic> data) onAddTag;
  final Function(String key) onDeleteTag;

  @override
  Widget build(BuildContext context) {
    final tagsList = [
      if (canAdd)
        ActionChip(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddTag(
              tags: tags,
              rideId: rideId,
              addCallback: (data) {
                onAddTag(data);
              },
            ),
          ),
          label: Text(AppLocalizations.of(context)!.tagAddTag),
          avatar: const Icon(Icons.new_label),
        ),
      ...tags.map((tag) {
        return StatusTag(
          tag: tag,
          rideId: rideId,
          key: ValueKey(tag["key"]),
          deleteCallback: (key) {
            onDeleteTag(key);
          },
          addCallback: (data) {
            onAddTag(data);
          },
          canEdit: canAdd,
        );
      }),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(spacing: 4, children: tagsList),
    );
  }
}

class AddTag extends StatelessWidget {
  const AddTag({
    super.key,
    required this.tags,
    required this.rideId,
    required this.addCallback,
  });
  final List<dynamic> tags;
  final int rideId;
  final Function(Map<String, dynamic> data) addCallback;
  @override
  Widget build(BuildContext context) {
    return AddTagDialog(
      tags: tags,
      rideId: rideId,
      tagCanChange: true,
      addCallback: addCallback,
    );
  }
}

class TagItem extends StatelessWidget {
  const TagItem({super.key, required this.tag});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Row(
      children: [
        TagIcon(tag: tag),
        const SizedBox(width: 8),
        Text(switch (tag) {
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
          _ => "",
        }),
      ],
    );
  }
}
