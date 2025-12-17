import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/pages/checkin/checkin_success.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/profile_link.dart';
import 'package:traewelcross/components/ride_icon_tag.dart';
import 'package:traewelcross/components/time_override_field.dart';
import 'package:traewelcross/enums/trip_type.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/checkin/select_stop.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/check_in_info.dart';
import 'package:traewelcross/utils/ride_icon_tag_info.dart';
import 'package:traewelcross/utils/shared.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({super.key, required this.checkInInfo, required this.isEdit});
  final CheckInInfo checkInInfo;
  final bool isEdit;

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  TripType tripType = TripType.private;
  late TripVisibilityEnum tripVisi = TripVisibilityEnum.private;
  DateTime? manualDepart;
  DateTime? manualArrive;
  late CheckInInfo checkInInfo;
  late Map<String, dynamic> userInfo = {};
  final statusController = TextEditingController();
  bool waitForRes = false;
  Map<String, dynamic> event = {
    "isSelected": false,
    "eventName": "",
    "eventId": 0,
  };
  Map<String, dynamic> checkinUsers = {
    "withUsers": false,
    "users": <String, int>{},
  };
  @override
  void initState() {
    super.initState();
    _getDefault();
    checkInInfo = widget.checkInInfo;
    if (widget.isEdit) {
      tripType = checkInInfo.tripType!;
      manualDepart = DateTime.tryParse(
        checkInInfo.manualDepart ?? "",
      )?.toLocal();
      manualArrive = DateTime.tryParse(
        checkInInfo.manualArrive ?? "",
      )?.toLocal();
      statusController.text = checkInInfo.body ?? "";
    } else {
      _prepareStatusText();
      checkInInfo.toot = false;
      checkInInfo.attachToLastToot = false;
      //TODO: Copying the event will send it with the request, however for some reason it doesn't seem like it gets accepted by the server
      if (checkInInfo.event != null) {
        event = {
          "isSelected": false,
          "eventName": checkInInfo.event!["name"],
          "eventId": checkInInfo.event!["id"],
        };
      }
    }
  }

  void _prepareStatusText() {
    String? text = getIt<Config>().behavior.defaultStatusText;
    if (text == null) return;
    // TODO: Actually implement this
    final Map<String, String> replacementMap = {
      "plannedDep": "",
      "plannedArr": "",
    };
    // Disable warning replacementMap is unused :p
    replacementMap;
    statusController.text = text;
  }

  @override
  void dispose() {
    statusController.dispose();
    super.dispose();
  }

  void _getDefault() async {
    userInfo = await SharedFunctions.getUserInfoFromCache();
    setState(() {
      tripVisi = !widget.isEdit
          ? TripVisibilityEnum.fromValue(userInfo["defaultStatusVisibility"])
          : checkInInfo.visibility!;
    });
  }

  Future<List<dynamic>> _getEvents() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/events?timestamp=${Uri.encodeQueryComponent(widget.isEdit ? checkInInfo.departureTime! : DateTime.now().toLocal().toIso8601String())}",
      HttpRequestTypes.GET,
    );
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body)["data"];
      default:
        return Future.error(
          "Couldn't get events: ${response.statusCode}\n${response.body}",
        );
    }
  }

  Future<List<dynamic>> _getTrustedUsers() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/self/trusted-by",
      HttpRequestTypes.GET,
    );
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body)["data"];
      default:
        return Future.error(
          "Couldn't get trusted users: ${response.statusCode}",
        );
    }
  }

  Future<void> _checkIn() async {
    if (waitForRes) return;
    setState(() {
      waitForRes = true;
    });
    final apiService = getIt<ApiService>();
    final body = {
      "body": statusController.text,
      "business": tripType.value,
      "visibility": tripVisi.value,
      "eventId": (event["isSelected"] ? event["eventId"] : null),
      "toot": checkInInfo.toot,
      "chainPost": checkInInfo.attachToLastToot,
      "tripId": checkInInfo.tripId,
      "lineName": checkInInfo.lineName,
      "start": checkInInfo.departureId,
      "destination": checkInInfo.destinationId,
      "with": checkinUsers["withUsers"]
          ? (checkinUsers["users"] as Map<String, int>).values.toList()
          : null,
      "departure": checkInInfo.departureTime,
      "arrival": checkInInfo.arrivalTime,
    };
    try {
      final response = await apiService.request(
        "/trains/checkin",
        HttpRequestTypes.POST,
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        if (!mounted) return;
        waitForRes = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                CheckinSuccess(statusInfo: jsonDecode(response.body)["data"]),
          ),
        );
      } else {
        setState(() {
          waitForRes = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(
              "Couldn't check you in: ${response.statusCode} / ${response.body}",
            ),
            actions: [
              IconButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).clearMaterialBanners(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        );
        return;
      }
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        waitForRes = false;
      });
      // Normally, this should only be called for page loads, since it displays a banner that takes the attention.
      // Since checking in is a pretty substantial request, a banner is shown on timeout as well.
      SharedFunctions.handleRequestTimeout(context, _checkIn);
    }
  }

  Future<void> _edit() async {
    if (waitForRes) return;
    setState(() {
      waitForRes = true;
    });
    final apiService = getIt<ApiService>();
    final body = {
      "body": statusController.text,
      "business": tripType.value,
      "visibility": tripVisi.value,
      "eventId": (event["isSelected"] ? event["eventId"] : null),
      "manualDeparture": manualDepart?.toUtc().toIso8601String(),
      "manualArrival": manualArrive?.toUtc().toIso8601String(),
      "destinationId": checkInInfo.destinationId,
      "destinationArrivalPlanned": checkInInfo.arrivalTime,
    };
    try {
      final response = await apiService.request(
        "/status/${checkInInfo.rideId}",
        HttpRequestTypes.PUT,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        if (checkInInfo.rideDataCallback != null) {
          checkInInfo.rideDataCallback!(jsonDecode(response.body)["data"]);
        }
        setState(() {
          waitForRes = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          waitForRes = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(
              "Couldn't update check in: ${response.statusCode} / ${response.body}",
            ),
            actions: [
              IconButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).clearMaterialBanners(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        );
        return;
      }
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        waitForRes = false;
      });
      // See _checkin
      SharedFunctions.handleRequestTimeout(context, _edit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: widget.isEdit
          ? AppBarTitle(localize.editStatus)
          : AppBarTitle(localize.checkIn),
      body: SingleChildScrollView(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RideIconTag(
                            iconInfo: RideIconTagInfo(
                              width: 24,
                              category: checkInInfo.category,
                            ),
                          ),
                          Text(
                            "${checkInInfo.lineName} -> ",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              checkInInfo.destination,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: statusController,
                        maxLength: 280,
                        minLines: 1,
                        maxLines: null,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          labelText: localize.statusText,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TripTypeSelection(
                        selectedType: tripType.value,
                        onTypeChanged: (p0) {
                          setState(() {
                            tripType = TripType.fromValue(p0.first);
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      TripVisibility(
                        selectedVisibility: tripVisi.value,
                        onVisibilityChanged: (p0) {
                          setState(() {
                            tripVisi = TripVisibilityEnum.fromValue(p0.first);
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      EventButton(
                        event: event,
                        onEventSelected: (map) => setState(() {
                          event = map;
                        }),
                        getEvents: _getEvents,
                      ),
                      if (!widget.isEdit) ...[
                        const SizedBox(height: 8),
                        TrustedCheckInButton(
                          users: checkinUsers,
                          onSelectionChange: (map) => setState(() {
                            checkinUsers = map;
                          }),
                          getTrustedUsers: _getTrustedUsers,
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (widget.isEdit) ...[
                        TimeOverrideField(
                          watermark: localize.overrideDepartTime,
                          initialDate: manualDepart,
                          onDateChanged: (newDate) {
                            setState(() {
                              manualDepart = newDate;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        TimeOverrideField(
                          watermark: localize.overrideArriveTime,
                          initialDate: manualArrive,
                          onDateChanged: (newDate) {
                            setState(() {
                              manualArrive = newDate;
                            });
                          },
                        ),
                      ],
                      if (!widget.isEdit &&
                          userInfo["mastodonUrl"] != null) ...[
                        GestureDetector(
                          onTap: () => setState(() {
                            checkInInfo.toot = !checkInInfo.toot!;
                            if (!checkInInfo.toot!) {
                              checkInInfo.attachToLastToot = false;
                            }
                          }),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "icons/masto-logo-white.svg",
                                // ignore: deprecated_member_use
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(localize.postOnFediverse)),
                              Switch(
                                value: checkInInfo.toot!,
                                onChanged: (val) => setState(() {
                                  checkInInfo.toot = val;
                                  if (!checkInInfo.toot!) {
                                    checkInInfo.attachToLastToot = false;
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                        if (checkInInfo.toot!)
                          GestureDetector(
                            onTap: () => setState(() {
                              checkInInfo.attachToLastToot =
                                  !checkInInfo.attachToLastToot!;
                            }),
                            child: Row(
                              children: [
                                const Icon(Icons.attachment),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(localize.attachToLastToot),
                                ),
                                Switch(
                                  value: checkInInfo.attachToLastToot!,
                                  onChanged: (val) => setState(() {
                                    checkInInfo.attachToLastToot = val;
                                  }),
                                ),
                              ],
                            ),
                          ),
                      ],
                      const SizedBox(height: 8),
                      if (!widget.isEdit)
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.tonalIcon(
                                icon: waitForRes
                                    ? Transform.scale(
                                        scale: 0.5,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 8,
                                        ),
                                      )
                                    : const Icon(Icons.check),
                                onPressed: () {
                                  _checkIn();
                                },
                                label: Text(localize.checkIn),
                              ),
                            ),
                          ],
                        ),
                      if (widget.isEdit) ...[
                        Row(
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => SelectStop(
                                      lineName: widget.checkInInfo.lineName!,
                                      tripId: widget.checkInInfo.tripId!,
                                      destination:
                                          widget.checkInInfo.destination,
                                      startStopId:
                                          widget.checkInInfo.departureId,
                                      category: widget.checkInInfo.category!,
                                      departureTime:
                                          widget.checkInInfo.departureTime!,
                                      editCallback: (destinationInfo) =>
                                          setState(() {
                                            checkInInfo.destinationId =
                                                destinationInfo["id"];
                                            checkInInfo.destination =
                                                destinationInfo["name"];
                                            checkInInfo.arrivalTime =
                                                destinationInfo["arrivalTime"];
                                          }),
                                    ),
                                  ),
                                );
                              },
                              label: Text(localize.changeDestination),
                            ),
                            Spacer(),
                            FilledButton.tonalIcon(
                              icon: waitForRes
                                  ? Transform.scale(
                                      scale: 0.5,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 8,
                                      ),
                                    )
                                  : const Icon(Icons.save),
                              onPressed: () {
                                _edit();
                              },
                              label: Text(localize.save),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrustedCheckInButton extends StatelessWidget {
  const TrustedCheckInButton({
    super.key,
    required this.users,
    required this.onSelectionChange,
    required this.getTrustedUsers,
  });

  final Map<String, dynamic> users;
  final Function(Map<String, dynamic>) onSelectionChange;
  final Future<List<dynamic>> Function() getTrustedUsers;

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final materialLocalize = MaterialLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () {
              final trustedUsersFuture = getTrustedUsers();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final Map<String, int> selectedUsers = Map.from(
                    users["users"],
                  );
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text(localize.checkInOtherUsersTitle),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: FutureBuilder(
                            future: trustedUsersFuture,
                            builder: (context, asyncSnapshot) {
                              if (asyncSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (asyncSnapshot.hasData &&
                                  asyncSnapshot.data!.isEmpty) {
                                return Text(localize.noTrustedUsers);
                              }
                              if (asyncSnapshot.hasError) {
                                return Text(
                                  "${localize.genericErrorSnackBar} ${asyncSnapshot.error}",
                                );
                              }
                              if (asyncSnapshot.hasData &&
                                  asyncSnapshot.data!.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: asyncSnapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        final user =
                                            asyncSnapshot.data![index]["user"];
                                        final isChecked = selectedUsers
                                            .containsValue(user["id"]);
                                        return CheckboxListTile(
                                          value: isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                selectedUsers[user["username"]] =
                                                    user["id"];
                                              } else {
                                                selectedUsers.removeWhere(
                                                  (key, val) =>
                                                      val == user["id"],
                                                );
                                              }
                                            });
                                          },
                                          title: ProfileLink(
                                            userData: user,
                                            enableNavigateToProfile: false,
                                          ),
                                        );
                                      },
                                );
                              }
                              return const SizedBox(height: 0);
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(materialLocalize.cancelButtonLabel),
                          ),
                          TextButton(
                            onPressed: () {
                              onSelectionChange({
                                "withUsers": selectedUsers.isNotEmpty,
                                "users": selectedUsers,
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(materialLocalize.okButtonLabel),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            label: users["withUsers"]
                ? Text(
                    (users["users"] as Map).keys.join(", "),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(localize.checkInOtherUsers),
            icon: users["withUsers"]
                ? const Icon(Icons.group)
                : const Icon(Icons.group_add),
          ),
        ),
      ],
    );
  }
}

class EventButton extends StatelessWidget {
  const EventButton({
    super.key,
    required this.event,
    required this.onEventSelected,
    required this.getEvents,
  });

  final Map<String, dynamic> event;
  final Function(Map<String, dynamic>) onEventSelected;
  final Future<List<dynamic>> Function() getEvents;

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(localize.selectEventBoxTitle),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: FutureBuilder(
                        future: getEvents(),
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (asyncSnapshot.hasData &&
                              asyncSnapshot.data!.isEmpty) {
                            return Text(
                              AppLocalizations.of(context)!.noEventsFound,
                            );
                          }
                          if (asyncSnapshot.hasError) {
                            return Text(
                              "${localize.genericErrorSnackBar} ${asyncSnapshot.error}",
                            );
                          }
                          if (asyncSnapshot.hasData &&
                              asyncSnapshot.data!.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: asyncSnapshot.data!.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return ListTile(
                                    leading: const Icon(Icons.block),
                                    title: Text(localize.deselectEvent),
                                    subtitle: Text(
                                      localize.deselectEventSubtitle,
                                    ),
                                    onTap: () {
                                      onEventSelected({
                                        "isSelected": false,
                                        "eventName": "",
                                        "eventId": 0,
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                                final eventData =
                                    asyncSnapshot.data![index - 1];
                                return ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: Text(eventData["name"]),
                                  subtitle: Text(
                                    "${DateFormat.yMd(Localizations.localeOf(context).languageCode).format(DateTime.parse(eventData["begin"]))} - ${DateFormat.yMd(Localizations.localeOf(context).languageCode).format(DateTime.parse(eventData["end"]))}",
                                  ),
                                  onTap: () {
                                    onEventSelected({
                                      "isSelected": true,
                                      "eventName": eventData["name"],
                                      "eventId": eventData["id"],
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          }
                          return const SizedBox(height: 0);
                        },
                      ),
                    ),
                  );
                },
              );
            },
            label: event["isSelected"]
                ? Text(event["eventName"])
                : Text(localize.addEvent),
            icon: event["isSelected"]
                ? const Icon(Icons.calendar_month)
                : const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }
}

class TripTypeSelection extends StatelessWidget {
  const TripTypeSelection({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });
  final int selectedType;
  final Function(Set<int>) onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SegmentedButton(
            onSelectionChanged: onTypeChanged,
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: 0,
                icon: selectedType == 0 ? null : const Icon(Icons.person),
                label: selectedType == 0
                    ? Text(localize.privateTrip, textAlign: TextAlign.center)
                    : null,
              ),
              ButtonSegment(
                value: 2,
                icon: selectedType == 2 ? null : const Icon(Icons.home_work),
                label: selectedType == 2
                    ? Text(localize.commuteTrip, textAlign: TextAlign.center)
                    : null,
              ),
              ButtonSegment(
                value: 1,
                icon: selectedType == 1 ? null : const Icon(Icons.work),
                label: selectedType == 1
                    ? Text(localize.businessTrip, textAlign: TextAlign.center)
                    : null,
              ),
            ],
            selected: <int>{selectedType},
          ),
        ),
      ],
    );
  }
}

class TripVisibility extends StatelessWidget {
  const TripVisibility({
    super.key,
    required this.selectedVisibility,
    required this.onVisibilityChanged,
  });
  final int selectedVisibility;
  final Function(Set<int>) onVisibilityChanged;
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

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SegmentedButton(
            onSelectionChanged: onVisibilityChanged,
            showSelectedIcon: false,
            segments: TripVisibilityEnum.values.map((TripVisibilityEnum tve) {
              return ButtonSegment(
                value: tve.value,
                tooltip: _getVisibilityString(tve, localize),
                icon: Icon(tve.icon),
              );
            }).toList(),
            selected: <int>{selectedVisibility},
          ),
        ),
      ],
    );
  }
}
