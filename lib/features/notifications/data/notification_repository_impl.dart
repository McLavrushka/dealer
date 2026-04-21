import 'package:dio/dio.dart';

import '../../../core/network/api_config.dart';
import 'models/notification_dto.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<NotificationDto>> list() async {
    final response = await _dio.get<List<dynamic>>(ApiConfig.notifications);
    final raw = response.data ?? const <dynamic>[];
    return raw
        .map((e) => NotificationDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> markRead(String id) async {
    await _dio.patch<void>('${ApiConfig.notifications}/$id/read');
  }
}
