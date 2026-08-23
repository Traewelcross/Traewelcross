import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/components/ride_quick_view.dart';
import 'package:traewelcross/pages/stats/map_stat/map_stat_for_day_page.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_providers/status_api_provider.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/ride_info.dart';

import 'package:traewelcross/utils/shared.dart';

class RideQuickViewWrapperController {
  Future<void> Function()? _onRefresh;
  Future<void> refresh() async => await _onRefresh?.call();
}

class RideQuickViewWrapper extends StatefulWidget {
  const RideQuickViewWrapper({
    super.key,
    this.userName,
    this.isOTM,
    required this.scrollController,
    this.controller,
  });

  final String? userName;
  final bool? isOTM;
  final ScrollController? scrollController;
  final RideQuickViewWrapperController? controller;

  @override
  State<RideQuickViewWrapper> createState() => _RideQuickViewWrapperState();
}

class _RideQuickViewWrapperState extends State<RideQuickViewWrapper> {
  final List<Status> _userRides = [];
  final Map<int, DateTime> _rideDates = {};
  int _page = 1;
  bool _isLoading = false;
  int _userIdAuthUser = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?._onRefresh = refresh;
    SharedPreferencesAsync()
        .getInt("userid")
        .then((val) => _userIdAuthUser = val ?? 0);
    _fetchRides();
    widget.scrollController!.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController!.removeListener(_onScroll);
    super.dispose();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      _userRides.clear();
      _rideDates.clear();
      _page = 1;
      _isLoading = false;
    });
    await _fetchRides();
  }

  DateTime _parseRideDate(Status ride) {
    if (_rideDates.containsKey(ride.id)) {
      return _rideDates[ride.id]!;
    }
    final parsed = DateTime.parse(
      ride.checkin.manualDeparture ??
          ride.checkin.origin.departureReal ??
          ride.checkin.origin.departurePlanned ??
          "1970-01-01",
    );
    _rideDates[ride.id] = parsed;
    return parsed;
  }

  Future<void> _fetchRides() async {
    if (_isLoading) return;
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final apiService = getIt<ApiService>();
    try {
      StatusListType type = widget.userName == null ? .dashboard : .user;
      if (widget.isOTM == true) {
        type = .onTheMove;
      }
      final newRides = await apiService.status.fetchRides(
        type: type,
        username: widget.userName,
        page: _page,
      );

      for (final ride in newRides) {
        _parseRideDate(ride);
      }

      setState(() {
        _userRides.addAll(newRides);
        _page++;
        _isLoading = false;
      });
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      SharedFunctions.handleRequestTimeout(context, _fetchRides);
    } catch (e) {
      return Future.error(e);
    }
  }

  void _onScroll() {
    if (widget.isOTM != true &&
        widget.scrollController!.position.pixels >=
            widget.scrollController!.position.maxScrollExtent * 0.9 &&
        !_isLoading) {
      _fetchRides();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: _userRides.length + (_isLoading ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index == _userRides.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final ride = _userRides[index];
        final currentRideDate = _parseRideDate(ride);

        bool showDateHeader = false;
        if (index == 0) {
          showDateHeader = true;
        } else {
          final previousRide = _userRides[index - 1];
          final previousRideDate = _parseRideDate(previousRide);
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
              child: Row(
                children: [
                  Text(
                    DateFormat.yMMMMEEEEd(
                      Localizations.localeOf(context).languageCode,
                    ).format(currentRideDate),
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      final ridesOnThisDate = _userRides.where((rideItem) {
                        final rideDate = _parseRideDate(rideItem);
                        return rideDate.year == currentRideDate.year &&
                            rideDate.month == currentRideDate.month &&
                            rideDate.day == currentRideDate.day;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapStatForDayPage(
                            rideInfo: ridesOnThisDate
                                .map((rideItem) => RideInfo.fromRides(rideItem))
                                .toList(),
                            date: currentRideDate,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.map),
                  ),
                ],
              ),
            ),
          );
        }

        Widget rideView = RepaintBoundary(
          child: RideQuickView(
            rideData: ride,
            authUserId: _userIdAuthUser,
            onDelete: () {
              setState(() {
                _rideDates.remove(ride.id);
                _userRides.removeWhere((item) => item.id == ride.id);
              });
            },
          ),
        );
        widgets.add(rideView);
        widgets.add(const SizedBox(height: 8));
        return Column(
          key: ValueKey(ride.id),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        );
      },
    );
  }
}
