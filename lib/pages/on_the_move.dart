import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/components/ride_quick_view.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/utils/api_service.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

import 'package:traewelcross/utils/shared.dart';

class OnTheMove extends StatefulWidget {
  const OnTheMove({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<OnTheMove> createState() => _OnTheMoveState();
}

class _OnTheMoveState extends State<OnTheMove> {
  late Future<List<dynamic>> _userRides;
  int _userIdAuthUser = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferencesAsync()
        .getInt("userid")
        .then((val) => _userIdAuthUser = val ?? 0);
    _userRides = _fetchUsersOnTheMoveRides();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> _fetchUsersOnTheMoveRides() async {
    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request("/statuses", HttpRequestTypes.GET);
    } on TimeoutException {
      if (!mounted) return [];
      SharedFunctions.handleRequestTimeout(context, _fetchUsersOnTheMoveRides);
      return [];
    }
    if (response.statusCode == 200) {
      final newRides = jsonDecode(response.body)["data"];
      return newRides;
    } else {
      throw Future.error('Failed to load users on the move');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userRides,
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
        } else if (asyncSnapshot.hasData && asyncSnapshot.data!.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _userRides = _fetchUsersOnTheMoveRides();
              });
              await _userRides;
            },
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: asyncSnapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                // Handle the loading indicator at the end of the list
                if (index == asyncSnapshot.data!.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final ride = asyncSnapshot.data![index];
                final currentRideDate = DateTime.parse(
                  ride["train"]["manualDeparture"] ??
                      ride["train"]["origin"]["departure"],
                );

                bool showDateHeader = false;
                if (index == 0) {
                  showDateHeader = true;
                } else {
                  // Compare with the previous ride's date
                  final previousRide = asyncSnapshot.data![index - 1];
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
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }
                widgets.add(
                  RideQuickView(rideData: ride, authUserId: _userIdAuthUser),
                );
                widgets.add(const SizedBox(height: 8));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgets,
                );
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
