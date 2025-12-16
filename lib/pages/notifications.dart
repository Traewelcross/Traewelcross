import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/detailed_ride_view.dart';
import 'package:traewelcross/pages/follower_page.dart';
import 'package:traewelcross/utils/api_service.dart';

import 'dart:convert';

import 'package:traewelcross/utils/custom_providers.dart';
import 'package:traewelcross/utils/shared.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<dynamic> _notifications = [];
  int _page = 1;
  bool _isLoading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    _fetchNotifications();
    _getUnread();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  Future<void> _markAsRead(String id) async {
    await getIt<ApiService>().request(
      "/notifications/read/$id",
      HttpRequestTypes.PUT,
    );
  }

  Future<void> _getUnread() async {
    final apiService = getIt<ApiService>();
    http.Response res;
    try {
      res = await apiService.request(
        "/notifications/unread/count",
        HttpRequestTypes.GET,
      );
    } catch (e) {
      return;
    }
    if (res.statusCode == 200) {
      if (!mounted) return;
      getIt<UnreadCountProvider>().setCount(jsonDecode(res.body)["data"]);
    }
  }

  Future<void> _fetchNotifications() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request(
        "/notifications?page=$_page",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      SharedFunctions.handleRequestTimeout(context, _fetchNotifications);
      return;
    }

    if (response.statusCode == 200) {
      final newNotifications = jsonDecode(response.body)["data"];
      if (!mounted) return;
      setState(() {
        _notifications.addAll(newNotifications);
        _page++;
        _isLoading = false;
      });
    } else {
      return Future.error(
        'Failed to load user notifications: ${response.statusCode}',
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoading) {
      _fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: () async {
        _notifications.clear();
        _page = 1;
        await _fetchNotifications();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          if (_notifications.isEmpty)
            SliverToBoxAdapter(
              child: Center(child: Text(localize.noNotificationsAvailable)),
            ),
          if (_notifications.isNotEmpty)
            SliverList.builder(
              itemCount: _notifications.length + (_isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == _notifications.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final notification = _notifications[index];
                IconData notificationIcon;

                switch (notification['type'] as String?) {
                  case 'UserFollowed':
                    notificationIcon = Icons.person_add;
                    break;
                  case 'StatusLiked':
                    notificationIcon = Icons.favorite;
                    break;
                  case 'FollowRequestIssued':
                    notificationIcon = Symbols.question_mark;
                    break;
                  case "FollowRequestApproved":
                    notificationIcon = Symbols.person_check;
                    break;
                  case "UserMentioned":
                    notificationIcon = Symbols.alternate_email;
                    break;
                  default:
                    notificationIcon = Icons.notifications;
                }

                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                    tileColor: notification["readAt"] == null
                        ? null
                        : Theme.of(context).splashColor,
                    onTap: () {
                      switch (notification['type'] as String?) {
                        case 'UserFollowed':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => FollowerPage(),
                            ),
                          );
                          break;
                        case 'StatusLiked':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailedRideView(
                                    rideId:
                                        notification["data"]["status"]["id"],
                                  ),
                            ),
                          );
                          notificationIcon = Icons.favorite;
                          break;
                        case 'FollowRequestIssued':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => FollowerPage(),
                            ),
                          );
                          break;
                        case "FollowRequestApproved":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => FollowerPage(),
                            ),
                          );
                          break;
                        case "UserMentioned":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailedRideView(
                                    rideId:
                                        notification["data"]["status"]["id"],
                                  ),
                            ),
                          );
                          break;
                        default:
                          return;
                      }
                    },
                    leading: Icon(notificationIcon),
                    title: Text(notification['lead'] ?? ''),
                    subtitle: notification['notice'].toString().isEmpty
                        ? null
                        : Text(notification['notice']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.yMd(
                            Localizations.localeOf(context).languageCode,
                          ).add_Hm().format(
                            (DateTime.tryParse(notification["createdAt"]) ??
                                    DateTime.parse("19700101"))
                                .toLocal(),
                          ),
                        ),
                        if (notification["readAt"] == null) ...[
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            onPressed: () {
                              _markAsRead(notification["id"]);
                              setState(() {
                                notification["readAt"] = "";
                                getIt<UnreadCountProvider>().decrement();
                              });
                            },
                            icon: const Icon(Icons.mark_email_read),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
