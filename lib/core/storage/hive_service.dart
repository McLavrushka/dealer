import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';

import 'hive_keys.dart';

class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  late final Box<dynamic> _appBox;
  late final Box<dynamic> _authBox;
  late final Box<dynamic> _cacheBox;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    await Hive.initFlutter();
    _appBox = await Hive.openBox<dynamic>(HiveBoxes.app);
    _authBox = await Hive.openBox<dynamic>(HiveBoxes.auth);
    _cacheBox = await Hive.openBox<dynamic>(HiveBoxes.cache);
    _isInitialized = true;
  }

  bool get onboardingShown {
    if (!_isInitialized) return false;
    return (_appBox.get(HiveKeys.onboardingShown) as bool?) ?? false;
  }

  Future<void> setOnboardingShown() async {
    if (!_isInitialized) await init();
    await _appBox.put(HiveKeys.onboardingShown, true);
  }

  /// Invite code from a deep link when the user still has to log in / finish onboarding.
  String? get pendingInviteCode {
    if (!_isInitialized) return null;
    final v = _appBox.get(HiveKeys.pendingInviteCode);
    if (v is! String || v.trim().isEmpty) return null;
    return v.trim();
  }

  void setPendingInviteCode(String code) {
    if (!_isInitialized) return;
    _appBox.put(HiveKeys.pendingInviteCode, code.trim());
  }

  Future<void> clearPendingInviteCode() async {
    if (!_isInitialized) return;
    await _appBox.delete(HiveKeys.pendingInviteCode);
  }

  /// `ThemeMode.system` | `light` | `dark`. Default: system.
  ThemeMode get themeModePreference {
    if (!_isInitialized) return ThemeMode.system;
    final raw = _appBox.get(HiveKeys.themeMode);
    if (raw == 'light') return ThemeMode.light;
    if (raw == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> setThemeModePreference(ThemeMode mode) async {
    if (!_isInitialized) await init();
    final s = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _appBox.put(HiveKeys.themeMode, s);
  }

  /// `system` | `ru` | `en`. Default: `ru` (previous app default).
  String get localePreferenceCode {
    if (!_isInitialized) return 'ru';
    final raw = _appBox.get(HiveKeys.appLocale);
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    return 'ru';
  }

  Future<void> setLocalePreferenceCode(String code) async {
    if (!_isInitialized) await init();
    final c = code.trim().toLowerCase();
    if (c == 'system' || c == 'ru' || c == 'en') {
      await _appBox.put(HiveKeys.appLocale, c);
    }
  }

  String? get accessToken {
    if (!_isInitialized) return null;
    return _authBox.get(HiveKeys.accessToken) as String?;
  }

  String? get refreshToken {
    if (!_isInitialized) return null;
    return _authBox.get(HiveKeys.refreshToken) as String?;
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    if (!_isInitialized) await init();
    await _authBox.put(HiveKeys.accessToken, accessToken);
    await _authBox.put(HiveKeys.refreshToken, refreshToken);
  }

  Future<void> clearTokens() async {
    if (!_isInitialized) return;
    await _authBox.delete(HiveKeys.accessToken);
    await _authBox.delete(HiveKeys.refreshToken);
  }

  Future<void> clearAll() async {
    if (!_isInitialized) return;
    await _appBox.clear();
    await _authBox.clear();
    await _cacheBox.clear();
  }

  Map<String, dynamic> _deepStringKeyedMap(Object? value) {
    if (value is Map) {
      return value.map(
        (k, v) => MapEntry(k.toString(), _deepConvertJsonValue(v)),
      );
    }
    return const <String, dynamic>{};
  }

  dynamic _deepConvertJsonValue(Object? value) {
    if (value is Map) {
      return value.map(
        (k, v) => MapEntry(k.toString(), _deepConvertJsonValue(v)),
      );
    }
    if (value is List) {
      return value.map(_deepConvertJsonValue).toList();
    }
    return value;
  }

  List<Map<String, dynamic>> get cachedGroups {
    if (!_isInitialized) return const [];
    final raw = _cacheBox.get(HiveKeys.cachedGroups);
    if (raw is List) {
      return raw.whereType<Map>().map(_deepStringKeyedMap).toList();
    }
    return const [];
  }

  Future<void> setCachedGroups(List<Map<String, dynamic>> groupsJson) async {
    if (!_isInitialized) await init();
    await _cacheBox.put(HiveKeys.cachedGroups, groupsJson);
  }
}

