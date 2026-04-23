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

  Map<String, dynamic> _cachedGroupsByUserMap() {
    final raw = _cacheBox.get(HiveKeys.cachedGroupsByUser);
    if (raw is Map) {
      return raw.map(
        (k, v) => MapEntry(k.toString(), v),
      );
    }
    return <String, dynamic>{};
  }

  Future<void> _migrateLegacyGroupsIntoMapIfNeeded() async {
    final hasLegacyOwner = _cacheBox.containsKey(HiveKeys.cachedGroupsOwnerId);
    final hasLegacyList = _cacheBox.containsKey(HiveKeys.cachedGroups);
    if (!hasLegacyOwner && !hasLegacyList) return;

    final map = _cachedGroupsByUserMap();
    final legacyOwner = _cacheBox.get(HiveKeys.cachedGroupsOwnerId) as String?;
    final legacyList = _cacheBox.get(HiveKeys.cachedGroups);
    if (legacyOwner != null &&
        legacyOwner.isNotEmpty &&
        legacyList is List &&
        legacyList.isNotEmpty &&
        !map.containsKey(legacyOwner)) {
      map[legacyOwner] = legacyList.map(_deepConvertJsonValue).toList();
    }
    await _cacheBox.delete(HiveKeys.cachedGroupsOwnerId);
    await _cacheBox.delete(HiveKeys.cachedGroups);
    if (map.isNotEmpty) {
      await _cacheBox.put(HiveKeys.cachedGroupsByUser, map);
    }
  }

  /// Offline group list for account [userId] (separate from other users on this device).
  Future<List<Map<String, dynamic>>> cachedGroupsForUser(String userId) async {
    if (!_isInitialized) return const [];
    if (userId.isEmpty) return const [];
    await _migrateLegacyGroupsIntoMapIfNeeded();

    final map = _cachedGroupsByUserMap();
    final entry = map[userId];
    if (entry is! List) return const [];
    return entry.whereType<Map>().map(_deepStringKeyedMap).toList();
  }

  Future<void> setCachedGroupsForUser(
    String userId,
    List<Map<String, dynamic>> groupsJson,
  ) async {
    if (!_isInitialized) await init();
    if (userId.isEmpty) return;
    await _migrateLegacyGroupsIntoMapIfNeeded();

    final map = _cachedGroupsByUserMap();
    map[userId] = groupsJson;
    await _cacheBox.put(HiveKeys.cachedGroupsByUser, map);
  }

  /// Clears all per-user group lists and legacy keys (e.g. debug / no session).
  Future<void> clearGroupListCache() async {
    if (!_isInitialized) await init();
    await _cacheBox.delete(HiveKeys.cachedGroupsByUser);
    await _cacheBox.delete(HiveKeys.cachedGroupsOwnerId);
    await _cacheBox.delete(HiveKeys.cachedGroups);
  }
}

