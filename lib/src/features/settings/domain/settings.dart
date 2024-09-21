import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class Settings {
  /// The locale to use for the app. A null value means using the system
  /// locale.
  final Locale? locale;
  final ThemeMode themeMode;

  const Settings({
    this.locale,
    this.themeMode = ThemeMode.system,
  });

  Settings copyWith({
    ValueGetter<Locale?>? locale,
    ThemeMode? themeMode,
  }) {
    return Settings(
      locale: locale != null ? locale() : this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locale': locale?.toLanguageTag(),
      'themeMode': themeMode.name,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      locale: map['locale'] != null ? Locale(map['locale']) : null,
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == map['themeMode'],
        orElse: () => ThemeMode.system,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source));

  @override
  String toString() => 'Settings(locale: $locale, themeMode: $themeMode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings &&
        other.locale == locale &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => locale.hashCode ^ themeMode.hashCode;
}
