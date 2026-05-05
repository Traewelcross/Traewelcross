import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'dart:convert';

import 'package:traewelcross/components/status_tags.dart';
import 'package:traewelcross/components/tag_icon.dart';
import 'package:traewelcross/utils/api_providers/status_api_provider.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class AddTagDialog extends StatelessWidget {
  const AddTagDialog({
    super.key,
    required this.tags,
    required this.rideId,
    required this.tagCanChange,
    this.tag,
    this.deleteCallback,
    this.addCallback,
  });

  final List tags;
  final int rideId;
  final bool tagCanChange;
  //final String? tagType;
  //final String? tagValue;
  //final TripVisibilityEnum? tagVisibility;
  final Tag? tag;
  final void Function(String key)? deleteCallback;
  final void Function(Tag tag)? addCallback;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width75 = size.width * 0.75;
    return AlertDialog(
      icon: const Icon(Icons.new_label),
      title: Text(AppLocalizations.of(context)!.tagAddTag),
      content: SizedBox(
        width: width75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TagBox(
              tagCanChange: tagCanChange,
              setTags: tags,
              rideId: rideId,
              tag: tag,
              deleteCallback: deleteCallback,
              addCallback: addCallback,
            ),
          ],
        ),
      ),
    );
  }
}

class TagBox extends StatefulWidget {
  const TagBox({
    super.key,
    required this.tagCanChange,
    required this.setTags,
    this.tag,
    this.deleteCallback,
    this.addCallback,
    this.editCallback,
    required this.rideId,
  });
  final bool tagCanChange;
  final List<dynamic> setTags;
  final int rideId;
  //final String? tagValue;
  //final String? tagType;
  //final TripVisibilityEnum? tagVisibility;
  final Tag? tag;
  final void Function(String key)? deleteCallback;
  final void Function(String value)? editCallback;

  final void Function(Tag)? addCallback;
  @override
  State<TagBox> createState() => _TagBoxState();
}

class _TagBoxState extends State<TagBox> {
  static const List<String> _supportedTags = [
    "trwl:journey_number",
    "trwl:locomotive_class",
    "trwl:passenger_rights",
    "trwl:price",
    "trwl:role",
    "trwl:seat",
    "trwl:ticket",
    "trwl:travel_class",
    "trwl:vehicle_number",
    "trwl:wagon",
    "trwl:wagon_class",
  ];
  late List<String> _availableTags;
  String _selected = "";
  TripVisibilityEnum _visibility = TripVisibilityEnum.public;
  final TextEditingController tagText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _availableTags = _supportedTags
        .where((tag) => !widget.setTags.any((setTag) => setTag["key"] == tag))
        .toList();
    if (_availableTags.isNotEmpty) {
      _selected = _availableTags[0];
    }
    if (widget.tag == null) {
      return;
    }
    if (widget.tag!.key != null) {
      _selected = widget.tag!.key!;
    }
    if (widget.tag!.value != null) {
      tagText.text = widget.tag!.value!;
    }
    if (widget.tag!.visibility != null) {
      _visibility = widget.tag!.visibility!;
    }
  }

  String _getLabelText(String tagType, AppLocalizations localize) {
    return switch (tagType) {
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
    };
  }

  String _getExampleHint(String tagType, AppLocalizations localize) {
    return switch (tagType) {
      final key when key == "trwl:journey_number" =>
        localize.tagTipJourneyNumberExample,
      "trwl:locomotive_class" => localize.tagTipLocomotiveClassExample,
      "trwl:passenger_rights" => localize.tagTipPassengerRightsExample,
      "trwl:price" => localize.tagTipPriceExample,
      "trwl:role" => localize.tagTipRoleExample,
      "trwl:seat" => localize.tagTipSeatExample,
      "trwl:ticket" => localize.tagTipTicketExample,
      "trwl:travel_class" => localize.tagTipTravelClassExample,
      "trwl:vehicle_number" => localize.tagTipVehicleNumberExample,
      "trwl:wagon" => localize.tagTipWagonExample,
      "trwl:wagon_class" => localize.tagTipWagonClassExample,
      _ => "",
    };
  }

  String _getVisibilityString(
    TripVisibilityEnum tve,
    AppLocalizations localize,
  ) {
    return switch (tve) {
      final t when t == TripVisibilityEnum.public => localize.public,
      TripVisibilityEnum.private => localize.private,
      TripVisibilityEnum.notListed => localize.notListed,
      TripVisibilityEnum.loggedInUser => localize.loggedInUsers,
      TripVisibilityEnum.followerOnly => localize.followerOnly,
      _ => "?",
    };
  }

  void _submitTag() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.status.submitTag(
      tag: Tag(key: _selected, visibility: _visibility, value: tagText.text),
      rideId: widget.rideId,
    );
    if (!mounted) return;
    if (response != null) {
      widget.addCallback?.call(response);
      Navigator.pop(context);
    }
  }

  void _editTag() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.status.editTag(
      newTag: Tag(key: _selected, visibility: _visibility, value: tagText.text),
      oldTag: widget.tag!,
      rideId: widget.rideId,
    );
    if (!mounted) return;
    if (response != null) {
      widget.deleteCallback?.call(widget.tag!.key!);
      widget.addCallback?.call(response);
      Navigator.pop(context);
    }
  }

  void _deleteTag() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.status.deleteTag(tag: widget.tag!, rideId: widget.rideId);
    if (!mounted) return;
    if (response.wasSuccess) {
      widget.deleteCallback?.call(widget.tag!.key!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    if (widget.tagCanChange && _availableTags.isEmpty) {
      return Text(localize.tagNoTagsLeft);
    }
    return Column(
      spacing: 8,
      children: [
        Row(
          children: [
            if (_availableTags.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  shape: BoxShape.circle,
                ),
                child: PopupMenuButton(
                  enabled: widget.tagCanChange,
                  onSelected: (val) => setState(() {
                    _selected = val;
                  }),
                  icon: TagIcon(tag: _selected),
                  itemBuilder: (BuildContext context) {
                    return _availableTags.map((String tagType) {
                      return PopupMenuItem(
                        value: tagType,
                        child: TagItem(tag: tagType),
                      );
                    }).toList();
                  },
                ),
              ),
            const SizedBox(width: 4),
            Expanded(
              child: TextField(
                controller: tagText,
                decoration: InputDecoration(
                  labelText: _getLabelText(_selected, localize),
                  hintText: _getExampleHint(_selected, localize),
                  border: OutlineInputBorder(),
                  suffixIcon: PopupMenuButton(
                    icon: Icon(_visibility.icon),
                    itemBuilder: (context) {
                      return TripVisibilityEnum.values.map((
                        TripVisibilityEnum tve,
                      ) {
                        return PopupMenuItem(
                          value: tve.value,
                          onTap: () => setState(() {
                            _visibility = tve;
                          }),
                          child: Row(
                            children: [
                              Icon(tve.icon),
                              const SizedBox(width: 4),
                              Text(_getVisibilityString(tve, localize)),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.tagCanChange)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () => _submitTag(),
                  label: Text(localize.save),
                ),
              ),
            ],
          ),
        if (!widget.tagCanChange)
          Row(
            spacing: 4,
            mainAxisSize: MainAxisSize.max,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteTag(),
                label: Text(localize.delete),
              ),
              Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () => _editTag(),
                label: Text(localize.save),
              ),
            ],
          ),
      ],
    );
  }
}
