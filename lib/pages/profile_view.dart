import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:traewelcross/components/ride_quick_view_wrapper.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:traewelcross/pages/follower_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import "package:traewelcross/components/profile_picture.dart";
import "package:traewelcross/utils/api_providers/api_models.dart" as models;

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
  late Future<models.User> _userInfo;
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

  Future<models.User> _fetchUserInfo() async {
    final apiService = getIt<ApiService>();
    final res = apiService.user.fetchUserInfo(
      username: widget.isOtherUser ? widget.username! : null,
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<models.User>(
      future: _userInfo,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasError) {
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
          final userInfo = asyncSnapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              // Evict the old image from the cache before fetching new data.
              CachedNetworkImage.evictFromCache(userInfo.profilePicture);
              setState(() {
                _userInfo = _fetchUserInfo();
              });
              await _userInfo;
            },
            child: CustomScrollView(
              controller: widget.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: ProfileStatsCard(
                    userInfo: userInfo,
                    isOtherUser: widget.isOtherUser,
                  ),
                ),
                if (widget.isOtherUser &&
                    ((userInfo.privateProfile && !userInfo.following) ||
                        userInfo.blocked))
                  ...[]
                else ...[
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  RideQuickViewWrapper(
                    userName: userInfo.username,
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

  final models.User userInfo;
  final bool isOtherUser;

  @override
  Widget build(BuildContext context) {
    final imageUrl = userInfo.profilePicture;

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
                            userInfo.displayName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "@${userInfo.username}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (userInfo.mastodonUrl != null &&
                          userInfo.mastodonUrl!.isNotEmpty) ...[
                        const SizedBox(width: 16),
                        IconButton.filledTonal(
                          onPressed: () {
                            SharedFunctions.launchURL(
                              Uri.parse(userInfo.mastodonUrl!),
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
                                "${(userInfo.totalDistance / 1000).toStringAsFixed(0)} km",
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.timer_outlined),
                              Text(
                                _getDuration(userInfo.totalDuration, context),
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
                                  userInfo.points.toString(),
                                  userInfo.points,
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
                                "${((userInfo.totalDistance / 1000.0) / (userInfo.totalDuration / 60.0)).toStringAsFixed(2)} km/h",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (userInfo.bio != null && userInfo.bio!.isNotEmpty)
                    Card(
                      color: SharedFunctions.secondCard(context),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.format_quote),
                            const SizedBox(width: 8),
                            Expanded(child: Text(userInfo.bio!)),
                          ],
                        ),
                      ),
                    ),
                  FutureBuilder(
                    future: SharedFunctions.getUserId(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasData &&
                          (userInfo.id.toString() ==
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
    return AppLocalizations.of(
      context,
    )!.time_summary(dur.inDays, dur.inHours % 24, dur.inMinutes % 60);
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
  final models.User userInfo;
  @override
  State<_OtherUserCtrl> createState() => _OtherUserCtrlState();
}

class _OtherUserCtrlState extends State<_OtherUserCtrl> {
  late models.User _userInfo = widget.userInfo;

  Future<void> _follow() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.follow(id: _userInfo.id);
    if (!mounted) return;
    if (response == null) {
      return;
    }
    setState(() => _userInfo = response);
  }

  Future<void> _unfollow() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.unfollow(id: _userInfo.id);
    if (!mounted) return;
    if (response == null) {
      return;
    }
    setState(() => _userInfo = response);
  }

  Future<void> _block() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.block(id: _userInfo.id);
    if (!mounted) return;
    Navigator.pop(context);
    if (response == null) {
      return;
    }
    setState(() => _userInfo = response);
  }

  Future<void> _unblock() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.unblock(id: _userInfo.id);
    if (!mounted) return;
    if (response == null) {
      return;
    }
    setState(() => _userInfo = response);
  }

  void _blockConfirm() async {
    _block();
  }

  Future<void> _mute() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.mute(id: _userInfo.id);
    if (!mounted) return;
    Navigator.pop(context);
    if (response == null) {
      return;
    }
    setState(() => _userInfo = response);
  }

  Future<void> _unmute() async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.unmute(id: _userInfo.id);
    if (!mounted) return;
    if (response == null) {
      return;
    }
    setState(() => _userInfo = response);
  }

  String _getFollowButtonText() {
    final localize = AppLocalizations.of(context)!;
    if (widget.userInfo.followPending) {
      return localize.followRequestPending;
    }
    if (widget.userInfo.privateProfile &&
        !widget.userInfo.following &&
        !widget.userInfo.blocked) {
      return localize.followRequest;
    }
    return localize.followUser;
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Builder(
      builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (_userInfo.following) ...[
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
                  onPressed: _userInfo.followPending || _userInfo.blocked
                      ? null
                      : _follow,
                  label: Text(_getFollowButtonText(), overflow: .ellipsis),
                ),
              ),
            ],
            const SizedBox(width: 4),
            if (!_userInfo.muted && !_userInfo.blocked)
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
            else if (_userInfo.muted)
              OutlinedButton.icon(
                icon: const Icon(Icons.volume_up),
                onPressed: _unmute,
                label: Text(localize.unmuteUser),
              )
            else if (_userInfo.blocked)
              OutlinedButton.icon(
                icon: const Icon(Icons.block),
                onPressed: _unblock,
                label: Text(localize.unblockUser),
              ),
          ],
        );
      },
    );
  }
}
