import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vanholst/src/common_widgets/async_value_widget.dart';
import 'package:vanholst/src/features/settings/application/settings_service.dart';
import 'package:vanholst/src/features/settings/data/settings_repository.dart';
import 'package:vanholst/src/utils/radio_button_dialog.dart';

class LanguageTile extends AbstractSettingsTile {
  const LanguageTile({super.key});

  String _localeToLanguage(Locale? locale, AppLocalizations localizations) {
    if (locale == null) return localizations.settingsSystemLanguage;
    return LocaleNamesLocalizationsDelegate
            .nativeLocaleNames[locale.toLanguageTag()] ??
        locale.toLanguageTag();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Consumer(
      builder: (context, ref, child) {
        final settingsValue = ref.watch(settingsProvider);
        final settingsService = ref.watch(settingsServiceProvider);
        const locales = AppLocalizations.supportedLocales;
        return AsyncValueWidget(
          value: settingsValue,
          data: (settings) {
            final localeLabel =
                _localeToLanguage(settings.locale, localizations);
            return SettingsTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(localizations.settingsLanguage),
              value: Text(localeLabel),
              onPressed: (context) async {
                final localeString = await showRadioDialog(
                  title: Text(localizations.settingsLanguage),
                  context: context,
                  values: ['', ...locales.map((l) => l.toLanguageTag())],
                  labelBuilder: (value) {
                    if (value.isEmpty) {
                      return localizations.settingsSystemLanguage;
                    }
                    return LocaleNamesLocalizationsDelegate
                            .nativeLocaleNames[value] ??
                        value;
                  },
                );
                await settingsService.setLocale(localeString, settings);
              },
            );
          },
        );
      },
    );
  }
}
