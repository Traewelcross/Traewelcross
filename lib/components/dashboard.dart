import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/custom_providers.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:traewelcross/components/ride_quick_view_wrapper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.scrollController, this.controller});
  final ScrollController scrollController;
  final DashboardController? controller;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class DashboardController {
  Future<void> Function()? _onRefresh;
  Future<void> refresh() async => await _onRefresh?.call();
}

class _DashboardState extends State<Dashboard> {
  final RideQuickViewWrapperController _wrapperController =
      RideQuickViewWrapperController();

  Future<void> refresh() async {
    await Future.wait([
      _countNotifications(),
      _wrapperController.refresh(),
    ]);
  }
  @override
  void initState() {
    super.initState();
    widget.controller?._onRefresh = refresh;
  }


  Future<void> _countNotifications() async {
    final apiService = getIt<ApiService>();
    final res = await apiService.request(
      "/notifications/unread/count",
      HttpRequestTypes.GET,
    );
    if (res.statusCode == 200) {
      getIt<UnreadCountProvider>().setCount(jsonDecode(res.body)["data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RideQuickViewWrapper(
      controller: _wrapperController,
      scrollController: widget.scrollController,
    );
  }
}