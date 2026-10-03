import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/config/config.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/shared.dart';

class MiscPreferences extends StatefulWidget {
  const MiscPreferences({super.key});

  @override
  State<MiscPreferences> createState() => _MiscPreferencesState();
}

class _MiscPreferencesState extends State<MiscPreferences> {
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    Config config = getIt<Config>();
    return MainScaffold(
      title: Text(localize.behavior),
      body: ListView(
        children: [

        ],
      ),
    );
  }
}
