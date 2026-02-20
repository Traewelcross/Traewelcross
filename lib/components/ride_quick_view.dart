import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:share_plus/share_plus.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/profile_picture.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/components/status_tags.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/pages/detailed_ride_view.dart';
import 'package:traewelcross/pages/checkin/checkin.dart';
import 'package:traewelcross/enums/trip_type.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/profile_view.dart';
import 'package:traewelcross/pages/checkin/select_connection.dart';
import 'package:traewelcross/utils/check_in_info.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'dart:convert';
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
  final Map<String, dynamic> rideData;
  final int authUserId;
  final bool? detailedView;
  final Function()? likeCallback;
  final Function()? onDelete;
  @override
  State<RideQuickView> createState() => _RideQuickViewState();
}

class _RideQuickViewState extends State<RideQuickView> {
  late Map<String, dynamic> _rideData;
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

  void _updateRideData(Map<String, dynamic> newRideData) {
    setState(() {
      _rideData = newRideData;
    });
  }

  Future<void> _updateLikes() async {
    final apiService = getIt<ApiService>();
    if (!_rideData["liked"]) {
      if (_rideData["isLikable"] != null && !_rideData["isLikable"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.notLikeable)),
        );
        return;
      }
      try {
        final response = await apiService.request(
          "/status/${_rideData["id"]}/like",
          HttpRequestTypes.POST,
        );
        if (!mounted) return;

        if (response.statusCode == 201) {
          _rideData["liked"] = true;
          _rideData["likes"] = jsonDecode(response.body)["data"]["count"];
          widget.likeCallback?.call();
          _updateRideData(_rideData);
        } else {
          switch (response.statusCode) {
            case 409:
              _rideData["liked"] = true;
              _rideData["likes"] = _rideData["likes"] + 1;
              widget.likeCallback?.call();
              _updateRideData(_rideData);
              return;
            case 403:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.noModifcationAllowedGeneric,
                  ),
                ),
              );
              return;
            case 404:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.statusNotFound),
                ),
              );
              return;
            case 429:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.rateLimit),
                ),
              );
              return;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}',
                  ),
                ),
              );
          }
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
    } else {
      try {
        final response = await apiService.request(
          "/status/${_rideData["id"]}/like",
          HttpRequestTypes.DELETE,
        );
        if (!mounted) return;

        if (response.statusCode == 200) {
          _rideData["liked"] = false;
          _rideData["likes"] = jsonDecode(response.body)["data"]["count"];
          widget.likeCallback?.call();
          _updateRideData(_rideData);
        } else if (response.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.statusNotFound),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.genericErrorSnackBar),
            ),
          );
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
      final int rideId = _rideData["id"];
      final Map<String, dynamic> payload;

      if (isDestination) {
        payload = {
          "manualArrival": updatedDateTime.toUtc().toIso8601String(),
          "visibility": _rideData["visibility"],
          "business": _rideData["business"],
          "body": _rideData["body"],
        };
      } else {
        payload = {
          "manualDeparture": updatedDateTime.toUtc().toIso8601String(),
          "visibility": _rideData["visibility"],
          "business": _rideData["business"],
          "body": _rideData["body"],
        };
      }

      try {
        final response = await apiService.request(
          "/status/$rideId",
          HttpRequestTypes.PUT,
          body: jsonEncode(payload),
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          final updatedRideData = jsonDecode(response.body)["data"];
          _updateRideData(updatedRideData);
        } else {
          switch (response.statusCode) {
            case 403:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.noModifcationAllowed,
                  ),
                ),
              );
              return;
            case 404:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.statusNotFound),
                ),
              );
              return;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${AppLocalizations.of(context)!.genericErrorSnackBar} ${(jsonDecode(response.body)["message"]?.toString() ?? response.statusCode)}",
                  ),
                ),
              );
          }
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
    final response = await apiService.request(
      "/status/${widget.rideData["id"]}",
      HttpRequestTypes.DELETE,
    );
    switch (response.statusCode) {
      case 204:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.statusDeletedSuccessful,
            ),
          ),
        );
        if (widget.detailedView ?? false) {
          Navigator.pop(context);
        } else {
          widget.onDelete?.call();
        }
        break;
      case 403:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.noModifcationAllowedGeneric,
            ),
          ),
        );
        break;
      case 404:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.statusNotFound)),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
            ),
          ),
        );
        break;
    }
  }

  Future<void> _shareRide() async {
    SharePlus.instance.share(
      ShareParams(
        text:
            "https://traewelling.de/status/${widget.rideData["id"]} #Träwelling",
      ),
    );
  }

  Widget _parseBodyText(String body, dynamic bodyMentions) {
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
    final res = await apiService.request(
      "/report",
      HttpRequestTypes.POST,
      body: jsonEncode({
        "subjectType": "Status",
        "subjectId": _rideData["id"],
        "reason": reason,
        "description": desc,
      }),
    );
    if (res.statusCode == 201) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.reportSuccess)),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.genericErrorSnackBar +
                res.statusCode.toString(),
          ),
        ),
      );
    }
  }

  void _copyCheckIn(Map<String, dynamic> status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CheckIn(
          checkInInfo: CheckInInfo(
            destination: status["train"]["destination"]["name"],
            destinationId: status["train"]["destination"]["id"],
            departureId: status["train"]["origin"]["id"],
            tripId: status["train"]["hafasId"],
            lineName: status["train"]["lineName"],
            category: status["train"]["category"],
            departureTime: status["train"]["origin"]["departurePlanned"],
            arrivalTime: status["train"]["destination"]["arrivalPlanned"],
            event: status["event"],
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
                      rideData: _rideData["train"],
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
                                        category: _rideData["train"]["category"]
                                            ?.toString(),
                                        width: 24,
                                        lineName:
                                            _rideData["train"]["lineName"],
                                        hafasId:
                                            _rideData["train"]["operator"]?["identifier"],
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
                                        _rideData["train"]["duration"],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                      child: VerticalDivider(),
                                    ),
                                    const Icon(Symbols.distance),
                                    const SizedBox(width: 4),
                                    Text(
                                      ((_rideData["train"]["distance"] / 1000)
                                                  .toStringAsFixed(0) ==
                                              "0")
                                          ? "${_rideData["train"]["distance"]} m"
                                          : "${(_rideData["train"]["distance"] / 1000).toStringAsFixed(0)} km",
                                    ),
                                    const SizedBox(
                                      height: 20,
                                      child: VerticalDivider(),
                                    ),
                                    switch (_rideData["business"]) {
                                      0 => const Icon(Icons.home),
                                      1 => const Icon(Icons.work),
                                      2 => const Icon(Icons.home_work),
                                      _ => const Icon(Icons.question_mark),
                                    },
                                    if (_rideData["event"] != null) ...[
                                      const SizedBox(
                                        height: 20,
                                        child: VerticalDivider(),
                                      ),
                                      const Icon(Icons.calendar_month),
                                      const SizedBox(width: 4),
                                      Text(_rideData["event"]["name"]),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_rideData["body"] != "" && _rideData["body"] != null)
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
                                  _rideData["body"],
                                  _rideData["bodyMentions"],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    _StationText(
                      rideData: _rideData["train"],
                      isDestination: true,
                      onUpdateTime: _updateTime,
                      isAuthUser: _isAuthUser(),
                    ),
                    const SizedBox(height: 4),
                    TimeProgress(
                      startDate: DateTime.parse(
                        (_rideData["train"]["manualDeparture"] ??
                            _rideData["train"]["origin"]["departure"]),
                      ).toLocal(),
                      endDate: DateTime.parse(
                        (_rideData["train"]["manualArrival"] ??
                            _rideData["train"]["destination"]["arrival"]),
                      ).toLocal(),
                    ),
                    const SizedBox(height: 8),
                    StatusTags(
                      tags: _rideData["tags"],
                      canAdd: _isAuthUser(),
                      rideId: _rideData["id"],
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
                                imageUrl:
                                    _rideData["userDetails"]["profilePicture"],
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
                                            _rideData["userDetails"]["displayName"],
                                          ),
                                          body: ProfileView(
                                            isOtherUser: true,
                                            username:
                                                _rideData["userDetails"]["username"],
                                            tempScrollController: true,
                                            scrollController:
                                                ScrollController(),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${_rideData["userDetails"]["displayName"]}, ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(DateTime.parse(_rideData["createdAt"]).toLocal())}",
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
                              switch (_rideData["visibility"]) {
                                0 => const Icon(Icons.public),
                                1 => const Icon(Icons.link),
                                2 => const Icon(Icons.group),
                                3 => const Icon(Icons.lock),
                                4 => const Icon(Symbols.shield_person),
                                _ => const Icon(Icons.question_mark),
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
                                          builder: (BuildContext context) => CheckIn(
                                            checkInInfo: CheckInInfo(
                                              departureId:
                                                  _rideData["train"]["origin"]["id"],
                                              destination:
                                                  _rideData["train"]["destination"]["name"],
                                              destinationId:
                                                  _rideData["train"]["destination"]["id"],
                                              rideId: _rideData["id"],
                                              body: _rideData["body"],
                                              visibility:
                                                  TripVisibilityEnum.fromValue(
                                                    _rideData["visibility"],
                                                  ),
                                              tripType: TripType.fromValue(
                                                _rideData["business"],
                                              ),
                                              tripId:
                                                  _rideData["train"]["hafasId"],
                                              category:
                                                  _rideData["train"]["category"],
                                              lineName:
                                                  _rideData["train"]["lineName"],
                                              event:
                                                  _rideData["train"]["event"],
                                              manualArrive:
                                                  _rideData["train"]["manualArrival"],
                                              manualDepart:
                                                  _rideData["train"]["manualDeparture"],
                                              departureTime:
                                                  _rideData["train"]["origin"]["departure"],
                                              arrivalTime:
                                                  _rideData["train"]["destination"]["arrivalPlanned"],
                                              rideDataCallback: (rideData) =>
                                                  _updateRideData(rideData),
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
                                      onTap: () => _openReport(_rideData["id"]),
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
    return _rideData["userDetails"]["id"] == widget.authUserId;
  }

  void _addTag(Map<String, dynamic> newTag) {
    setState(() {
      (_rideData['tags'] as List<dynamic>).add(newTag);
    });
  }

  void _deleteTag(String key) {
    setState(() {
      (_rideData['tags'] as List<dynamic>).removeWhere(
        (tag) => tag['key'] == key,
      );
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
  final Map<String, dynamic> rideData;
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
        TextButton.icon(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
            minimumSize: WidgetStatePropertyAll(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () => widget.rideData["isLikable"] ?? true
              ? widget.onUpdateLikes()
              : null,
          icon: widget.rideData["liked"]
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
            widget.rideData["likes"].toString(),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class TimeProgress extends StatefulWidget {
  const TimeProgress({
    super.key,
    required this.startDate,
    required this.endDate,
  });
  final DateTime startDate;
  final DateTime endDate;
  @override
  State<TimeProgress> createState() => _TimeProgressState();
}

class _TimeProgressState extends State<TimeProgress> {
  DateTime? _startDate;
  DateTime? _endDate;
  double progress = 0.0;
  Timer? _timer;
  int? _totalDuration;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _totalDuration = _endDate!.difference(_startDate!).inMilliseconds;
    _updateProgress();
    _startProgressLoop();
  }

  void _updateProgress() {
    final now = DateTime.now();
    final elapsed = now.difference(_startDate!).inMilliseconds;
    if (mounted) {
      setState(() {
        progress = (elapsed / _totalDuration!).clamp(0.0, 1.0);
      });
    }
  }

  void _startProgressLoop() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateProgress();
      if (progress >= 1.0) {
        timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(TimeProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startDate != oldWidget.startDate ||
        widget.endDate != oldWidget.endDate) {
      _timer?.cancel();
      _startDate = widget.startDate;
      _endDate = widget.endDate;
      _totalDuration = _endDate!.difference(_startDate!).inMilliseconds;
      _updateProgress();
      _startProgressLoop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (progress >= 1.0) {
      return LinearProgressIndicator(
        value: 1.0,
        borderRadius: BorderRadius.circular(99999999),
      );
    } else {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: progress),
        duration: Duration(seconds: 1),
        builder: (context, value, child) {
          return LinearProgressIndicator(
            value: value,
            borderRadius: BorderRadius.circular(99999999),
          );
        },
      );
    }
  }
}

class _StationText extends StatelessWidget {
  const _StationText({
    required this.rideData,
    required this.isDestination,
    required this.onUpdateTime,
    required this.isAuthUser,
  });

  final Map<String, dynamic> rideData;
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
    String realTimeStr;
    bool isDelayed;
    final stationText = TextStyle(
      fontSize: 21,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
    );
    if (isDestination) {
      manualTimeStr = rideData["manualArrival"];
      plannedTimeStr = rideData["destination"]["arrivalPlanned"];
      isDelayed = rideData["destination"]["isArrivalDelayed"];
      realTimeStr = rideData["destination"]["arrival"];
    } else {
      manualTimeStr = rideData["manualDeparture"];
      plannedTimeStr = rideData["origin"]["departurePlanned"];
      isDelayed = rideData["origin"]["isDepartureDelayed"];
      realTimeStr = rideData["origin"]["departure"];
    }
    time = DateTime.parse(manualTimeStr ?? realTimeStr);

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
                      stationId: rideData["destination"]["id"],
                      stationName: rideData["destination"]["name"],
                    ),
                  ),
                );
              },
              child: Text(rideData["destination"]["name"], style: stationText),
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
                      stationId: rideData["origin"]["id"],
                      stationName: rideData["origin"]["name"],
                    ),
                  ),
                );
              },
              child: Text(rideData["origin"]["name"], style: stationText),
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
                          ? rideData["destination"]["arrivalPlanned"]
                          : rideData["origin"]["departurePlanned"],
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
                  if (rideData["manualArrival"] != null && isDestination) {
                    initTime = TimeOfDay.fromDateTime(
                      DateTime.parse(rideData["manualArrival"]!).toLocal(),
                    );
                  }
                  if (rideData["manualDeparture"] != null && !isDestination) {
                    initTime = TimeOfDay.fromDateTime(
                      DateTime.parse(rideData["manualDeparture"]!).toLocal(),
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
                          stationId: rideData["destination"]["id"],
                          stationName: rideData["destination"]["name"],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectConnection(
                          stationId: rideData["origin"]["id"],
                          stationName: rideData["origin"]["name"],
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
