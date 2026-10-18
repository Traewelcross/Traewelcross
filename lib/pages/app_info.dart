import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../components/license_viewer.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final width75 = size.width * 0.75;
    return MainScaffold(
      title: AppBarTitle("Info"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(localize.licenses(0)),
                          content: SizedBox(
                            width: width75,
                            child: LicenseViewer(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(localize.close),
                            ),
                          ],
                        ),
                      ),
                      label: Text(localize.viewLicensesBtn),
                      icon: const Icon(Symbols.license),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        SharedFunctions.launchURL(SharedFunctions.repoURI);
                      },
                      label: Text(localize.viewProjectBtn),
                      icon: const Icon(Symbols.code),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        SharedFunctions.launchURL(
                          Uri.parse("https://traewelcross.de/privacy.html"),
                          launchMode: LaunchMode.externalApplication,
                        );
                      },
                      label: Text(localize.viewImprintBtn),
                      icon: const Icon(Icons.privacy_tip),
                    ),
                  ),
                  const Spacer(),
                  ProviderInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderInfo extends StatefulWidget {
  const ProviderInfo({
    super.key,
  });

  @override
  State<ProviderInfo> createState() => _ProviderInfoState();
}

class _ProviderInfoState extends State<ProviderInfo> {
  late final Future<ProviderConfigInfo> info;
  @override
  void initState(){
    super.initState();
    info = getIt<ApiService>().misc.getConfiguration();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: info,
      builder: (ctx, snp) {
        if (snp.connectionState == .done) {
          if (snp.hasData) {
            return Column(
              children: [
                Text(
                  AppLocalizations.of(ctx)!.appInfo(
                    snp.data!.appName,
                    Uri.parse(snp.data!.appUrl).host,
                    snp.data!.version,
                  ),
                  textAlign: .center,
                  style: TextStyle(fontStyle: .italic),
                ),
                const SizedBox(height: 6,)
              ],
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
