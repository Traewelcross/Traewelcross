import 'package:flutter/material.dart';
import 'package:traewelcross/components/error.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/error_info.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.errorInfo});
  final ErrorInfo errorInfo;
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;

    return MainScaffold(
      backButton: false,
      title: Text(localize.errorTitle),
      body: ErrorDisplayWidget(errorInfo: errorInfo, isPage: true),
    );
  }
}
