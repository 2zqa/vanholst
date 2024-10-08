import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/settings/data/settings_repository.dart';
import 'package:vanholst/src/features/settings/domain/settings.dart';

class SettingsService {
  final SettingsRepository settingsRepository;

  SettingsService(this.settingsRepository);

  Future<void> setTheme(ThemeMode? themeMode) async {
    if (themeMode == null) return;
    final settings = settingsRepository.currentSettings;
    final Settings updatedSettings = settings.copyWith(themeMode: themeMode);
    return settingsRepository.storeSettings(updatedSettings);
  }

  Future<void> setLocale(String? localeString) async {
    if (localeString == null) return;
    final settings = settingsRepository.currentSettings;
    final Locale? locale =
        localeString.isNotEmpty ? Locale(localeString) : null;
    final Settings updatedSettings = settings.copyWith(locale: () => locale);
    return settingsRepository.storeSettings(updatedSettings);
  }
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(settingsRepositoryProvider));
});
