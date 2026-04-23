import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/notifications/push_enabled.dart';
import '../../../core/notifications/push_notifications_service.dart';
import '../../../core/storage/hive_service.dart';
import '../data/auth_providers.dart';
import '../data/models/login_request.dart';
import '../data/models/register_request.dart';
import '../data/models/update_profile_request.dart';
import '../data/models/user_dto.dart';

part 'auth_view_model.g.dart';

/// Not autoDispose: otherwise after login/navigation there can be a moment with
/// no listeners, the provider is disposed, and the next [build] calls `me()` again
/// → many `GET /api/v1/users/me` in a row (GoRouter `redirect` re-reads auth).
@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  Future<UserDto?> build() async {
    final token = HiveService.instance.accessToken;
    if (token == null) return null;

    final repo = ref.watch(authRepositoryProvider);
    final user = await repo.me();
    if (pushMessagingEnabled) {
      unawaited(
        PushNotificationsService.instance.syncToken(
          (req) => ref.read(authRepositoryProvider).registerFcmToken(req),
        ),
      );
    }
    return user;
  }

  bool get isAuthed => state.valueOrNull != null;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.login(
        LoginRequest(email: email, password: password),
      );
      await HiveService.instance.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      // AuthResponse.user often omits optional profile fields; /users/me is canonical.
      UserDto user = response.user;
      try {
        user = await repo.me();
      } catch (_) {
        // Keep embedded user if me() fails right after login (e.g. flaky network).
      }
      if (pushMessagingEnabled) {
        unawaited(
          PushNotificationsService.instance.syncToken(
            (req) => ref.read(authRepositoryProvider).registerFcmToken(req),
          ),
        );
      }
      return user;
    });
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.register(
        RegisterRequest(name: name, email: email, password: password),
      );
      await HiveService.instance.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      UserDto user = response.user;
      try {
        user = await repo.me();
      } catch (_) {
        // Same as [login]: prefer full profile from GET /users/me.
      }
      if (pushMessagingEnabled) {
        unawaited(
          PushNotificationsService.instance.syncToken(
            (req) => ref.read(authRepositoryProvider).registerFcmToken(req),
          ),
        );
      }
      return user;
    });
  }

  /// Refetch profile without going to [AsyncLoading] (avoids flashing the profile skeleton).
  Future<void> reloadMeFromServerSilently() async {
    if (HiveService.instance.accessToken == null) return;
    try {
      final user = await ref.read(authRepositoryProvider).me();
      state = AsyncData(user);
    } catch (_) {
      // Keep current [state] on failure (offline, etc.).
    }
  }

  Future<void> refreshMe() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      return repo.me();
    });
  }

  Future<void> updateProfile({
    String? name,
    String? currencyDefault,
    String? transferComment,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      return repo.updateMe(
        UpdateProfileRequest(
          name: name,
          currencyDefault: currencyDefault,
          transferComment: transferComment,
        ),
      );
    });
  }

  Future<void> logout() async {
    final refreshToken = HiveService.instance.refreshToken;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (refreshToken != null) {
        final repo = ref.read(authRepositoryProvider);
        await repo.logout(refreshToken: refreshToken);
      }
      if (pushMessagingEnabled) {
        await PushNotificationsService.instance.clearLocalRegistration();
      }
      await HiveService.instance.clearTokens();
      return null;
    });
  }
}

