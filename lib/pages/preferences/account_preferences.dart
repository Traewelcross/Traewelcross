import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/own_profile_picture.dart';
import 'package:traewelcross/enums/trusted_type_enum.dart';
import 'package:traewelcross/enums/mastodon_visibility.dart';
import 'package:traewelcross/enums/trip_visibility.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/preferences/modify_trusted_users.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPreferences extends StatefulWidget {
  const AccountPreferences({super.key});

  @override
  State<AccountPreferences> createState() => _AccountPreferencesState();
}

class _AccountPreferencesState extends State<AccountPreferences> {
  bool _changedSetting = false;
  bool _applying = false;
  UserProfileSettings? _userConfig;
  late Future<UserProfileSettings> _userConfigF;
  @override
  void initState() {
    super.initState();
    _userConfigF = _getUserConfig();
  }

  Future<UserProfileSettings> _getUserConfig() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.user.getSettings();
    return response;
  }

  Future<void> _saveSettings() async {
    if (_userConfig == null) return;
    setState(() {
      _applying = true;
    });
    UserProfileSettings u = _userConfig!;
    try {
      final res = await getIt<ApiService>().user.setSettings(_userConfig!);
      u = res.object;
    } catch (e) {
      SharedFunctions.sendSnackBar(e.toString());
      setState(() {
        _applying = false;
      });
      return;
    } finally {
      setState(() {
        _applying = false;
        _changedSetting = false;
        _userConfig = u;
      });
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
      TripVisibilityEnum.trusted => localize.trustedUsers,

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
        body: FutureBuilder(
          future: _userConfigF,
          builder: (ctx, snp) {
            if (snp.connectionState == .waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snp.hasError) {
              return Center(
                child: Column(
                  children: [
                    const Icon(Icons.error),
                    Text(snp.error.toString()),
                  ],
                ),
              );
            }
            if (snp.connectionState == .done && snp.hasData) {
              _userConfig = snp.data!;
              final userConfig = _userConfig!;
              return ListView(
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    onChanged: (value) {
                      userConfig.username = value;
                      setState(() {
                        _changedSetting = true;
                      });
                    },
                    initialValue: userConfig.username,
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
                      userConfig.displayName = value;
                      setState(() {
                        _changedSetting = true;
                      });
                    },
                    initialValue: userConfig.displayName,
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
                      userConfig.bio = value;
                      setState(() {
                        _changedSetting = true;
                      });
                    },
                    initialValue: userConfig.bio,
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
                      userConfig.privateProfile = !userConfig.privateProfile;
                      _changedSetting = true;
                    }),
                    contentPadding: EdgeInsets.zero,
                    title: Text(localize.privateAccount),
                    trailing: Switch(
                      value: userConfig.privateProfile,
                      onChanged: (val) {
                        setState(() {
                          userConfig.privateProfile = val;
                          _changedSetting = true;
                        });
                      },
                    ),
                    leading: userConfig.privateProfile
                        ? const Icon(Icons.lock)
                        : const Icon(Icons.lock_open),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    onTap: () => setState(() {
                      userConfig.likesEnabled = !userConfig.likesEnabled;
                      _changedSetting = true;
                    }),
                    contentPadding: EdgeInsets.zero,
                    title: Text(localize.allowLikes),
                    trailing: Switch(
                      value: userConfig.likesEnabled,
                      onChanged: (val) {
                        setState(() {
                          userConfig.likesEnabled = val;
                          _changedSetting = true;
                        });
                      },
                    ),
                    leading: userConfig.likesEnabled
                        ? const Icon(Icons.favorite)
                        : Icon(Icons.heart_broken_outlined),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    onTap: () => setState(() {
                      userConfig.pointsEnabled = !userConfig.pointsEnabled;
                      _changedSetting = true;
                    }),
                    contentPadding: EdgeInsets.zero,
                    title: Text(localize.collectPoints),
                    trailing: Switch(
                      value: userConfig.pointsEnabled,
                      onChanged: (val) {
                        setState(() {
                          userConfig.pointsEnabled = val;
                          _changedSetting = true;
                        });
                      },
                    ),
                    leading: userConfig.pointsEnabled
                        ? const Icon(Icons.star_rounded)
                        : const Icon(Icons.star_outline_rounded),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    onTap: () => setState(() {
                      if (userConfig.privacyHideDays == null) {
                        userConfig.privacyHideDays = 1;
                      } else {
                        userConfig.privacyHideDays = null;
                      }
                      _changedSetting = true;
                    }),
                    contentPadding: EdgeInsets.zero,
                    title: Text(localize.hideCheckIns),
                    trailing: Switch(
                      value: userConfig.privacyHideDays == null ? false : true,
                      onChanged: (val) {
                        setState(() {
                          if (userConfig.privacyHideDays == null) {
                            userConfig.privacyHideDays = 1;
                          } else {
                            userConfig.privacyHideDays = null;
                          }
                          _changedSetting = true;
                        });
                      },
                    ),
                    leading: userConfig.privacyHideDays == null
                        ? const Icon(Icons.archive)
                        : const Icon(Icons.archive_outlined),
                  ),
                  if (userConfig.privacyHideDays != null) ...[
                    TextFormField(
                      initialValue: userConfig.privacyHideDays.toString(),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (int.tryParse(value ?? "INT") == null ||
                            value == "0") {
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
                                  userConfig.privacyHideDays.toString(),
                                ) ??
                                0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        userConfig.privacyHideDays = int.tryParse(value) ?? 0;
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
                      TrustedTypeEnum.fromValue(userConfig.friendCheckin),
                    },
                    showSelectedIcon: true,
                    onSelectionChanged: (Set<TrustedTypeEnum> val) =>
                        setState(() {
                          _changedSetting = true;
                          userConfig.friendCheckin = val.first.value;
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
                      userConfig.defaultStatusVisibility = val.first;
                    }),
                    showSelectedIcon: false,
                    selected: <TripVisibilityEnum>{
                      userConfig.defaultStatusVisibility,
                    },
                    segments: TripVisibilityEnum.values.map((
                      TripVisibilityEnum tve,
                    ) {
                      return ButtonSegment(
                        value: tve,
                        tooltip: _getVisibilityString(tve, null, localize),
                        icon: Icon(tve.icon),
                      );
                    }).toList(),
                  ),
                  Divider(),
                  if (userConfig.mastodon != null) ...[
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

                        userConfig.mastodonVisibility = val.first;
                      }),
                      showSelectedIcon: false,
                      selected: <MastodonVisibility>{
                        userConfig.mastodonVisibility,
                      },
                      segments: MastodonVisibility.values.map((
                        MastodonVisibility mve,
                      ) {
                        return ButtonSegment(
                          value: mve,
                          tooltip: _getVisibilityString(null, mve, localize),
                          icon: Icon(mve.icon),
                        );
                      }).toList(),
                    ),
                    Divider(),
                  ],
                  /*ListTile(
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
                ),*/
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
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
