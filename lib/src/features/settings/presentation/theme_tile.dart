import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vanholst/src/common_widgets/async_value_widget.dart';
import 'package:vanholst/src/features/settings/data/settings_repository.dart';
import 'package:vanholst/src/features/settings/domain/settings.dart';
import 'package:vanholst/src/utils/radio_button_dialog.dart';

class ThemeTile extends AbstractSettingsTile {
  const ThemeTile({super.key});

  String _themeModeToString(ThemeMode themeMode, AppLocalizations l) {
    return switch (themeMode) {
      ThemeMode.light => l.settingsLightTheme,
      ThemeMode.dark => l.settingsDarkTheme,
      ThemeMode.system => l.settingsSystemTheme,
    };
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Consumer(
      builder: (context, ref, child) {
        final settingsValue = ref.watch(settingsProvider);
        final settingsRepository = ref.read(settingsRepositoryProvider);
        return AsyncValueWidget(
          value: settingsValue,
          data: (settings) {
            final String themeModeLabel =
                _themeModeToString(settings.themeMode, localizations);
            return SettingsTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: Text(localizations.settingsTheme),
              value: Text(themeModeLabel),
              onPressed: (context) async {
                // TODO: move to service
                final ThemeMode? themeMode = await showRadioDialog<ThemeMode>(
                  context: context,
                  values: ThemeMode.values,
                  labelBuilder: (themeMode) =>
                      _themeModeToString(themeMode, localizations),
                  title: Text(localizations.settingsTheme),
                );

                if (themeMode == null) return;
                final Settings updatedSettings = settings.copyWith(
                  themeMode: themeMode,
                );
                return settingsRepository.storeSettings(updatedSettings);
              },
            );
          },
        );
      },
    );
  }
}
