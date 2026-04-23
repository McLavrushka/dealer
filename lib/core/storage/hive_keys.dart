abstract final class HiveBoxes {
  static const app = 'app';
  static const auth = 'auth';
  static const cache = 'cache';
}

abstract final class HiveKeys {
  static const onboardingShown = 'onboarding_shown';
  static const pendingInviteCode = 'pending_invite_code';
  static const themeMode = 'theme_mode';
  static const appLocale = 'app_locale';

  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';

  /// `Map<String, List<Map>>` — group lists per [UserDto.id] (each account keeps its own list).
  static const cachedGroupsByUser = 'cached_groups_by_user';

  /// Legacy single-slot cache (pre–per-user map). Read only for one-time migration.
  static const cachedGroups = 'cached_groups';
  static const cachedGroupsOwnerId = 'cached_groups_owner_id';
}

