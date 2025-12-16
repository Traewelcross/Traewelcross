import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:traewelcross/utils/shared.dart';
import '../l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LicenseViewer extends StatelessWidget {
  const LicenseViewer({super.key});
  Future<PackageInfo> _getInfo() async {
    PackageInfo pkgInfo = await PackageInfo.fromPlatform();
    return pkgInfo;
  }

  Future<String> _getNotices() async {
    return await rootBundle.loadString('assets/notices/NOTICES.md');
  }

  Future<String> _getFontLicensesNotices() async {
    return await rootBundle.loadString('assets/notices/FONTS.md');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _getInfo(),
        _getNotices(),
        _getFontLicensesNotices(),
      ]),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasError) {
          return Center(child: Text(asyncSnapshot.error.toString()));
        }
        final packageInfo = asyncSnapshot.data![0] as PackageInfo;
        final notices = asyncSnapshot.data![1] as String;
        final fonts = asyncSnapshot.data![2] as String;
        return ListView(
          shrinkWrap: true,
          children: [
            Project(
              projectVersion: packageInfo.version,
              projectName: "Träwelcross",
              projectLicense: "",
              onClick: () {
                showLicensePage(context: context);
              },
            ),
            Divider(),
            Project(
              projectVersion: "",
              projectName: AppLocalizations.of(context)!.fonts,
              projectLicense: fonts,
            ),
            Project(
              projectVersion: "",
              projectName: AppLocalizations.of(context)!.addNotices,
              projectLicense: notices,
            ),
          ],
        );
      },
    );
  }
}

class Project extends StatelessWidget {
  const Project({
    super.key,
    required this.projectName,
    required this.projectVersion,
    required this.projectLicense,
    this.onClick,
  });

  final String projectName;
  final String projectVersion;
  final String? projectLicense;
  final Function()? onClick;
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextButton(
        onPressed:
            onClick ??
            () {
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localize.licenses(1)),
                  content: SingleChildScrollView(
                    child: MarkdownBody(
                      data: _getLicense(projectLicense, context),
                      onTapLink: (text, href, title) =>
                          SharedFunctions.launchURL(Uri.parse(href!)),
                      styleSheet: MarkdownStyleSheet(
                        code: MarkdownStyleSheet.fromTheme(Theme.of(context)).p,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(localize.close),
                    ),
                  ],
                ),
              );
            },
        child: Row(
          children: [
            Expanded(child: Text(projectName, overflow: TextOverflow.ellipsis)),
            Text(projectVersion),
          ],
        ),
      ),
    );
  }
}

String _getLicense(String? license, BuildContext context) {
  final localize = AppLocalizations.of(context)!;
  if (license == null) {
    return localize.noLicense;
  } else {
    return license;
  }
}
