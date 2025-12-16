import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/profile_link.dart';
import 'package:traewelcross/dialogs/add_trusted_user.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class ModifyTrustedUsers extends StatefulWidget {
  const ModifyTrustedUsers({super.key});

  @override
  State<ModifyTrustedUsers> createState() => _ModifyTrustedUsersState();
}

class _ModifyTrustedUsersState extends State<ModifyTrustedUsers> {
  late Future<List<dynamic>> _users;

  Future<List<dynamic>> _getTrustedUsers() async {
    final response = await getIt<ApiService>().request(
      "/user/self/trusted",
      HttpRequestTypes.GET,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    } else {
      return Future.error(
        Exception("(${response.statusCode}) ${response.body}"),
      );
    }
  }

  Future<void> _stopTrust(int id) async {
    setState(() {
      _users = Future<List<dynamic>>.value(List<dynamic>.empty());
    });
    final response = await getIt<ApiService>().request(
      "/user/self/trusted/$id",
      HttpRequestTypes.DELETE,
    );
    if (response.statusCode == 204) {
      setState(() {
        _users = _getTrustedUsers();
      });
    } else {
      return Future.error(
        Exception("(${response.statusCode}) ${response.body}"),
      );
    }
  }

  Future<void> _startTrust(int user, DateTime? expire) async {
    final response = await getIt<ApiService>().request(
      "/user/self/trusted",
      HttpRequestTypes.POST,
      body: jsonEncode({
        "userId": user,
        "expiresAt": expire?.toIso8601String(),
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        _users = Future<List<dynamic>>.value(List<dynamic>.empty());
      });
      setState(() {
        _users = _getTrustedUsers();
      });
    } else {
      if (!mounted) return;
      return Future.error("${response.statusCode} / ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    _users = _getTrustedUsers();
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: Text(localize.setupTrustedUsers),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AddTrustedUser(addCallback: _startTrust);
          },
        ),
        label: Text(localize.addTrust),
        icon: const Icon(Icons.person_add),
      ),
      body: FutureBuilder(
        future: _users,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error),
                  Text(asyncSnapshot.error.toString()),
                ],
              ),
            );
          }
          if (asyncSnapshot.hasData) {
            return ListView.builder(
              itemCount: asyncSnapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = asyncSnapshot.data![index];
                return ProfileLink(
                  userData: user["user"],
                  subTitle: user["expiresAt"] != null
                      ? localize.expiresAt(
                          DateFormat.yMMMMEEEEd(
                            Localizations.localeOf(context).languageCode,
                          ).add_Hm().format(DateTime.parse(user["expiresAt"])),
                        )
                      : null,
                  action: IconButton(
                    onPressed: () => _stopTrust(user["user"]["id"]),
                    icon: const Icon(Icons.person_remove),
                    tooltip: localize.stopTrust,
                  ),
                );
              },
            );
          }
          return const SizedBox(height: 0);
        },
      ),
    );
  }
}
