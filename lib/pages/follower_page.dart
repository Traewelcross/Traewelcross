import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/profile_link.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:http/http.dart' as http;

class FollowerPage extends StatefulWidget {
  const FollowerPage({super.key});

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  Future<List<dynamic>> _getFollower() async {
    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request(
        "/user/self/followers",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      throw TimeoutException;
    }
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body)["data"] as List<dynamic>;
      default:
        return Future.error(response.statusCode);
    }
  }

  Future<List<dynamic>> _getFollowing() async {
    final apiService = getIt<ApiService>();
    http.Response response;

    try {
      response = await apiService.request(
        "/user/self/followings",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      throw TimeoutException;
    }
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body)["data"] as List<dynamic>;
      default:
        return Future.error(response.statusCode);
    }
  }

  Future<List<dynamic>> _getFollowRequests() async {
    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request(
        "/user/self/follow-requests",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      throw TimeoutException;
    }

    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body)["data"] as List<dynamic>;
      default:
        return Future.error(response.statusCode);
    }
  }

  late Future<List<dynamic>> _follower;
  late Future<List<dynamic>> _following;
  late Future<List<dynamic>> _followRequests;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _follower = _getFollower();
    _following = _getFollowing();
    _followRequests = _getFollowRequests();
  }

  void _followRequestCallback(String? errorMessage) {
    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
    setState(() {
      _followRequests = _getFollowRequests();
      _follower = _getFollower();
    });
  }

  void _followerCallback(String? errorMessage) {
    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
    setState(() {
      _follower = _getFollower();
    });
  }

  void _followingCallback(String? errorMessage) {
    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
    setState(() {
      _following = _getFollowing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: AppBarTitle("Follower"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Followers",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          _SocialUserList(
            userlist: _follower,
            isFollower: true,
            callback: _followerCallback,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Following",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          _SocialUserList(
            userlist: _following,
            following: true,
            callback: _followingCallback,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Follow Requests",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          _SocialUserList(
            userlist: _followRequests,
            request: true,
            callback: _followRequestCallback,
          ),
        ],
      ),
    );
  }
}

class _SocialUserList extends StatefulWidget {
  const _SocialUserList({
    required Future<List> userlist,
    this.request,
    this.following,
    this.isFollower,
    required this.callback,
  }) : _follower = userlist;

  final Future<List> _follower;
  final bool? following;
  final bool? isFollower;
  final bool? request;
  final Function(String?) callback;

  @override
  State<_SocialUserList> createState() => _SocialUserListState();
}

class _SocialUserListState extends State<_SocialUserList> {
  void _acceptFollowRequest(int id) async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/self/follow-requests/$id",
      HttpRequestTypes.PUT,
    );
    switch (response.statusCode) {
      case 200:
        widget.callback.call(null);
        return;
      case 404:
        if (!mounted) return;
        widget.callback.call(AppLocalizations.of(context)!.requestNotFound);
        break;
      default:
        if (!mounted) return;
        widget.callback.call(
          "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
        );
        break;
    }
  }

  void _denyFollowRequest(int id) async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/self/follow-requests/$id",
      HttpRequestTypes.DELETE,
    );
    switch (response.statusCode) {
      case 200:
        widget.callback.call(null);
        return;
      case 404:
        if (!mounted) return;
        widget.callback.call(AppLocalizations.of(context)!.requestNotFound);
        break;
      default:
        if (!mounted) return;
        widget.callback.call(
          "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
        );
        break;
    }
  }

  void _unfollow(int id) async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/$id/follow",
      HttpRequestTypes.DELETE,
    );
    switch (response.statusCode) {
      case 200:
        widget.callback.call(null);
        return;
      case 404:
        if (!mounted) return;
        widget.callback.call(AppLocalizations.of(context)!.userNotFoundSnack);
        break;
      default:
        if (!mounted) return;
        widget.callback.call(
          "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
        );
        break;
    }
  }

  void _removeFollow(int id) async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.request(
      "/user/self/followers/$id",
      HttpRequestTypes.DELETE,
    );
    switch (response.statusCode) {
      case 200:
        widget.callback.call(null);
        return;
      case 404:
        if (!mounted) return;
        widget.callback.call(AppLocalizations.of(context)!.userNotFoundSnack);
        break;
      default:
        if (!mounted) return;
        widget.callback.call(
          "${AppLocalizations.of(context)!.genericErrorSnackBar} ${response.statusCode}",
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: widget._follower,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (asyncSnapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text("Error ${asyncSnapshot.error}")),
          );
        }
        if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox(height: 0));
        }
        return SliverList.builder(
          itemCount: asyncSnapshot.data!.length,
          itemBuilder: (context, index) {
            if (widget.isFollower ?? false) {
              return ProfileLink(
                userData: asyncSnapshot.data![index],
                action: IconButton(
                  onPressed: () {
                    _removeFollow(asyncSnapshot.data![index]["id"]);
                  },
                  icon: const Icon(Icons.person_remove),
                  tooltip: localize.remove,
                ),
              );
            }
            if (widget.following ?? false) {
              return ProfileLink(
                userData: asyncSnapshot.data![index],
                action: IconButton(
                  onPressed: () {
                    _unfollow(asyncSnapshot.data![index]["id"]);
                  },
                  icon: const Icon(Icons.person_remove),
                  tooltip: localize.remove,
                ),
              );
            }
            if (widget.request ?? false) {
              return ProfileLink(
                userData: asyncSnapshot.data![index],
                action: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _acceptFollowRequest(asyncSnapshot.data![index]["id"]);
                      },
                      icon: const Icon(Icons.how_to_reg),
                      tooltip: localize.acceptFollowTooltip,
                    ),
                    IconButton(
                      onPressed: () {
                        _denyFollowRequest(asyncSnapshot.data![index]["id"]);
                      },
                      icon: const Icon(Icons.person_off),
                      tooltip: localize.denyFollowTooltip,
                    ),
                  ],
                ),
              );
            }
            return ProfileLink(userData: asyncSnapshot.data![index]);
          },
        );
      },
    );
  }
}
