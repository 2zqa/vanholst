import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';
import 'package:vanholst/src/features/settings/presentation/language_tile.dart';
import 'package:vanholst/src/features/settings/presentation/package_info_tile.dart';
import 'package:vanholst/src/features/settings/presentation/report_issue_tile.dart';
import 'package:vanholst/src/features/settings/presentation/theme_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Scrollbar(
        child: SettingsList(
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).colorScheme.surface,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).colorScheme.surface,
          ),
          sections: [
            SettingsSection(
              title: Text(localizations.settingsCommonSection),
              tiles: const <AbstractSettingsTile>[
                ThemeTile(),
                LanguageTile(),
              ],
            ),
            SettingsSection(
              title: Text(localizations.settingsSupportSection),
              tiles: const <AbstractSettingsTile>[
                ReportIssueTile(),
                PackageInfoTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
