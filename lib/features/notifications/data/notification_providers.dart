import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import 'notification_repository.dart';
import 'notification_repository_impl.dart';

part 'notification_providers.g.dart';

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepositoryImpl(ref.watch(dioProvider));
}
