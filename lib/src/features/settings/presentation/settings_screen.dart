import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vanholst/src/common_widgets/link_text.dart';
import 'package:vanholst/src/constants/uris.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/home_app_bar.dart';
import 'package:vanholst/src/features/settings/data/package_info_repository.dart';
import 'package:vanholst/src/features/settings/presentation/language_tile.dart';
import 'package:vanholst/src/features/settings/presentation/theme_tile.dart';

const double optionWidth = 175.0;

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
              tiles: <SettingsTile>[
                _reportBugButton(localizations),
                _buildPackageInfoTile(localizations, ref),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SettingsTile _buildPackageInfoTile(AppLocalizations l, WidgetRef ref) {
    return SettingsTile(
      leading: const Icon(Icons.info_outline),
      title: Text(l.settingsAbout),
      onPressed: (context) async {
        final packageInfo =
            await ref.read(packageInfoRepositoryProvider).getPackageInfo();

        if (!context.mounted) return;
        showAboutDialog(
          context: context,
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version,
          applicationIcon: Image.asset(
            'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.webp',
            width: 48,
          ),

          // DateTime.now().year — Simple yet elegant, if I do say so myself
          applicationLegalese: "© ${DateTime.now().year} Marijn Kok",

          children: [
            Text("${l.appDescription}\n",
                style: const TextStyle(fontStyle: FontStyle.italic)),
            LinkText(
              l.settingsSourceCodeInfo,
              uriText: "GitHub",
              uri: Uris.sourceCodeUrl,
            ),
          ],
        );
      },
    );
  }

  SettingsTile _reportBugButton(AppLocalizations l) {
    return SettingsTile(
      leading: const Icon(Icons.mail_outline),
      title: Text(l.settingsReportIssue),
      onPressed: (context) async {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(Icons.bug_report_outlined),
              title: Text(l.settingsReportIssue),
              content: Text(l.settingsReportIssueDescription(
                  l.settingsSend.toLowerCase())),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child:
                      Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    unawaited(launchUrl(Uris.supportMail));
                  },
                  child: Text(l.settingsSend),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
