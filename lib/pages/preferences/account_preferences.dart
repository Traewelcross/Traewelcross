import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/own_profile_picture.dart';
import 'package:traewelcross/config/enums/trusted_type_enum.dart';
import 'package:traewelcross/config/enums/mastodon_visibility.dart';
import 'package:traewelcross/enums/error_type.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/error_page.dart';
import 'package:traewelcross/pages/preferences/modify_trusted_users.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/authentication.dart';
import 'package:traewelcross/utils/error_info.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class AccountPreferences extends StatefulWidget {
  const AccountPreferences({super.key});

  @override
  State<AccountPreferences> createState() => _AccountPreferencesState();
}

class _AccountPreferencesState extends State<AccountPreferences> {
  Map<String, dynamic>? _userConfig;
  Map<String, dynamic>? _orgUserConfig;
  bool _isLoading = true;
  bool _enabledArchive = false;
  bool _changedSetting = false;
  bool _applying = false;
  bool _waitForRefresh = false;
  String? _error;
  DateTime? _tokenExpire;

  @override
  void initState() {
    super.initState();
    _getTokenExpire();
    _getUserConfig();
  }

  Future<void> _getTokenExpire() async {
    final client = await getIt<AuthService>().getAuthenticatedClient();
    setState(() {
      _tokenExpire = client?.credentials.expiration;
    });
  }

  Future<void> _getUserConfig() async {
    try {
      final apiService = getIt<ApiService>();
      http.Response response;
      try {
        response = await apiService.request(
          "/settings/profile",
          HttpRequestTypes.GET,
        );
      } on TimeoutException {
        if (!mounted) return;
        SharedFunctions.handleRequestTimeout(context, _getUserConfig);
        return;
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)["data"];
        setState(() {
          if (json["privacyHideDays"] != 0) {
            _enabledArchive = true;
          }
          _userConfig = json;
          // Copy instead of reference
          _orgUserConfig = {...json};
          _isLoading = false;
        });
      } else {
        return Future.error(
          "Couldn't fetch Account Settings :( (${response.statusCode})",
        );
      }
    } catch (e) {
      return Future.error("An unexpected error occurred: $e");
    }
  }

  Future<void> _saveSettings() async {
    if (_applying) return;
    setState(() {
      _applying = true;
    });
    final newSettings = SharedFunctions.diffMaps(_orgUserConfig!, _userConfig!);
    if (newSettings.isEmpty) {
      setState(() {
        _changedSetting = false;
        _applying = false;
      });
    } else {
      //These fields have to always be filled
      newSettings["username"] = _userConfig!["username"];
      newSettings["displayName"] = _userConfig!["displayName"];
      newSettings["email"] = _userConfig!["email"];

      if (!_enabledArchive) newSettings["privacyHideDays"] = null;
      final res = await getIt<ApiService>().request(
        "/settings/profile",
        HttpRequestTypes.PUT,
        body: jsonEncode(newSettings),
      );
      if (res.statusCode == 200) {
        if (!mounted) return;
        await getIt<ApiService>().getUserFull(withId: false);
        setState(() {
          _changedSetting = false;
          _applying = false;
        });
      } else {
        setState(() {
          _changedSetting = false;
          _applying = false;
        });
        return Future.error("(${res.statusCode}): ${res.body}");
      }
    }
  }

  String _getVisibilityString(
    TripVisibilityEnum? tve,
    MastodonVisibility? masto,
    AppLocalizations localize,
  ) {
    return switch (tve ?? masto) {
      final t when t == TripVisibilityEnum.public => localize.public,
      TripVisibilityEnum.private => localize.private,
      TripVisibilityEnum.notListed => localize.notListed,
      TripVisibilityEnum.loggedInUser => localize.loggedInUsers,
      TripVisibilityEnum.followerOnly => localize.followerOnly,

      MastodonVisibility.public => localize.public,
      MastodonVisibility.private => localize.private,
      MastodonVisibility.notListed => localize.notListed,
      MastodonVisibility.followerOnly => localize.followerOnly,
      _ => "?",
    };
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !_changedSetting,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                icon: Icon(Icons.save),
                title: Text(localize.unsavedChangesTitle),
                content: Text(localize.unsavedChanges),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(localize.yes),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localize.no),
                  ),
                ],
              );
            },
          );
        }
      },
      child: MainScaffold(
        floatingActionButton: _changedSetting
            ? FloatingActionButton.extended(
                onPressed: _saveSettings,
                label: Text(localize.save),
                icon: _applying
                    ? Transform.scale(
                        scale: 0.5,
                        child: CircularProgressIndicator(strokeWidth: 8),
                      )
                    : const Icon(Icons.save),
              )
            : null,
        title: Text(localize.account),
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(_error!, textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            if (_userConfig == null) {
              return const Center(
                child: Icon(Icons.error),
              );
            }

            return ListView(
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    _userConfig!["username"] = value;
                    setState(() {
                      _changedSetting = true;
                    });
                  },
                  initialValue: _userConfig!["username"],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(localize.username),
                    prefix: Text("@"),
                    // Workaround to fix missing pixels for perfect circle
                    prefixIcon: SizedBox(
                      width: 24,
                      child: FittedBox(
                        child: Transform.scale(
                          scale: 0.6,
                          child: OwnProfilePicture(maxWidth: 240),
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localize.fieldRequired;
                    }
                    var re = RegExp(r"[^a-zA-Z0-9_.]");
                    if (re.hasMatch(value)) {
                      return localize.fieldNoSpecialChar;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    _userConfig!["displayName"] = value;
                    setState(() {
                      _changedSetting = true;
                    });
                  },
                  initialValue: _userConfig!["displayName"],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(localize.displayName),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localize.fieldRequired;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    _userConfig!["bio"] = value;
                    setState(() {
                      _changedSetting = true;
                    });
                  },
                  initialValue: _userConfig!["bio"],
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    label: Text(localize.bio),
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.format_quote),
                  ),
                ),
                Divider(),
                const SizedBox(height: 8),
                ListTile(
                  onTap: () => setState(() {
                    _userConfig!["privateProfile"] =
                        !_userConfig!["privateProfile"];
                    _changedSetting = true;
                  }),
                  contentPadding: EdgeInsets.zero,
                  title: Text(localize.privateAccount),
                  trailing: Switch(
                    value: _userConfig!['privateProfile'],
                    onChanged: (val) {
                      setState(() {
                        _userConfig!['privateProfile'] = val;
                        _changedSetting = true;
                      });
                    },
                  ),
                  leading: _userConfig!['privateProfile']
                      ? const Icon(Icons.lock)
                      : const Icon(Icons.lock_open),
                ),
                const SizedBox(height: 8),
                ListTile(
                  onTap: () => setState(() {
                    _userConfig!["likesEnabled"] =
                        !_userConfig!["likesEnabled"];
                    _changedSetting = true;
                  }),
                  contentPadding: EdgeInsets.zero,
                  title: Text(localize.allowLikes),
                  trailing: Switch(
                    value: _userConfig!['likesEnabled'],
                    onChanged: (val) {
                      setState(() {
                        _userConfig!['likesEnabled'] = val;
                        _changedSetting = true;
                      });
                    },
                  ),
                  leading: _userConfig!['likesEnabled']
                      ? const Icon(Icons.favorite)
                      : Icon(Icons.heart_broken_outlined),
                ),
                const SizedBox(height: 8),
                ListTile(
                  onTap: () => setState(() {
                    _userConfig!["pointsEnabled"] =
                        !_userConfig!["pointsEnabled"];
                    _changedSetting = true;
                  }),
                  contentPadding: EdgeInsets.zero,
                  title: Text(localize.collectPoints),
                  trailing: Switch(
                    value: _userConfig!['pointsEnabled'],
                    onChanged: (val) {
                      setState(() {
                        _userConfig!['pointsEnabled'] = val;
                        _changedSetting = true;
                      });
                    },
                  ),
                  leading: _userConfig!['pointsEnabled']
                      ? const Icon(Icons.star_rounded)
                      : const Icon(Icons.star_outline_rounded),
                ),
                const SizedBox(height: 8),
                ListTile(
                  onTap: () => setState(() {
                    _enabledArchive = !_enabledArchive;
                    _changedSetting = true;
                  }),
                  contentPadding: EdgeInsets.zero,
                  title: Text(localize.hideCheckIns),
                  trailing: Switch(
                    value: _enabledArchive,
                    onChanged: (val) {
                      setState(() {
                        _enabledArchive = !_enabledArchive;
                        _changedSetting = true;
                      });
                    },
                  ),
                  leading: _enabledArchive
                      ? const Icon(Icons.archive)
                      : const Icon(Icons.archive_outlined),
                ),
                if (_enabledArchive) ...[
                  TextFormField(
                    initialValue: _userConfig!["privacyHideDays"].toString(),
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (int.tryParse(value ?? "INT") == null) {
                        return localize.noOfDaysValid;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(localize.noOfDays),
                      suffix: Text(
                        localize.days(
                          int.tryParse(
                                _userConfig!["privacyHideDays"].toString(),
                              ) ??
                              0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _userConfig!["privacyHideDays"] =
                          int.tryParse(value) ?? 0;
                    },
                  ),
                ],
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(localize.trustedUsersSelectTitle),
                ),
                SegmentedButton(
                  selected: <TrustedTypeEnum>{
                    TrustedTypeEnum.fromValue(_userConfig!["friendCheckin"]),
                  },
                  showSelectedIcon: true,
                  onSelectionChanged: (Set<TrustedTypeEnum> val) =>
                      setState(() {
                        _changedSetting = true;
                        _userConfig!["friendCheckin"] = val.first.value;
                      }),
                  segments: [
                    ButtonSegment(
                      value: TrustedTypeEnum.list,
                      icon: const Icon(Icons.how_to_reg),
                      label: Text(
                        localize.trustedUsers,
                        textAlign: TextAlign.center,
                      ),
                      tooltip: localize.trustedUsers,
                    ),
                    ButtonSegment(
                      value: TrustedTypeEnum.friends,
                      icon: const Icon(Icons.group),
                      label: Text(localize.friends),
                      tooltip: localize.friendsExplanation,
                    ),
                    ButtonSegment(
                      value: TrustedTypeEnum.forbidden,
                      icon: const Icon(Icons.block),
                      label: Text(localize.noTrustedCheckIn),
                      tooltip: localize.noTrustedCheckIn,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifyTrustedUsers(),
                    ),
                  ),
                  label: Text(localize.setupTrustedUsers),
                  icon: const Icon(Icons.how_to_reg),
                ),
                Divider(),
                ListTile(
                  title: Text(localize.defaultVisibilitySelectTitle),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
                SegmentedButton(
                  onSelectionChanged: (val) => setState(() {
                    _changedSetting = true;
                    _userConfig!["defaultStatusVisibility"] = val.first;
                  }),
                  showSelectedIcon: false,
                  selected: <int>{_userConfig!["defaultStatusVisibility"]},
                  segments: TripVisibilityEnum.values.map((
                    TripVisibilityEnum tve,
                  ) {
                    return ButtonSegment(
                      value: tve.value,
                      tooltip: _getVisibilityString(tve, null, localize),
                      icon: Icon(tve.icon),
                    );
                  }).toList(),
                ),
                Divider(),
                if (_userConfig!["mastodon"] != null) ...[
                  ListTile(
                    title: Text(
                      localize.mastodonVisibilitySelectTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 4),
                  SegmentedButton(
                    onSelectionChanged: (val) => setState(() {
                      _changedSetting = true;

                      _userConfig!["mastodonVisibility"] = val.first;
                    }),
                    showSelectedIcon: false,
                    selected: <int>{_userConfig!["mastodonVisibility"]},
                    segments: MastodonVisibility.values.map((
                      MastodonVisibility mve,
                    ) {
                      return ButtonSegment(
                        value: mve.value,
                        tooltip: _getVisibilityString(null, mve, localize),
                        icon: Icon(mve.icon),
                      );
                    }).toList(),
                  ),
                  Divider(),
                ],
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    setState(() {
                      _waitForRefresh = true;
                    });
                    try {
                      await getIt<ApiService>().refreshToken();
                    } catch (e) {
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ErrorPage(
                            errorInfo: (e is ErrorInfo
                                ? e
                                : ErrorInfo(
                                    "Returned Exception was of unexpected type ${e.runtimeType.toString()}",
                                    type: ErrorType.unknown,
                                    exception: e,
                                  )),
                          ),
                        ),
                      );
                    }

                    setState(() {
                      _waitForRefresh = false;
                    });
                    _getTokenExpire();
                  },
                  title: Text(localize.refreshTokenTitle),
                  subtitle: Text(
                    localize.refreshTokenSubtitle(
                      DateFormat.yMd(
                        Localizations.localeOf(context).languageCode,
                      ).format(_tokenExpire ?? DateTime.parse("1970-01-01")),
                    ),
                  ),
                  leading: _waitForRefresh
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.refresh),
                ),
                Divider(),
                ListTile(
                  onTap: () => SharedFunctions.launchURL(
                    Uri.parse("https://traewelling.de/settings/profile"),
                    launchMode: LaunchMode.externalApplication,
                  ),
                  contentPadding: EdgeInsets.zero,
                  title: Text(localize.moreSettings),
                  subtitle: Text(localize.moreSettingsSub),
                  leading: const Icon(Icons.open_in_new),
                ),
                Divider(),
                ListTile(
                  onTap: () async {
                    await getIt<ApiService>().logOut();
                    TerminateRestart.instance.restartApp(
                      options: const TerminateRestartOptions(
                        terminate: true,
                        clearData: true,
                      ),
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(localize.logOut),
                  subtitle: Text(localize.logOutNotice),
                  leading: const Icon(Icons.logout),
                ),
                const SizedBox(height: 72),
              ],
            );
          },
        ),
      ),
    );
  }
}
