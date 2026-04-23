import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/hive_service.dart';
import 'api_config.dart';
import 'auth_interceptor.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final hive = HiveService.instance;

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.resolvedBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(dio: dio, hive: hive));
  return dio;
}

