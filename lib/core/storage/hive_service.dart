import 'package:hive_flutter/hive_flutter.dart';

import 'hive_keys.dart';

class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  late final Box<dynamic> _appBox;
  late final Box<dynamic> _authBox;
  late final Box<dynamic> _cacheBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _appBox = await Hive.openBox<dynamic>(HiveBoxes.app);
    _authBox = await Hive.openBox<dynamic>(HiveBoxes.auth);
    _cacheBox = await Hive.openBox<dynamic>(HiveBoxes.cache);
  }

  bool get onboardingShown =>
      (_appBox.get(HiveKeys.onboardingShown) as bool?) ?? false;

  Future<void> setOnboardingShown() =>
      _appBox.put(HiveKeys.onboardingShown, true);

  String? get accessToken => _authBox.get(HiveKeys.accessToken) as String?;
  String? get refreshToken => _authBox.get(HiveKeys.refreshToken) as String?;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _authBox.put(HiveKeys.accessToken, accessToken);
    await _authBox.put(HiveKeys.refreshToken, refreshToken);
  }

  Future<void> clearTokens() async {
    await _authBox.delete(HiveKeys.accessToken);
    await _authBox.delete(HiveKeys.refreshToken);
  }

  Future<void> clearAll() async {
    await _appBox.clear();
    await _authBox.clear();
    await _cacheBox.clear();
  }
}

