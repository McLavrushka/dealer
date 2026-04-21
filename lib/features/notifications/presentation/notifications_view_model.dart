import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/notification_dto.dart';
import '../data/notification_providers.dart';

part 'notifications_view_model.g.dart';

@riverpod
class NotificationsViewModel extends _$NotificationsViewModel {
  @override
  Future<List<NotificationDto>> build() async {
    final repo = ref.watch(notificationRepositoryProvider);
    return repo.list();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(notificationRepositoryProvider);
      return repo.list();
    });
  }

  Future<void> markRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markRead(id);
    await refresh();
  }
}
