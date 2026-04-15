import 'dart:async';

import 'package:dio/dio.dart';

import '../storage/hive_service.dart';
import 'api_config.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required HiveService hive,
  })  : _dio = dio,
        _hive = hive;

  final Dio _dio;
  final HiveService _hive;

  Completer<void>? _refreshCompleter;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _hive.accessToken;
    if (token != null && _needsAuth(options)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    if (status != 401 || !_needsAuth(requestOptions)) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshTokensIfNeeded();
    if (!refreshed) {
      await _hive.clearTokens();
      handler.next(err);
      return;
    }

    try {
      final retryResponse = await _retry(requestOptions);
      handler.resolve(retryResponse);
    } catch (e) {
      handler.next(
        e is DioException ? e : DioException(requestOptions: requestOptions),
      );
    }
  }

  bool _needsAuth(RequestOptions options) {
    final path = options.path;
    if (path.endsWith(ApiConfig.authLogin)) return false;
    if (path.endsWith(ApiConfig.authRegister)) return false;
    if (path.endsWith(ApiConfig.authRefresh)) return false;
    return true;
  }

  Future<bool> _refreshTokensIfNeeded() async {
    if (_refreshCompleter != null) {
      await _refreshCompleter!.future;
      return _hive.accessToken != null;
    }

    final refreshToken = _hive.refreshToken;
    if (refreshToken == null) return false;

    _refreshCompleter = Completer<void>();
    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post<Map<String, dynamic>>(
        ApiConfig.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;
      final access = data?['accessToken'] as String?;
      final refresh = data?['refreshToken'] as String?;

      if (access == null || refresh == null) return false;

      await _hive.saveTokens(accessToken: access, refreshToken: refresh);
      return true;
    } catch (_) {
      return false;
    } finally {
      _refreshCompleter?.complete();
      _refreshCompleter = null;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) {
    final token = _hive.accessToken;

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      followRedirects: requestOptions.followRedirects,
      validateStatus: requestOptions.validateStatus,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      extra: requestOptions.extra,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }
}

