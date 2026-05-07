import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/profile_link_button.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:http/http.dart' as http;

class FollowerPage extends StatefulWidget {
  const FollowerPage({super.key});

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  Future<List<User>> _getFollower() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.user.getFollowers(page: 1);
    return response;
  }

  Future<List<User>> _getFollowing() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.user.getFollowing(page: 1);
    return response;
  }

  Future<List<User>> _getFollowRequests() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.user.getFollowRequests(page: 1);
    return response;
  }

  late Future<List<User>> _follower;
  late Future<List<User>> _following;
  late Future<List<User>> _followRequests;

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
    required this.userlist,
    this.request,
    this.following,
    this.isFollower,
    required this.callback,
  });

  final Future<List<User>> userlist;
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
    final response = await apiService.user.acceptFollowRequest(id);
    if(response.wasSuccess){
      widget.callback.call(null);
    }
  }

  void _denyFollowRequest(int id) async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.denyFollowRequest(id);
    if(response.wasSuccess){
      widget.callback.call(null);
    }
  }

  void _unfollow(int id) async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.unfollow(id);
    if(response.wasSuccess){
      widget.callback.call(null);
    }
  }

  void _removeFollow(int id) async {
    final ApiService apiService = getIt<ApiService>();
    final response = await apiService.user.removeFollower(id);
    if(response.wasSuccess){
      widget.callback.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: widget.userlist,
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
              return ProfileLinkButton(
                user: asyncSnapshot.data![index],
                action: IconButton(
                  onPressed: () {
                    _removeFollow(asyncSnapshot.data![index].id);
                  },
                  icon: const Icon(Icons.person_remove),
                  tooltip: localize.remove,
                ),
              );
            }
            if (widget.following ?? false) {
              return ProfileLinkButton(
                user: asyncSnapshot.data![index],
                action: IconButton(
                  onPressed: () {
                    _unfollow(asyncSnapshot.data![index].id);
                  },
                  icon: const Icon(Icons.person_remove),
                  tooltip: localize.remove,
                ),
              );
            }
            if (widget.request ?? false) {
              return ProfileLinkButton(
                user: asyncSnapshot.data![index],
                action: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _acceptFollowRequest(asyncSnapshot.data![index].id);
                      },
                      icon: const Icon(Icons.how_to_reg),
                      tooltip: localize.acceptFollowTooltip,
                    ),
                    IconButton(
                      onPressed: () {
                        _denyFollowRequest(asyncSnapshot.data![index].id);
                      },
                      icon: const Icon(Icons.person_off),
                      tooltip: localize.denyFollowTooltip,
                    ),
                  ],
                ),
              );
            }
            return ProfileLinkButton(user: asyncSnapshot.data![index]);
          },
        );
      },
    );
  }
}
