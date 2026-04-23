import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/hive_service.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../data/group_providers.dart';
import '../data/models/create_group_request.dart';
import '../data/models/group_dto.dart';
part 'groups_view_model.g.dart';

@riverpod
class GroupsViewModel extends _$GroupsViewModel {
  @override
  Future<List<GroupDto>> build() async {
    if (!HiveService.instance.isInitialized) {
      await HiveService.instance.init();
    }
    final userId = ref.watch(authViewModelProvider).valueOrNull?.id;
    if (userId == null || userId.isEmpty) return const [];

    final fromHive = await _groupsFromHive(userId);
    return _mergeWithServer(userId, fromHive);
  }

  Future<List<GroupDto>> _groupsFromHive(String userId) async {
    final cached = await HiveService.instance.cachedGroupsForUser(userId);
    if (cached.isEmpty) return const [];
    return cached.map(GroupDto.fromJson).toList();
  }

  /// Reconcile with `GET /groups/{id}` for up-to-date members (and persist to Hive).
  Future<List<GroupDto>> _mergeWithServer(
    String userId,
    List<GroupDto> groups,
  ) async {
    if (groups.isEmpty) return groups;
    final repo = ref.read(groupRepositoryProvider);
    final updated = await Future.wait(
      groups.map((g) async {
        try {
          return await repo.getById(g.id);
        } catch (_) {
          return g;
        }
      }),
    );
    await HiveService.instance.setCachedGroupsForUser(
      userId,
      updated.map((e) => e.toJson()).toList(),
    );
    return updated;
  }

  /// Pull-to-refresh: same as initial load — Hive then server merge.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (!HiveService.instance.isInitialized) {
        await HiveService.instance.init();
      }
      final userId = ref.read(authViewModelProvider).valueOrNull?.id;
      if (userId == null || userId.isEmpty) return const <GroupDto>[];

      final fromHive = await _groupsFromHive(userId);
      return _mergeWithServer(userId, fromHive);
    });
  }

  Future<void> createGroup({
    required String name,
    required String currency,
  }) async {
    final prev = state.valueOrNull ?? const [];
    // Do not set AsyncLoading here: it replaces the body with [SkeletonList]
    // while the bottom sheet is open ("flash then disappear").
    state = await AsyncValue.guard(() async {
      final repo = ref.read(groupRepositoryProvider);
      final created = await repo.create(
        CreateGroupRequest(name: name, currency: currency),
      );

      final next = [created, ...prev];
      final uid = ref.read(authViewModelProvider).valueOrNull?.id;
      if (uid == null || uid.isEmpty) {
        throw StateError('createGroup: not authenticated');
      }
      await HiveService.instance.setCachedGroupsForUser(
        uid,
        next.map((g) => g.toJson()).toList(),
      );
      return next;
    });
  }

  Future<GroupDto> joinGroup({required String code}) async {
    final prev = state.valueOrNull ?? const [];
    late final GroupDto joined;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(groupRepositoryProvider);
      joined = await repo.join(code);

      final exists = prev.any((g) => g.id == joined.id);
      final next = exists ? prev : [joined, ...prev];
      final uid = ref.read(authViewModelProvider).valueOrNull?.id;
      if (uid == null || uid.isEmpty) {
        throw StateError('joinGroup: not authenticated');
      }
      await HiveService.instance.setCachedGroupsForUser(
        uid,
        next.map((g) => g.toJson()).toList(),
      );
      return next;
    });
    if (state is AsyncError) {
      final err = state.error;
      // Do not replace the whole list UI with an error screen after a failed join.
      state = AsyncData(prev);
      if (err != null) throw err;
      throw StateError('joinGroup failed');
    }
    if (state is AsyncData<List<GroupDto>>) return joined;
    throw StateError('joinGroup: unexpected state $state');
  }

  Future<void> upsertCached(GroupDto group) async {
    final prev = state.valueOrNull ?? const [];
    final idx = prev.indexWhere((g) => g.id == group.id);
    final next = [...prev];
    if (idx >= 0) {
      next[idx] = group;
    } else {
      next.insert(0, group);
    }
    state = AsyncValue.data(next);
    final uid = ref.read(authViewModelProvider).valueOrNull?.id;
    if (uid == null || uid.isEmpty) return;
    await HiveService.instance.setCachedGroupsForUser(
      uid,
      next.map((g) => g.toJson()).toList(),
    );
  }

  // Utility for debugging/corrupted cache recovery (kept internal).
  Future<void> clearCache() async {
    state = const AsyncValue.data([]);
    final uid = ref.read(authViewModelProvider).valueOrNull?.id;
    if (uid != null && uid.isNotEmpty) {
      await HiveService.instance.setCachedGroupsForUser(uid, const []);
    } else {
      await HiveService.instance.clearGroupListCache();
    }
  }
}

