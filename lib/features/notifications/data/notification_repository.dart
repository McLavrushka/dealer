import 'models/notification_dto.dart';

abstract interface class NotificationRepository {
  Future<List<NotificationDto>> list();
  Future<void> markRead(String id);
}
