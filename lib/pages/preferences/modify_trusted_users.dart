import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/profile_link_button.dart';
import 'package:traewelcross/dialogs/add_trusted_user.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class ModifyTrustedUsers extends StatefulWidget {
  const ModifyTrustedUsers({super.key});

  @override
  State<ModifyTrustedUsers> createState() => _ModifyTrustedUsersState();
}

class _ModifyTrustedUsersState extends State<ModifyTrustedUsers> {
  late Future<List<TrustedUser>> _users;

  Future<List<TrustedUser>> _getTrustedUsers() async {
    final response = await getIt<ApiService>().user.getTrustedUsers();
    return response;
  }

  Future<void> _stopTrust(int id) async {
    setState(() {
      _users = Future<List<TrustedUser>>.value(List<TrustedUser>.empty());
    });
    final response = await getIt<ApiService>().user.stopTrust(id);
    if (response.wasSuccess) {
      setState(() {
        _users = _getTrustedUsers();
      });
    } else {
      return Future.error(Exception("${response.body}"));
    }
  }

  Future<void> _startTrust(int user, DateTime? expire) async {
    final response = await getIt<ApiService>().user.startTrust(user, expire);
    if (response.wasSuccess) {
      setState(() {
        _users = Future<List<TrustedUser>>.value(List<TrustedUser>.empty());
      });
      setState(() {
        _users = _getTrustedUsers();
      });
    } else {
      if (!mounted) return;
      return Future.error("${response.body}");
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
                TrustedUser user = asyncSnapshot.data![index];
                return ProfileLinkButton(
                  user: user.user.promoteToUser(),
                  subTitle: user.expiresAt != null
                      ? localize.expiresAt(
                          DateFormat.yMMMMEEEEd(
                            Localizations.localeOf(context).languageCode,
                          ).add_Hm().format(DateTime.parse(user.expiresAt!)),
                        )
                      : null,
                  action: IconButton(
                    onPressed: () => _stopTrust(user.user.id),
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
