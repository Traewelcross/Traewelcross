import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart' as pkg;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:traewelcross/components/profile_link.dart';
import 'package:traewelcross/components/ride_quick_view.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/checkin/select_connection.dart';
import 'package:traewelcross/pages/login/oauth_login.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:traewelcross/utils/custom_providers.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:traewelcross/utils/shared.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();
  final _stationController = TextEditingController();
  final FocusNode _stationFocus = FocusNode();
  final GlobalKey<_DashboardState> _dashboardKey = GlobalKey<_DashboardState>();
  List<dynamic> history = [];

  bool stationFocus = false;
  bool typedText = false;
  bool gotResults = false;
  bool isUserSearch = false;
  bool isLocating = false;
  List<dynamic> results = [];
  Timer? debounce;

  void _checkInAtStation(int stationId, String stationName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            SelectConnection(stationId: stationId, stationName: stationName),
      ),
    );
  }

  Future<void> _checkInGPSStation() async {
    setState(() {
      isLocating = true;
    });
    final pos = await _determinePosition();
    if (pos == null) {
      setState(() {
        isLocating = false;
      });
      return;
    }
    if (!mounted) return;
    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request(
        "/trains/station/nearby?latitude=${pos.latitude}&longitude=${pos.longitude}",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.geoLocationTookTooLong),
          duration: Duration(seconds: 6),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.retry,
            onPressed: () => _checkInGPSStation(),
          ),
        ),
      );
      return;
    }

    if (response.statusCode == 200) {
      setState(() {
        isLocating = false;
      });
      _checkInAtStation(
        jsonDecode(response.body)["data"]["id"],
        jsonDecode(response.body)["data"]["name"],
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.geoLocationTookTooLong),
          duration: Duration(seconds: 6),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.retry,
            onPressed: () => _checkInGPSStation(),
          ),
        ),
      );
      setState(() {
        isLocating = false;
      });
    }
  }

  void _typedText() {
    debounce?.cancel();

    final searchTerm = _stationController.text.trim();
    final bool newIsUserSearch = searchTerm.startsWith('@');

    setState(() {
      // If the search type changed (e.g., user added/removed '@'), clear old results.
      if (isUserSearch != newIsUserSearch) {
        results = [];
      }
      // Update the search type for the current build and for the API call.
      isUserSearch = newIsUserSearch;

      if (searchTerm.isEmpty) {
        typedText = false;
        _loadHistory();
      } else {
        typedText = true;
        gotResults = false;
      }
    });

    if (searchTerm.isEmpty) {
      return;
    }

    debounce = Timer(const Duration(milliseconds: 10), () async {
      // If the search term has changed since the timer was started, a new
      // search is already scheduled, so we can ignore this one.
      if (searchTerm != _stationController.text.trim()) {
        return;
      }

      Response response;
      final apiService = getIt<ApiService>();

      // Use the updated isUserSearch state variable to determine the endpoint.
      if (!isUserSearch) {
        response = await apiService.request(
          "/trains/station/autocomplete/${Uri.encodeComponent(searchTerm.replaceAll("/", " "))}",
          HttpRequestTypes.GET,
        );
      } else {
        // For user search, remove the '@' from the search term for the API call.
        final userQuery = searchTerm.substring(1);
        response = await apiService.request(
          "/user/search/$userQuery",
          HttpRequestTypes.GET,
        );
      }

      if (!mounted) return;

      if (searchTerm == _stationController.text.trim()) {
        if (response.statusCode == 200) {
          final newResults = jsonDecode(response.body)["data"];
          setState(() {
            gotResults = true;
            results = newResults;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.genericErrorSnackBar +
                    response.statusCode.toString(),
              ),
            ),
          );
          setState(() {
            gotResults = true;
            results = results;
          });
        }
      }
    });
  }

  Future<void> _getHistory() async {
    Response response;
    final apiService = getIt<ApiService>();
    // Refresh User Info to potentially update
    await apiService.getUserFull(withId: false);
    final userInfo = await SharedFunctions.getUserInfoFromCache();
    response = await apiService.request(
      "/trains/station/history",
      HttpRequestTypes.GET,
    );
    history = List<dynamic>.empty(growable: true);
    if (userInfo["home"] != null) {
      userInfo["home"]["home"] = true;
      history.add(userInfo["home"]);
    }
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body)["data"];
      for (var item in res) {
        item["history"] = true;
      }
      setState(() {
        history.addAll(res);
      });
    }
  }

  void _loadHistory() async {
    setState(() {
      typedText = true;
      gotResults = true;
      results = history;
    });
  }

  // Irrelavant since we now renew automatically
  /*Future<void> _checkTokenExpire() async {
    final apiService = getIt<ApiService>();
    final client = await apiService.getAuthenticatedClient();
    final expiration = client?.credentials.expiration;
    if (expiration != null &&
        !expiration.isBefore(DateTime.now()) &&
        expiration.isBefore(DateTime.now().add(Duration(days: 31)))) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.authTokenAboutToExpire),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.renew,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPreferences()),
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }*/

  Future<void> _isAppUpdate() async {
    bool isUpdate = false;
    final packageInfo = await pkg.PackageInfo.fromPlatform();
    final currentBuildNumber = int.parse(packageInfo.buildNumber);
    final lastBuildNumber =
        await SharedPreferencesAsync(
          options: SharedPreferencesOptions(),
        ).getInt("buildNumber") ??
        0;
    if (currentBuildNumber > lastBuildNumber) {
      isUpdate = true;
    }
    if (!isUpdate) return;
    await SharedPreferencesAsync(
      options: SharedPreferencesOptions(),
    ).setInt("buildNumber", currentBuildNumber);
    // TODO: Display Update SnackBar (give option to view changelog)
  }

  static const _volChan = MethodChannel("volume");
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (getIt<Config>().misc.needsRelogin) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OauthLogin(
                onLoginSuccess: () => TerminateRestart.instance.restartApp(
                  options: TerminateRestartOptions(terminate: true),
                ),
                relogin: true,
              );
            },
          ),
        );
      }
    });
    _getHistory();
    _stationController.addListener(_typedText);
    _stationFocus.addListener(() {
      if (_stationFocus.hasFocus) {
        _loadHistory();
      } else {
        setState(() {
          typedText = false;
        });
      }
    });
    _isAppUpdate();
    _volChan.setMethodCallHandler((call) {
      if (call.method == "volumePressed") {
        _checkInGPSStation();
      }
      return Future.value(null);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _stationController.dispose();
    _stationFocus.dispose();
    debounce?.cancel();
    super.dispose();
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.locationDisabled)),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.locationNotAllowed),
          ),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.locationDenyForever),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.yes,
            onPressed: () => Geolocator.openAppSettings(),
          ),
        ),
      );
      return null;
    }

    Future<Position?> pos;
    try {
      pos = Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(timeLimit: Duration(seconds: 8)),
      );
    } on TimeoutException {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.geoLocationTookTooLong),
          duration: Duration(seconds: 6),
        ),
      );
      setState(() {
        isLocating = false;
      });
      return null;
    }
    return pos;
  }

  String _getArea(List<dynamic>? areas) {
    String areaString = "";
    String defaultString = "";
    if (areas == null) {
      return "";
    }
    for (var area in areas) {
      if (area["default"]) {
        defaultString = area["name"];
      } else {
        areaString += area["name"];
      }
    }
    if (defaultString.isEmpty && areaString.isEmpty) {
      return "";
    }
    if (defaultString.isEmpty) {
      return "— $areaString";
    }
    if (areaString.isEmpty) {
      return "— $defaultString";
    }
    return " — $defaultString, $areaString";
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final scrollController = ScrollController();
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          _getHistory(),
          _dashboardKey.currentState?.refresh() ?? Future.value(),
        ]);
      },
      child: CustomScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _stationController,
                      focusNode: _stationFocus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: localize.homeCheckInPlaceholder,
                        suffixIcon: isLocating
                            ? Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  strokeWidth: 8,
                                ),
                              )
                            : IconButton(
                                onPressed: () async {
                                  try {
                                    await _checkInGPSStation().timeout(
                                      Duration(seconds: 15),
                                    );
                                  } on TimeoutException {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.geoLocationTookTooLong,
                                        ),
                                        duration: Duration(seconds: 6),
                                      ),
                                    );
                                    setState(() {
                                      isLocating = false;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.my_location),
                              ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: typedText ? 300 : 0,
                    child: ClipRRect(
                      child: Column(
                        children: [
                          if (!gotResults) const LinearProgressIndicator(),
                          Expanded(
                            child: Scrollbar(
                              controller: scrollController,
                              thumbVisibility: true,
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: results.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Column(
                                    children: [
                                      if (i == 0)
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Text(
                                                isUserSearch
                                                    ? localize.users
                                                    : localize.stops,
                                                style: TextStyle(fontSize: 24),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (!isUserSearch) ...[
                                        InkWell(
                                          onTap: () {
                                            _checkInAtStation(
                                              results[i]["id"],
                                              results[i]["name"],
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 8.0,
                                            ),
                                            child: Row(
                                              children: [
                                                if (results[i]["home"] ??
                                                    false) ...[
                                                  const Icon(Icons.home),
                                                ] else ...[
                                                  if (results[i]["history"] ??
                                                      false) ...[
                                                    const Icon(Icons.history),
                                                  ] else ...[
                                                    const Icon(Icons.train),
                                                  ],
                                                ],
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${results[i]["name"]}${(results[i]["rilIdentifier"] == null ? "" : (" [${results[i]["rilIdentifier"]}]"))}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                        TextSpan(
                                                          text: _getArea(
                                                            results[i]?["areas"],
                                                          ),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        ProfileLink(
                                          userData: results[i],
                                          appendUsername: true,
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Alerts(),
          Dashboard(
            key: _dashboardKey,
            scrollController: widget.scrollController,
          ),
        ],
      ),
    );
  }
}

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late final Future<List<dynamic>> _alerts;
  Future<List<dynamic>> _getAlerts() async {
    final apiService = getIt<ApiService>();
    final res = await apiService.request("/alerts", HttpRequestTypes.GET);
    if (res.statusCode == 200) {
      return jsonDecode(res.body)["data"];
    } else {
      return Future.value([]);
    }
  }

  @override
  void initState() {
    super.initState();
    _alerts = _getAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _alerts,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.done &&
            asyncSnapshot.hasData) {
          return SliverList.builder(
            itemCount: asyncSnapshot.data!.length,
            itemBuilder: (context, index) {
              final alert = asyncSnapshot.data![index];
              return Card.filled(
                color: switch (alert["type"]) {
                  "info" => Color.alphaBlend(
                    Colors.blue.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.surface,
                  ),
                  "warning" => Color.alphaBlend(
                    Colors.yellow.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.surface,
                  ),
                  "danger" => Color.alphaBlend(
                    Colors.red.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.surface,
                  ),
                  "success" => Color.alphaBlend(
                    Colors.greenAccent.shade400.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.surface,
                  ),
                  _ => Theme.of(context).cardColor,
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          switch (alert["type"]) {
                            "info" => Icon(Icons.info, size: 32),
                            "warning" => Icon(Icons.warning, size: 32),
                            "danger" => Icon(Icons.dangerous, size: 32),
                            "success" => Icon(Icons.check),
                            _ => const SizedBox(width: 0),
                          },
                          SizedBox(width: 8),
                          Text(
                            alert["translations"][0]["title"],
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Divider(height: 0),
                      Row(
                        children: [
                          Expanded(
                            child: Text(alert["translations"][0]["content"]),
                          ),
                        ],
                      ),
                      if (alert["translations"][0]["url"] != null)
                        Row(
                          children: [
                            FilledButton.icon(
                              onPressed: () => SharedFunctions.launchURL(
                                Uri.parse(alert["translations"][0]["url"]),
                              ),
                              icon: const Icon(Icons.open_in_new),
                              label: Text(
                                AppLocalizations.of(context)!.openExternal,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return SliverToBoxAdapter(child: SizedBox(height: 0));
      },
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  Future<void> refresh() async {
    setState(() {
      _userRides.clear();
      _page = 1;
      _isLoading = false;
    });
    _countNotifications();
    await _fetchUserRides();
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

  Future<void> _fetchUserRides() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final apiService = getIt<ApiService>();
    http.Response response;
    try {
      response = await apiService.request(
        "/dashboard?page=$_page",
        HttpRequestTypes.GET,
      );
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      SharedFunctions.handleRequestTimeout(context, _fetchUserRides);
      return;
    }
    if (response.statusCode == 200) {
      final newRides = jsonDecode(response.body)["data"];
      if (!mounted) return;
      setState(() {
        _userRides.addAll(newRides);
        _page++;
        _isLoading = false;
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return Future.error(
        'Failed to load user dashboard: ${response.statusCode}',
      );
    }
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >=
            widget.scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoading) {
      _fetchUserRides();
    }
  }

  @override
  //TODO: refactor ride_quick_view_wrapper.dart so we can reuse it here
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
