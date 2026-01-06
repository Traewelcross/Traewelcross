import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_links/app_links.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/own_profile_picture.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/enums/error_type.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/pages/error_page.dart';
import 'package:traewelcross/pages/home.dart';
import 'package:traewelcross/pages/notifications.dart';
import 'package:traewelcross/pages/login/oauth_login.dart';
import 'package:traewelcross/pages/on_the_move.dart';
import 'package:traewelcross/pages/preferences/preferences.dart';
import 'package:traewelcross/pages/profile_view.dart';
import 'package:traewelcross/pages/stats/statistics.dart';
import 'package:traewelcross/push_notify/push_common.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/custom_providers.dart';
import 'package:traewelcross/utils/authentication.dart';
import 'package:traewelcross/utils/color_scheme.dart';
import 'package:traewelcross/utils/error_info.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:watch_it/watch_it.dart';
import 'pages/app_info.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends WatchingWidget {
  const App({super.key});
  ColorScheme getColorScheme(
    BuildContext context,
    Color? accentColor,
    bool useSystemAccent,
    ColorScheme? dynamicColor,
    Brightness brightness,
  ) {
    if (useSystemAccent && dynamicColor != null) {
      // https://github.com/material-foundation/flutter-packages/issues/649
      return dynamicColor;
    }
    if (accentColor != null) {
      return ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.content,
      );
    }
    if (brightness == Brightness.dark) {
      return tcColorSchemeDark;
    }
    return tcColorSchemeLight;
  }

  Color getCardColor(ColorScheme scheme) {
    if (scheme.brightness == Brightness.dark) {
      return Color.alphaBlend(
        (scheme).primaryContainer.withValues(alpha: 0.02),
        (scheme).surface,
      );
    }
    return Color.alphaBlend(
      (scheme).primaryContainer.withValues(alpha: .1),
      (scheme).surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*final config = watchValue(
      (Config c) => _AppearanceData(
        useSystemAccent: c.appearance.useSystemAccent,
        accentColor: c.appearance.accentColor,
        themeMode: c.appearance.themeMode,
      ),
    );*/
    final useSystemAccent = watchPropertyValue(
      (Config c) => c.appearance.useSystemAccent,
    );
    final accentColor = watchPropertyValue(
      (Config c) => c.appearance.accentColor,
    );
    final themeMode = watchPropertyValue((Config c) => c.appearance.themeMode);
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          final lightColorScheme = getColorScheme(
            context,
            accentColor,
            useSystemAccent,
            lightDynamic,
            Brightness.light,
          );
          final darkColorScheme = getColorScheme(
            context,
            accentColor,
            useSystemAccent,
            darkDynamic,
            Brightness.dark,
          );
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: "Träwelcross",
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              fontFamily: "Outfit",
              fontFamilyFallback: ["NotoEmoji", "SUSE"],
              cardColor: getCardColor(lightColorScheme),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
              fontFamily: "Outfit",
              fontFamilyFallback: ["NotoEmoji", "SUSE"],
              cardColor: getCardColor(darkColorScheme),
            ),
            themeMode: themeMode,
            home: const AppHome(),
          );
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {}

class AppHome extends StatefulWidget {
  const AppHome({super.key});
  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  void _coldNotificationBootHandler() async {
    final NotificationAppLaunchDetails? launchDetails =
        await FlutterLocalNotificationsPlugin()
            .getNotificationAppLaunchDetails();
    if (launchDetails == null) return;
    if (launchDetails.didNotificationLaunchApp) {
      onDidReceiveNotificationResponse(
        launchDetails.notificationResponse ??
            NotificationResponse(
              notificationResponseType:
                  NotificationResponseType.selectedNotification,
            ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Schedule the deep link initialization to run after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initDeepLinks();
        if (Platform.isAndroid || Platform.isIOS) {
          _coldNotificationBootHandler();
        }
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial link that launched the app
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleOauthCallback(initialUri);
    }

    // Handle links received while the app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleOauthCallback(uri);
      _linkSubscription?.cancel();
    });
  }

  void _handleOauthCallback(Uri uri) {
    final authService = getIt<AuthService>();
    if (uri.host == 'oauth.traewelcross.de') {
      authService.handleAuthorizationResponse(uri.queryParameters).then((
        client,
      ) {
        if (client != null && mounted) {
          setState(() {});
        }
      });
    }
  }

  Future<void> _setupNotification() async {
    final authService = getIt<AuthService>();
    final notificationSettings = getIt<Config>().notification;
    final push = globalPushManager;
    if (notificationSettings.notificationsEnabled) {
      await push.initializeNotifications();
      final client = await authService.getAuthenticatedClient();
      if (!notificationSettings.hasBeenRegistered) {
        final status = await push.registerDevice(client);
        if (status) {
          notificationSettings.hasBeenRegistered = true;
        }
      } else {
        notificationSettings.fcmToken = await push.checkAndSyncToken(
          notificationSettings.fcmToken,
          client,
        );
      }
    }
  }

  Future<bool> _setupData() async {
    final authService = getIt<AuthService>();
    final isLoggedIn = await authService.isLoggedIn();

    if (isLoggedIn) {
      try {
        final apiService = getIt<ApiService>();
        await apiService.getUserFull(withId: true);
        final res = await apiService.request(
          "/notifications/unread/count",
          HttpRequestTypes.GET,
        );
        if (res.statusCode == 200) {
          if (!mounted) return true;
          getIt<UnreadCountProvider>().setCount(jsonDecode(res.body)["data"]);
        }
        _setupNotification();
        return true;
      } on TimeoutException {
        if (!mounted) return false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorPage(
              errorInfo: ErrorInfo(
                "Login Issue",
                type: ErrorType.httpError,
                exception: Exception("Request timed out after 10 seconds"),
              ),
            ),
          ),
        );
        return false;
      } catch (e) {
        if (!mounted) return false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorPage(
              errorInfo: ErrorInfo(
                "Login Issue",
                type: ErrorType.logInError,
                exception: e,
              ),
            ),
          ),
        );
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _setupData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Something went wrong while trying to find out if the user is authenticated:\n${snapshot.error}",
              ),
            ),
          );
        }
        if (snapshot.data == true) {
          return const Chrome();
        } else {
          return OauthLogin(onLoginSuccess: () => setState(() {}));
        }
      },
    );
  }
}

class Chrome extends WatchingStatefulWidget {
  const Chrome({super.key});
  @override
  State<Chrome> createState() => _ChromeState();
}

class _ChromeState extends State<Chrome> {
  var selectedPageIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      getIt<AppBarState>().setScrolled(_scrollController.offset > 50);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedPage;
    List<Widget>? actions;
    switch (selectedPageIndex) {
      case 0:
        selectedPage = Home(scrollController: _scrollController);
        break;
      case 1:
        selectedPage = OnTheMove(scrollController: _scrollController);
        break;
      case 2:
        selectedPage = NotificationsView(scrollController: _scrollController);
        actions = [
          IconButton(
            onPressed: () async {
              await getIt<ApiService>().request(
                "/notifications/read/all",
                HttpRequestTypes.PUT,
              );
              if (!context.mounted) return;
              getIt<UnreadCountProvider>().reset();
            },
            icon: const Icon(Icons.done_all),
          ),
        ];
        break;
      case 3:
        selectedPage = ProfileView(
          isOtherUser: false,
          scrollController: _scrollController,
          tempScrollController: false,
        );
        actions = [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppInfo()),
              );
            },
            icon: const Icon(Icons.info),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Preferences()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ];
        break;
      case 4:
        selectedPage = Statistics();
        break;
      default:
        selectedPage = const Placeholder();
    }
    final notifyCount = watchIt<UnreadCountProvider>().unreadCount;
    return MainScaffold(
      title: _getTitleForIndex(selectedPageIndex, null, context),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.commute),
            label: AppLocalizations.of(context)!.navOTM,
          ),
          NavigationDestination(
            icon: notifyCount > 0
                ? Badge.count(
                    count: notifyCount,
                    child: const Icon(Icons.notifications),
                  )
                : const Icon(Icons.notifications),
            label: AppLocalizations.of(context)!.navNotify,
          ),
          NavigationDestination(
            icon: OwnProfilePicture(maxWidth: 42),
            label: AppLocalizations.of(context)!.navProfile,
          ),
          if(watchIt<Config>().misc.showStats || kDebugMode)
          NavigationDestination(icon: const Icon(Icons.bar_chart), label: AppLocalizations.of(context)!.stats)
        ],
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (value) {
          if (value == selectedPageIndex) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: Duration(
                  milliseconds: min(
                    ((_scrollController.offset / 3).floor()),
                    1500,
                  ),
                ),
                curve: Curves.easeOut,
              );
            }
          } else {
            getIt<AppBarState>().setScrolled(false);
          }
          setState(() {
            selectedPageIndex = value;
          });
        },
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(overflow: TextOverflow.ellipsis),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        surfaceTintColor: Theme.of(context).colorScheme.secondary,
      ),
      actions: actions,
      body: selectedPage,
    );
  }
}

Widget _getTitleForIndex(int index, String? title, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  switch (index) {
    case 0:
      return const HomeTitle();
    case 1:
      return AppBarTitle(l10n.navOTM);
    case 2:
      return AppBarTitle(l10n.navNotify);
    case 3:
      return AppBarTitle(l10n.navProfile);
    case 4:
      return AppBarTitle(l10n.stats);
    default:
      return AppBarTitle('');
  }
}

class HomeTitle extends WatchingWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final isScrolled = watchIt<AppBarState>().isScrolled;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isScrolled ? 0.0 : 1.0),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "icons/raw_icon.svg",
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.primary,
              width: 24,
            ),
            SizedBox(width: 8 * value),
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Opacity(
                  opacity: value,
                  child: Text(
                    "Träwelcross",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
