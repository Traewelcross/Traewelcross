import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:share_plus/share_plus.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/pride_gradient.dart';
import 'package:traewelcross/components/profile_picture.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/components/status_tags.dart';
import 'package:traewelcross/components/time_progress.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/pages/detailed_ride_view.dart';
import 'package:traewelcross/pages/checkin/checkin.dart';
import 'package:traewelcross/enums/trip_type.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/profile_view.dart';
import 'package:traewelcross/pages/checkin/select_connection.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/check_in_info.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/api_providers/status_api_provider.dart';
import 'dart:async';

import 'package:traewelcross/utils/time_span.dart';

class RideQuickView extends StatefulWidget {
  const RideQuickView({
    super.key,
    required this.rideData,
    required this.authUserId,
    this.detailedView,
    this.likeCallback,
    this.onDelete,
  });
  final Status rideData;
  final int authUserId;
  final bool? detailedView;
  final Function()? likeCallback;
  final Function()? onDelete;
  @override
  State<RideQuickView> createState() => _RideQuickViewState();
}

class _RideQuickViewState extends State<RideQuickView> {
  late Status _rideData;
  static const _volChan = MethodChannel("volume");
  @override
  void initState() {
    super.initState();
    _rideData = widget.rideData;
    if (widget.detailedView == true) {
      _volChan.setMethodCallHandler((call) {
        if (call.method == "volumePressed") {
          if (call.arguments == "up") {
            _updateTime(TimeOfDay.now(), false);
          } else if (call.arguments == "down") {
            _updateTime(TimeOfDay.now(), true);
          }
        }
        return Future.value(null);
      });
    }
  }

  void _updateRideData(Status newRideData) {
    setState(() {
      _rideData = newRideData;
    });
  }

  Future<void> _updateLikes() async {
    final apiService = getIt<ApiService>();
    try {
      final LikeCountResponse res;
      if (!_rideData.liked) {
        if (!_rideData.isLikable) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.notLikeable)),
          );
          return;
        }
        res = await apiService.status.like(_rideData.id, _rideData.likes);
      } else {
        res = await apiService.status.unlike(_rideData.id, _rideData.likes);
      }
      if (!mounted) return;
      _rideData.liked = res.wasSuccess;
      _rideData.likes = res.newCount;
      widget.likeCallback?.call();
      _updateRideData(_rideData);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.genericErrorSnackBar} $e',
          ),
        ),
      );
    }
  }

  Future<void> _updateTime(TimeOfDay? newTime, bool isDestination) async {
    DateTime time = DateTime.now();
    if (newTime != null) {
      final DateTime updatedDateTime = DateTime(
        time.year,
        time.month,
        time.day,
        newTime.hour,
        newTime.minute,
      );

      final apiService = getIt<ApiService>();
      final Map<String, dynamic> payload;

      if (isDestination) {
        payload = {
          "manualArrival": updatedDateTime.toUtc().toIso8601String(),
          "visibility": _rideData.visibility,
          "business": _rideData.business,
          "body": _rideData.body,
        };
      } else {
        payload = {
          "manualDeparture": updatedDateTime.toUtc().toIso8601String(),
          "visibility": _rideData.visibility,
          "business": _rideData.business,
          "body": _rideData.body,
        };
      }

      try {
        final updatedRideData = await apiService.status.update(
          _rideData.id,
          payload,
        );
        if (updatedRideData != null && mounted) {
          _updateRideData(updatedRideData);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.genericErrorSnackBar} $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteStatus() async {
    final apiService = getIt<ApiService>();
    final success = await apiService.status.delete(widget.rideData.id);
    if (success && mounted) {
      if (widget.detailedView ?? false) {
        Navigator.pop(context);
      } else {
        widget.onDelete?.call();
      }
    }
  }

  Future<void> _shareRide() async {
    SharePlus.instance.share(
      ShareParams(
        text: "https://traewelling.de/status/${widget.rideData.id} #Träwelling",
      ),
    );
  }

  Widget _parseBodyText(String body, List<Mention> bodyMentions) {
    // This works for now, can't for the life of me figure out how to use API provided Info, so manual detection it is
    RegExp regExp = RegExp(r'@\w+');
    List<TextSpan> result = [];
    int lastMatchEnd = 0;
    if ((bodyMentions as List).isEmpty) {
      return Text(body);
    }
    for (RegExpMatch match in regExp.allMatches(body)) {
      if (match.start > lastMatchEnd) {
        result.add(TextSpan(text: body.substring(lastMatchEnd, match.start)));
      }
      result.add(
        TextSpan(
          text: match.group(0)!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScaffold(
                    title: AppBarTitle(match.group(0)!),
                    body: ProfileView(
                      isOtherUser: true,
                      username: match.group(0)!.replaceAll("@", ""),
                      tempScrollController: true,
                      scrollController: ScrollController(),
                    ),
                  ),
                ),
              );
            },
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < body.length) {
      result.add(TextSpan(text: body.substring(lastMatchEnd)));
    }
    return RichText(
      text: TextSpan(
        children: result,
        style: TextStyle(
          fontFamily: "Outfit",
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  void _openReport(int id) {
    TextEditingController controller = TextEditingController();
    String reason = "inappropriate";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(AppLocalizations.of(context)!.reportBoxTitle),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownMenu(
                initialSelection: "inappropriate",
                onSelected: (value) => reason = value ?? "inappropriate",
                label: Text(
                  AppLocalizations.of(context)!.reportBoxReportReason,
                ),
                requestFocusOnTap: false,
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: "inappropriate",
                    leadingIcon: const Icon(Icons.sentiment_very_dissatisfied),
                    label: AppLocalizations.of(
                      context,
                    )!.reportBoxReportReasonInappropriate,
                  ),
                  DropdownMenuEntry(
                    value: "implausible",
                    leadingIcon: const Icon(Icons.question_mark),
                    label: AppLocalizations.of(
                      context,
                    )!.reportBoxReportReasonImplausible,
                  ),
                  DropdownMenuEntry(
                    value: "spam",
                    leadingIcon: const Icon(Icons.report),
                    label: AppLocalizations.of(
                      context,
                    )!.reportBoxReportReasonSpam,
                  ),
                  DropdownMenuEntry(
                    value: "illegal",
                    leadingIcon: const Icon(Icons.gavel),
                    label: AppLocalizations.of(
                      context,
                    )!.reportBoxReportReasonIllegal,
                  ),
                  DropdownMenuEntry(
                    value: "other",
                    leadingIcon: const Icon(Icons.more),
                    label: AppLocalizations.of(
                      context,
                    )!.reportBoxReportReasonOther,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: null,
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    AppLocalizations.of(context)!.reportBoxDescriptionTitle,
                  ),
                ),
                minLines: 1,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.reportCancel),
            ),
            TextButton(
              onPressed: () => _sendReport(reason, controller.text),
              child: Text(AppLocalizations.of(context)!.reportConfirm),
            ),
          ],
        );
      },
    );
  }

  void _sendReport(String reason, String desc) async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.reportSending),
        duration: Durations.short2,
      ),
    );
    final apiService = getIt<ApiService>();
    await apiService.status.report(
      id: _rideData.id,
      reason: reason,
      description: desc,
    );
  }

  void _copyCheckIn(Status status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CheckIn(
          checkInInfo: CheckInInfo(
            destination: status.checkin.destination.name,
            destinationId: status.checkin.destination.id,
            departureId: status.checkin.origin.id,
            tripId: status.checkin.hafasId,
            lineName: status.checkin.lineName,
            category: status.checkin.category,
            departureTime: status.checkin.origin.departurePlanned,
            arrivalTime: status.checkin.destination.arrivalPlanned,
            event: status.event,
          ),
          isEdit: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: (widget.detailedView == true)
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedRideView(
                            rideData: _rideData,
                            authUserId: widget.authUserId,
                          ),
                        ),
                      );
                    },
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StationText(
                      transportData: _rideData.checkin,
                      isDestination: false,
                      onUpdateTime: _updateTime,
                      isAuthUser: _isAuthUser(),
                    ),
                    Card(
                      color: SharedFunctions.secondCard(context),
                      child: LayoutBuilder(
                        builder: (ctx, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline),
                                    const SizedBox(
                                      height: 24,
                                      child: VerticalDivider(),
                                    ),
                                    RideIconTag(
                                      iconInfo: RideIconTagInfo(
                                        category: _rideData.checkin.category,
                                        width: 24,
                                        lineName: _rideData.checkin.lineName,
                                        operatorIdentifier:
                                            SharedFunctions.getOperatorHAFASIdent(
                                              _rideData
                                                  .checkin
                                                  .operator
                                                  ?.identifiers,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                      child: VerticalDivider(),
                                    ),
                                    const Icon(Icons.timer_outlined),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getNeededTime(
                                        _rideData.checkin.duration,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                      child: VerticalDivider(),
                                    ),
                                    const Icon(Symbols.distance),
                                    const SizedBox(width: 4),
                                    Text(
                                      ((_rideData.checkin.distance / 1000)
                                                  .toStringAsFixed(0) ==
                                              "0")
                                          ? "${_rideData.checkin.distance} m"
                                          : "${(_rideData.checkin.distance / 1000).toStringAsFixed(0)} km",
                                    ),
                                    const SizedBox(
                                      height: 20,
                                      child: VerticalDivider(),
                                    ),
                                    switch (_rideData.business) {
                                      .private => const Icon(Icons.home),
                                      .business => const Icon(Icons.work),
                                      .commute => const Icon(Icons.home_work),
                                    },
                                    if (_rideData.event != null) ...[
                                      const SizedBox(
                                        height: 20,
                                        child: VerticalDivider(),
                                      ),
                                      const Icon(Icons.calendar_month),
                                      const SizedBox(width: 4),
                                      Text(_rideData.event!.name),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_rideData.body != "")
                      Card(
                        color: SharedFunctions.secondCard(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.format_quote),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _parseBodyText(
                                  _rideData.body,
                                  _rideData.bodyMentions,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    _StationText(
                      transportData: _rideData.checkin,
                      isDestination: true,
                      onUpdateTime: _updateTime,
                      isAuthUser: _isAuthUser(),
                    ),
                    const SizedBox(height: 4),
                    TimeProgress(
                      startDate: DateTime.parse(
                        (_rideData.checkin.manualDeparture ??
                            _rideData.checkin.origin.departureReal ??
                            _rideData.checkin.origin.departurePlanned ??
                            "1970-01-01"),
                      ).toLocal(),
                      endDate: DateTime.parse(
                        (_rideData.checkin.manualArrival ??
                            _rideData.checkin.destination.arrivalReal ??
                            _rideData.checkin.destination.departurePlanned ??
                            "1970-01-01"),
                      ).toLocal(),
                      rideId: _rideData.id,
                    ),
                    const SizedBox(height: 8),
                    StatusTags(
                      tags: _rideData.tags,
                      canAdd: _isAuthUser(),
                      rideId: _rideData.id,
                      onAddTag: _addTag,
                      onDeleteTag: _deleteTag,
                    ),
                    const Divider(indent: 0, endIndent: 0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        LikeButton(
                          rideData: _rideData,
                          onUpdateLikes: _updateLikes,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ProfilePicture(
                                imageUrl: _rideData.user.profilePicture,
                                maxWidth: 42,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.zero,
                                    ),
                                    minimumSize: WidgetStatePropertyAll(
                                      Size.zero,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScaffold(
                                          title: AppBarTitle(
                                            _rideData.user.displayName,
                                          ),
                                          body: ProfileView(
                                            isOtherUser: true,
                                            username: _rideData.user.username,
                                            tempScrollController: true,
                                            scrollController:
                                                ScrollController(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${_rideData.user.displayName}, ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(DateTime.parse(_rideData.createdAt).toLocal())}",
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                                child: VerticalDivider(),
                              ),
                              switch (_rideData.visibility) {
                                .public => const Icon(Icons.public),
                                .notListed => const Icon(Icons.link),
                                .followerOnly => const Icon(Icons.group),
                                .private => const Icon(Icons.lock),
                                .loggedInUser => const Icon(
                                  Symbols.shield_person,
                                ),
                              },
                              const SizedBox(
                                height: 24,
                                child: VerticalDivider(),
                              ),
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert, size: 24),
                                style: ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.zero,
                                  ),
                                  minimumSize: WidgetStatePropertyAll(
                                    Size.zero,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                ),
                                itemBuilder: (context) => <PopupMenuEntry>[
                                  if (_isAuthUser()) ...[
                                    PopupMenuItem(
                                      onTap: () => _shareRide(),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.share),
                                          const SizedBox(width: 8),
                                          Text(localize.share),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CheckIn(
                                                checkInInfo: CheckInInfo(
                                                  departureId: _rideData
                                                      .checkin
                                                      .origin
                                                      .id,
                                                  destination: _rideData
                                                      .checkin
                                                      .destination
                                                      .name,
                                                  destinationId: _rideData
                                                      .checkin
                                                      .destination
                                                      .id,
                                                  rideId: _rideData.id,
                                                  body: _rideData.body,
                                                  visibility:
                                                      _rideData.visibility,
                                                  tripType: _rideData.business,
                                                  tripId:
                                                      _rideData.checkin.hafasId,
                                                  category: _rideData
                                                      .checkin
                                                      .category,
                                                  lineName: _rideData
                                                      .checkin
                                                      .lineName,
                                                  event: _rideData.event,
                                                  manualArrive: _rideData
                                                      .checkin
                                                      .manualArrival,
                                                  manualDepart: _rideData
                                                      .checkin
                                                      .manualDeparture,
                                                  departureTime: _rideData
                                                      .checkin
                                                      .origin
                                                      .departurePlanned,
                                                  arrivalTime: _rideData
                                                      .checkin
                                                      .destination
                                                      .arrivalPlanned,
                                                  rideDataCallback:
                                                      (rideData) =>
                                                          _updateRideData(
                                                            rideData,
                                                          ),
                                                ),
                                                isEdit: true,
                                              ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.edit),
                                          const SizedBox(width: 8),
                                          Text(localize.edit),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        if (getIt<Config>()
                                            .behavior
                                            .confirmDelete) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              icon: const Icon(Icons.delete),
                                              title: Text(localize.delete),
                                              content: Text(
                                                localize.areYouSure,
                                                textAlign: TextAlign.center,
                                              ),
                                              actions: [
                                                TextButton.icon(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  label: Text(localize.no),
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                  ),
                                                ),
                                                FilledButton.icon(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _deleteStatus();
                                                  },
                                                  label: Text(localize.yes),
                                                  icon: const Icon(Icons.check),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          _deleteStatus();
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.delete),
                                          const SizedBox(width: 8),
                                          Text(localize.delete),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    PopupMenuItem(
                                      onTap: () => _copyCheckIn(_rideData),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.group_add),
                                          const SizedBox(width: 8),
                                          Text(localize.join_ride),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () => _openReport(_rideData.id),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.report),
                                          const SizedBox(width: 8),
                                          Text(localize.report),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Status is by logged in User
  bool _isAuthUser() {
    return _rideData.user.id == widget.authUserId;
  }

  void _addTag(Tag newTag) {
    setState(() {
      _rideData.tags.add(newTag);
    });
  }

  void _deleteTag(String key) {
    setState(() {
      _rideData.tags.removeWhere((tag) => tag.key == key);
    });
  }

  String _getNeededTime(int duration) {
    TimeSpan ts = SharedFunctions.parseDuration(duration);
    String concatString = "";
    if (ts.days != 0) {
      concatString += "${ts.days}${AppLocalizations.of(context)!.abrvDay}";
    }
    if (ts.hours != 0) {
      concatString += " ${ts.hours}${AppLocalizations.of(context)!.abrvHour}";
    }
    if (ts.minutes != 0) {
      concatString +=
          " ${ts.minutes}${AppLocalizations.of(context)!.abrvMinute}";
    }
    return concatString.trim();
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.rideData,
    required this.onUpdateLikes,
  });
  final Status rideData;
  final Function() onUpdateLikes;
  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (getIt<Config>().appearance.isPrideActive) ...[
          TextButton.icon(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
              minimumSize: WidgetStatePropertyAll(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () =>
                widget.rideData.isLikable ? widget.onUpdateLikes() : null,
            icon: PrideGradient(
              rotation: 90,
              child: (widget.rideData.liked
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      opticalSize: 24,
                      size: 24,
                    )
                  : const Icon(
                      Icons.favorite_outline_outlined,
                      color: Colors.red,
                      opticalSize: 24,
                      size: 24,
                    )),
            ),
            label: Text(
              widget.rideData.likes.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ] else ...[
          TextButton.icon(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
              minimumSize: WidgetStatePropertyAll(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () =>
                widget.rideData.isLikable ? widget.onUpdateLikes() : null,
            icon: widget.rideData.liked
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    opticalSize: 24,
                    size: 24,
                  )
                : const Icon(
                    Icons.favorite_outline_outlined,
                    color: Colors.red,
                    opticalSize: 24,
                    size: 24,
                  ),
            label: Text(
              widget.rideData.likes.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ],
    );
  }
}

class _StationText extends StatelessWidget {
  const _StationText({
    required this.transportData,
    required this.isDestination,
    required this.onUpdateTime,
    required this.isAuthUser,
  });

  final Transport transportData;
  final bool isDestination;
  final Function(TimeOfDay?, bool) onUpdateTime;
  final bool isAuthUser;

  @override
  Widget build(BuildContext context) {
    final hideOnTimeOverride =
        getIt<Config>().behavior.hideManualOnTimeOverride;
    DateTime time;
    DateTime? plannedTime;
    bool timeDifference;
    String? manualTimeStr;
    String plannedTimeStr;
    String? realTimeStr;
    bool isDelayed;
    final stationText = TextStyle(
      fontSize: 21,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
    );
    if (isDestination) {
      manualTimeStr = transportData.manualArrival;
      plannedTimeStr = transportData.destination.arrivalPlanned!;
      isDelayed = transportData
          .destination
          .isArrivalDelayed; //rideData["destination"]["isArrivalDelayed"];
      realTimeStr = transportData.destination.arrivalReal;
    } else {
      manualTimeStr = transportData.manualDeparture;
      plannedTimeStr = transportData.origin.departurePlanned!;
      isDelayed = transportData
          .origin
          .isDepartureDelayed; //rideData["origin"]["isDepartureDelayed"];
      realTimeStr = transportData.origin.departureReal;
    }
    time = DateTime.parse(manualTimeStr ?? realTimeStr ?? plannedTimeStr);

    if (manualTimeStr != null) {
      if (hideOnTimeOverride && manualTimeStr == plannedTimeStr) {
        timeDifference = false;
      } else {
        timeDifference = true;
      }
    } else {
      timeDifference = isDelayed;
    }
    if (timeDifference) {
      plannedTime = DateTime.parse(plannedTimeStr);
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        if (isDestination)
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SelectConnection(
                      stationId: transportData.destination.id,
                      stationName: transportData.destination.name,
                    ),
                  ),
                );
              },
              child: Text(transportData.destination.name, style: stationText),
            ),
          ),
        if (!isDestination)
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SelectConnection(
                      stationId: transportData.origin.id,
                      stationName: transportData.origin.name,
                    ),
                  ),
                );
              },
              child: Text(transportData.origin.name, style: stationText),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
                minimumSize: WidgetStatePropertyAll(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              onPressed: () {
                final config = getIt<Config>();
                if (isAuthUser && config.behavior.overrideOnTimeTap) {
                  TimeOfDay initTime = TimeOfDay.fromDateTime(DateTime.now());
                  // Allow 0 as a valid override value, disable only on negative
                  if (config.behavior.delaySystemTimeOverride >= 0) {
                    final plannedDateTime = DateTime.parse(
                      isDestination
                          ? transportData.destination.arrivalPlanned!
                          : transportData.origin.departurePlanned!,
                    ).toLocal();

                    final thresholdDateTime = plannedDateTime.add(
                      Duration(
                        minutes: config.behavior.delaySystemTimeOverride,
                      ),
                    );

                    if (DateTime.now().isAfter(thresholdDateTime)) {
                      initTime = TimeOfDay.fromDateTime(plannedDateTime);
                    }
                  }
                  if (transportData.manualArrival != null && isDestination) {
                    initTime = TimeOfDay.fromDateTime(
                      DateTime.parse(transportData.manualArrival!).toLocal(),
                    );
                  }
                  if (transportData.manualDeparture != null && !isDestination) {
                    initTime = TimeOfDay.fromDateTime(
                      DateTime.parse(transportData.manualDeparture!).toLocal(),
                    );
                  }
                  showTimePicker(
                    context: context,
                    initialTime: initTime,
                  ).then((val) => onUpdateTime(val, isDestination));
                } else {
                  if (isDestination) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectConnection(
                          stationId: transportData.destination.id,
                          stationName: transportData.destination.name,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectConnection(
                          stationId: transportData.origin.id,
                          stationName: transportData.origin.name,
                        ),
                      ),
                    );
                  }
                }
              },
              child: Text(
                DateFormat.Hm(
                  Localizations.localeOf(context).languageCode,
                ).format(time.toLocal()),
                style: stationText,
              ),
            ),
            if (timeDifference)
              Text(
                DateFormat.Hm(
                  Localizations.localeOf(context).languageCode,
                ).format(plannedTime!.toLocal()),
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
          ],
        ),
      ],
    );
  }
}
