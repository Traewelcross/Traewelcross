import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/components/ride_quick_view.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/utils/api_service.dart';

import 'dart:convert';

import 'package:traewelcross/utils/shared.dart';

class RideQuickViewWrapper extends StatefulWidget {
  const RideQuickViewWrapper({
    super.key,
    required this.userName,
    required this.scrollController,
  });

  final String userName;
  final ScrollController? scrollController;

  @override
  State<RideQuickViewWrapper> createState() => _RideQuickViewWrapperState();
}

class _RideQuickViewWrapperState extends State<RideQuickViewWrapper> {
  final List<dynamic> _userRides = [];
  int _page = 1;
  bool _isLoading = false;
  int _userIdAuthUser = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferencesAsync()
        .getInt("userid")
        .then((val) => _userIdAuthUser = val ?? 0);
    _fetchUserRides();
    widget.scrollController!.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController!.removeListener(_onScroll);
    super.dispose();
  }

  Future<void> _fetchUserRides() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final apiService = getIt<ApiService>();
    try {
      final response = await apiService.request(
        "/user/${widget.userName}/statuses?page=$_page",
        HttpRequestTypes.GET,
      );
      if (response.statusCode == 200) {
        final newRides = jsonDecode(response.body)["data"];
        if (!mounted) return;
        setState(() {
          _userRides.addAll(newRides);
          _page++;
          _isLoading = false;
        });
      } else {
        return Future.error('Failed to load user info');
      }
    } on TimeoutException {
      setState(() {
        _isLoading = false;
      });
      SharedFunctions.handleRequestTimeout(context, _fetchUserRides);
    }
  }

  void _onScroll() {
    if (widget.scrollController!.position.pixels >=
            widget.scrollController!.position.maxScrollExtent * 0.9 &&
        !_isLoading) {
      _fetchUserRides();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: _userRides.length + (_isLoading ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        // Handle the loading indicator at the end of the list
        if (index == _userRides.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final ride = _userRides[index];
        final currentRideDate = DateTime.parse(
          ride["train"]["manualDeparture"] ??
              ride["train"]["origin"]["departure"],
        );

        bool showDateHeader = false;
        if (index == 0) {
          // Always show date header for the first item
          showDateHeader = true;
        } else {
          // Compare with the previous ride's date
          final previousRide = _userRides[index - 1];
          final previousRideDate = DateTime.parse(
            previousRide["train"]["manualDeparture"] ??
                previousRide["train"]["origin"]["departure"],
          );
          if (currentRideDate.day != previousRideDate.day ||
              currentRideDate.month != previousRideDate.month ||
              currentRideDate.year != previousRideDate.year) {
            showDateHeader = true;
          }
        }

        List<Widget> widgets = [];
        if (showDateHeader) {
          widgets.add(const SizedBox(height: 16));
          widgets.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                DateFormat.yMMMMEEEEd(
                  Localizations.localeOf(context).languageCode,
                ).format(currentRideDate),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
          );
        }
        widgets.add(
          Hero(
            tag: "rqv-${ride["id"]}",
            child: RideQuickView(
              rideData: ride,
              authUserId: _userIdAuthUser,
              onDelete: () {
                setState(() {
                  _userRides.removeWhere((item) => item["id"] == ride["id"]);
                });
              },
            ),
          ),
        );
        widgets.add(const SizedBox(height: 8));
        return Column(
          key: ValueKey(ride["id"]),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        );
      },
    );
  }
}
