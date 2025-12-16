import 'package:flutter/material.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/pages/login/desktop_auth_view.dart';
import 'package:traewelcross/utils/authentication.dart';
import 'package:traewelcross/utils/shared.dart';
import '../../l10n/app_localizations.dart';
import '../app_info.dart';

class OauthLogin extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const OauthLogin({super.key, required this.onLoginSuccess});

  @override
  State<OauthLogin> createState() => _OauthLoginState();
}

class _OauthLoginState extends State<OauthLogin> {
  bool _offerAlt = false;
  Future<void> _handleLogin(BuildContext context) async {
    await AuthService().loginWithPKCE();

    // On desktop, navigate to the view where the user can paste the callback URL.
    if (SharedFunctions.isDesktop && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              DesktopAuthCallbackView(onLoginSuccess: widget.onLoginSuccess),
        ),
      );
    }
    // On mobile, the app link handler in main.dart will take care of the rest.
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 64, 16, 8),
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    localize.welcome,
                    style: theme.textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localize.introText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _offerAlt = true;
                      });
                      _handleLogin(context);
                    },
                    label: Text(localize.addAccountBtn),
                    icon: const Icon(Icons.open_in_new),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(localize.activateNotifications),
                      trailing: Switch(
                        value:
                            getIt<Config>().notification.notificationsEnabled,
                        onChanged: (val) => setState(() {
                          getIt<Config>().notification.notificationsEnabled =
                              val;
                        }),
                      ),
                    ),
                  ),
                  if (_offerAlt)
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          localize.offerAlt,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DesktopAuthCallbackView(
                                  onLoginSuccess: widget.onLoginSuccess,
                                ),
                              ),
                            );
                          },
                          label: Text(localize.altLoginBtn),
                          icon: const Icon(Icons.login),
                        ),
                      ],
                    ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppInfo(),
                          ),
                        );
                      },
                      style: const ButtonStyle(
                        side: WidgetStatePropertyAll(
                          BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: const Text("Information"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
