import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:traewelcross/components/ride_quick_view_wrapper.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/enums/user_error.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:traewelcross/pages/follower_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import "package:traewelcross/components/profile_picture.dart";

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.isOtherUser,
    this.username,
    this.userId,
    required this.scrollController,
    required this.tempScrollController,
  });
  final bool isOtherUser;
  final String? username;
  final int? userId;
  final ScrollController scrollController;
  final bool tempScrollController;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<dynamic> _userInfo;
  late String? errorMsg;

  @override
  void dispose() {
    widget.tempScrollController ? widget.scrollController.dispose() : "";
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userInfo = _fetchUserInfo();
  }

  Future<dynamic> _fetchUserInfo() async {
    final apiService = getIt<ApiService>();
    late Response response;
    late Response extended;
    late dynamic jsonRes;
    try {
      if (!widget.isOtherUser) {
        response = await apiService.request("/auth/user", HttpRequestTypes.GET);
      } else {
        response = await apiService.request(
          "/user/${widget.username!}",
          HttpRequestTypes.GET,
        );
      }
      if (response.statusCode == 200) {
        jsonRes = jsonDecode(response.body);
        if (!widget.isOtherUser) {
          // We need to request the Bio in another request, as it isn't included in /auth/user
          extended = await apiService.request(
            "/user/${jsonRes["data"]["username"]}",
            HttpRequestTypes.GET,
          );
          if (extended.statusCode == 200) {
            jsonRes["data"]["bio"] = jsonDecode(extended.body)["data"]["bio"];
          }
        }
        return jsonRes;
      }
      if (response.statusCode == 403) {
        jsonRes = jsonDecode(response.body);
        errorMsg = jsonRes["message"];
        if (errorMsg == "Benutzer stummgeschaltet") {
          return Future.error(UserError.userMuted);
        }
        if (errorMsg == "Dieses Profil ist privat.") {
          return Future.error(UserError.userBlockedOrPrivate);
        }
      } else {
        return Future.error(
          Exception('Failed to load user info: ${response.body}'),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      SharedFunctions.handleRequestTimeout(context, _fetchUserInfo);
      return;
    }
  }

  Future<void> follow({required bool isRequest, String? username}) async {
    final apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/${widget.userId}/follow",
      HttpRequestTypes.POST,
    );
    switch (response.statusCode) {
      case 201:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isRequest
                    ? AppLocalizations.of(context)!.followRequestSent
                    : AppLocalizations.of(context)!.followingSnack(username!),
              ),
            ),
          );
        }
        break;
      case 403:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.followFailBlocked),
            ),
          );
        }
        break;
      case 409:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.alreadyFollowRequest),
            ),
          );
        }
        break;
      default:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
              ),
            ),
          );
        }
        break;
    }
  }

  Future<void> _unmute() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/${widget.userId}/mute",
      HttpRequestTypes.DELETE,
    );
    switch (response.statusCode) {
      case 200:
        setState(() {
          //Although the API returns user info, the code doesn't play nice with it. Using this as workaround, might fix at some point
          _userInfo = _fetchUserInfo();
        });
        return;
      case 404:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.userNotFoundSnack),
          ),
        );
        break;
      default:
        if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _userInfo,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error == UserError.userBlockedOrPrivate) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.privateOrBlocked(widget.username!),
                  ),
                  FilledButton.icon(
                    icon: const Icon(Icons.person_add_alt),
                    onPressed: () => follow(isRequest: true),
                    label: Text(AppLocalizations.of(context)!.followRequest),
                  ),
                ],
              ),
            );
          }
          if (asyncSnapshot.error == UserError.userMuted) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.userMuted(widget.username!),
                  ),
                  FilledButton.icon(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => _unmute(),
                    label: Text(AppLocalizations.of(context)!.unmuteUser),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error),
                const SizedBox(height: 8),
                Text('Error: ${asyncSnapshot.error}'),
              ],
            ),
          );
        }
        if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
          final userInfo = asyncSnapshot.data!["data"];
          return RefreshIndicator(
            onRefresh: () async {
              // Evict the old image from the cache before fetching new data.
              CachedNetworkImage.evictFromCache(userInfo["profilePicture"]);
              setState(() {
                _userInfo = _fetchUserInfo();
              });
              await _userInfo;
            },
            child: CustomScrollView(
              controller: widget.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if ((asyncSnapshot.data["message"] as String?) == null) ...[
                  SliverToBoxAdapter(
                    child: ProfileStatsCard(
                      userInfo: userInfo,
                      isOtherUser: widget.isOtherUser,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  RideQuickViewWrapper(
                    userName: userInfo["username"],
                    scrollController: widget.scrollController,
                  ),
                ],
              ],
            ),
          );
        } else {
          return const Center(child: Icon(Icons.account_circle, size: 128));
        }
      },
    );
  }
}

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({
    super.key,
    required this.userInfo,
    required this.isOtherUser,
  });

  final dynamic userInfo;
  final bool isOtherUser;

  @override
  Widget build(BuildContext context) {
    final imageUrl = userInfo["profilePicture"];

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ProfilePicture(imageUrl: imageUrl, maxWidth: 512),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            userInfo["displayName"],
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "@${userInfo["username"]}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (userInfo["mastodonUrl"] != null &&
                          userInfo["mastodonUrl"].toString().isNotEmpty) ...[
                        const SizedBox(width: 16),
                        IconButton.filledTonal(
                          onPressed: () {
                            SharedFunctions.launchURL(
                              Uri.parse(userInfo["mastodonUrl"].toString()),
                              launchMode: LaunchMode.externalApplication,
                            );
                          },
                          icon: SvgPicture.asset(
                            "icons/masto-logo-white.svg",
                            width: 21,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          tooltip: "Mastodon",
                        ),
                      ],
                    ],
                  ),

                  Card(
                    color: SharedFunctions.secondCard(context),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Symbols.distance),
                              Text(
                                "${(userInfo["totalDistance"] / 1000).toStringAsFixed(0)} km",
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.timer_outlined),
                              Text(
                                _getDuration(
                                  userInfo["totalDuration"],
                                  context,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Symbols.kid_star),
                              Text(
                                AppLocalizations.of(context)!.points(
                                  userInfo["points"].toString(),
                                  userInfo["points"],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.speed),
                              Text(
                                "${((userInfo["totalDistance"] / 1000.0) / (userInfo["totalDuration"] / 60.0)).toStringAsFixed(2)} km/h",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (userInfo["bio"] != null &&
                      (userInfo["bio"] as String).isNotEmpty)
                    Card(
                      color: SharedFunctions.secondCard(context),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.format_quote),
                            const SizedBox(width: 8),
                            Expanded(child: Text(userInfo["bio"])),
                          ],
                        ),
                      ),
                    ),
                  FutureBuilder(
                    future: SharedFunctions.getUserId(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasData &&
                          (userInfo["id"].toString() ==
                              asyncSnapshot.data!.toString())) {
                        return _AuthUserCtrl();
                      } else if (asyncSnapshot.hasData) {
                        return _OtherUserCtrl(userInfo: userInfo);
                      }
                      return const SizedBox(height: 0);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getDuration(int duration, BuildContext context) {
    final dur = Duration(minutes: duration);
    return AppLocalizations.of(context)!.time_summary(dur.inDays, dur.inHours % 24, dur.inMinutes % 60);
  }
}

class _AuthUserCtrl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: FilledButton.icon(
            icon: const Icon(Icons.group),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const FollowerPage(),
                ),
              ),
            },
            label: Text("Follower"),
          ),
        ),
      ],
    );
  }
}

class _OtherUserCtrl extends StatefulWidget {
  const _OtherUserCtrl({required this.userInfo});
  final dynamic userInfo;
  @override
  State<_OtherUserCtrl> createState() => _OtherUserCtrlState();
}

class _OtherUserCtrlState extends State<_OtherUserCtrl> {
  late dynamic _userInfo = widget.userInfo;

  Future<void> _follow() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/${_userInfo["id"]}/follow",
      HttpRequestTypes.POST,
    );
    switch (response.statusCode) {
      case 201:
        setState(() {
          _userInfo = jsonDecode(response.body)["data"];
        });
        return;
      case 404:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.userNotFoundSnack),
          ),
        );
        break;
      default:
        if (!mounted) return;
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

  Future<void> _unfollow() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/${_userInfo["id"]}/follow",
      HttpRequestTypes.DELETE,
    );
    switch (response.statusCode) {
      case 200:
        setState(() {
          _userInfo = jsonDecode(response.body)["data"];
        });
        return;
      case 404:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.userNotFoundSnack),
          ),
        );
        break;
      default:
        if (!mounted) return;
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

  Future<void> _block() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/${_userInfo["id"]}/block",
      HttpRequestTypes.POST,
    );
    switch (response.statusCode) {
      case 201:
        if (!mounted) return;
        setState(() {
          _userInfo = jsonDecode(response.body)["data"];
        });
        Navigator.pop(context, true);
        return;
      case 404:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.userNotFoundSnack),
          ),
        );
        Navigator.pop(context, true);
        break;
      default:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
            ),
          ),
        );
        Navigator.pop(context, true);

        break;
    }
  }

  void _blockConfirm() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.areYouSure),
          content: Text(AppLocalizations.of(context)!.blockFinalConfirm),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () {
                _block();
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mute() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/${_userInfo["id"]}/mute",
      HttpRequestTypes.POST,
    );
    switch (response.statusCode) {
      case 201:
        if (!mounted) return;
        setState(() {
          _userInfo = jsonDecode(response.body)["data"];
        });
        Navigator.pop(context);
        return;
      case 404:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.userNotFoundSnack),
          ),
        );
        Navigator.pop(context);
        break;
      default:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
            ),
          ),
        );
        Navigator.pop(context);
        break;
    }
  }

  Future<void> _unmute() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/${_userInfo["id"]}/mute",
      HttpRequestTypes.DELETE,
    );
    switch (response.statusCode) {
      case 200:
        setState(() {
          _userInfo = jsonDecode(response.body)["data"];
        });
        return;
      case 404:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.userNotFoundSnack),
          ),
        );
        break;
      default:
        if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Builder(
      builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (_userInfo["following"]) ...[
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.person_remove),
                  onPressed: _unfollow,
                  label: Text(localize.unfollowUser),
                ),
              ),
            ] else ...[
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.person_add),
                  onPressed: _follow,
                  label: Text(localize.followUser),
                ),
              ),
            ],
            const SizedBox(width: 4),
            if (!_userInfo["muted"])
              OutlinedButton.icon(
                icon: const Icon(Icons.volume_off),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  localize.muteOrBlockHeader,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    _blockConfirm();
                                  },
                                  label: Text(localize.blockConfirm),
                                  icon: const Icon(Icons.block),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: FloatingActionButton.extended(
                                  onPressed: _mute,
                                  label: Text(
                                    localize.muteConfirm,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.volume_off,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  label: Text(
                                    localize.cancelMuteBlock,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onError,
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                label: Text(localize.muteOrBlockUser),
              )
            else
              OutlinedButton.icon(
                icon: const Icon(Icons.volume_up),
                onPressed: _unmute,
                label: Text(localize.unmuteUser),
              ),
          ],
        );
      },
    );
  }
}
