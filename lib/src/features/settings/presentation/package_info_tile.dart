import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vanholst/src/common_widgets/link_text.dart';
import 'package:vanholst/src/constants/uris.dart';
import 'package:vanholst/src/features/settings/data/package_info_repository.dart';

class PackageInfoTile extends AbstractSettingsTile {
  const PackageInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Consumer(builder: (context, ref, child) {
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
    });
  }
}
