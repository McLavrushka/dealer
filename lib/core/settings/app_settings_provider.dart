import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/hive_service.dart';

/// Stored in Hive as `system` | `ru` | `en`.
enum AppLocalePreference {
  system,
  ru,
  en,
}

AppLocalePreference appLocalePreferenceFromHive(String code) {
  switch (code.toLowerCase()) {
    case 'system':
      return AppLocalePreference.system;
    case 'en':
      return AppLocalePreference.en;
    case 'ru':
    default:
      return AppLocalePreference.ru;
  }
}

extension AppLocalePreferenceStorage on AppLocalePreference {
  /// `null` means follow device locale (within [AppLocalizations.supportedLocales]).
  Locale? get materialLocale => switch (this) {
        AppLocalePreference.system => null,
        AppLocalePreference.ru => const Locale('ru'),
        AppLocalePreference.en => const Locale('en'),
      };

  String get hiveCode => switch (this) {
        AppLocalePreference.system => 'system',
        AppLocalePreference.ru => 'ru',
        AppLocalePreference.en => 'en',
      };
}

class AppSettingsState {
  const AppSettingsState({
    required this.themeMode,
    required this.localePreference,
  });

  final ThemeMode themeMode;
  final AppLocalePreference localePreference;

  Locale? get materialLocale => localePreference.materialLocale;

  factory AppSettingsState.fromHive() {
    return AppSettingsState(
      themeMode: HiveService.instance.themeModePreference,
      localePreference:
          appLocalePreferenceFromHive(HiveService.instance.localePreferenceCode),
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  @override
  AppSettingsState build() => AppSettingsState.fromHive();

  Future<void> setThemeMode(ThemeMode mode) async {
    await HiveService.instance.setThemeModePreference(mode);
    state = AppSettingsState.fromHive();
  }

  Future<void> setLocalePreference(AppLocalePreference pref) async {
    await HiveService.instance.setLocalePreferenceCode(pref.hiveCode);
    state = AppSettingsState.fromHive();
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(AppSettingsNotifier.new);
