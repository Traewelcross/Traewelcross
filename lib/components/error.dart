import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:traewelcross/enums/error_type.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/error_info.dart';
import 'package:traewelcross/utils/shared.dart';

class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    super.key,
    required this.errorInfo,
    required this.isPage,
  });
  final ErrorInfo errorInfo;
  final bool isPage;
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    final errorTypeText = switch (errorInfo.type) {
      ErrorType.logInError => localize.errorTypeLogin,
      ErrorType.unknown => localize.errorTypeUnknown,
      ErrorType.httpError => localize.errorTypeHttp,
    };
    final troubleshootText = switch (errorInfo.type) {
      ErrorType.logInError => localize.errorTypeLoginTroubleshoot,
      _ => "",
    };
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          if (errorInfo.httpStatusCode == null)
            Icon(
              isPage
                  ? Icons.sentiment_very_dissatisfied_outlined
                  : Icons.sentiment_dissatisfied_outlined,
              size: 96,
            ),
          if (errorInfo.httpStatusCode != null)
            SizedBox(
              height: 512,
              child: Image.network(
                "https://http.cat/${errorInfo.httpStatusCode}",
                fit: BoxFit.scaleDown,
              ),
            ),
          const SizedBox(height: 8),
          MarkdownBody(
            data: localize.errorText(
              errorTypeText,
              "${errorInfo.message}${errorInfo.httpStatusCode != null ? " (${errorInfo.httpStatusCode})" : ""}",
            ),
            styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center),
          ),
          Card(
            clipBehavior: Clip.hardEdge,
            child: ExpansionTile(
              shape: Border.all(color: Colors.transparent),
              title: Text(localize.errorDetail),
              children: [
                SelectableText(
                  errorInfo.exception.toString(),
                  style: TextStyle(fontFamily: "monospace"),
                ),
              ],
            ),
          ),
          Text(localize.errorTroubleshoot, textAlign: TextAlign.center),
          Divider(),
          Text(troubleshootText, textAlign: TextAlign.center),
          Divider(),
          Text(localize.errorTroubleshootSuffix, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          if (isPage) ...[
            FilledButton.icon(
              onPressed: () => TerminateRestart.instance.restartApp(
                options: TerminateRestartOptions(),
              ),
              label: Text(localize.errorTroubleshootButtonRestart),
              icon: const Icon(Icons.restart_alt),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                FlutterSecureStorage().deleteAll();
                SharedPreferencesAsync().clear();
                getIt<ApiService>().logOut();
                TerminateRestart.instance.restartApp(
                  options: TerminateRestartOptions(clearData: true),
                );
              },
              label: Text(localize.errorTroubleshootButtonLogout),
              icon: const Icon(Icons.delete),
            ),
            SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => {
                SharedFunctions.launchURL(SharedFunctions.repoURI),
              },
              label: Text(localize.errorTroubleshootButtonGithub),
              icon: const Icon(Icons.open_in_new),
            ),
          ],
        ],
      ),
    );
  }
}
