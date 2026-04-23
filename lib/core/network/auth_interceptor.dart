import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
    final needs = _needsAuth(options);
    if (kDebugMode && needs && token == null) {
      debugPrint(
        'AuthInterceptor: missing access token for ${options.uri} '
        '(expected Bearer after login — check Hive / web storage).',
      );
    }
    if (token != null && needs) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    // Some setups return 403 when JWT is missing/invalid (anonymous user).
    final canRefresh = status == 401 || status == 403;
    if (!canRefresh || !_needsAuth(requestOptions)) {
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
    if (!_isRequestToAppBackend(options)) return false;
    final path = _requestPath(options);
    if (path.endsWith(ApiConfig.authLogin)) return false;
    if (path.endsWith(ApiConfig.authRegister)) return false;
    if (path.endsWith(ApiConfig.authRefresh)) return false;
    return true;
  }

  /// Only attach JWT to our REST API ([ApiConfig.resolvedBaseUrl]), not third-party hosts
  /// (e.g. FNS receipt check) — foreign 403s must not trigger token refresh.
  bool _isRequestToAppBackend(RequestOptions options) {
    try {
      final base = Uri.parse(ApiConfig.resolvedBaseUrl);
      final req = options.uri;
      if (req.host.isEmpty) return false;
      // Compare host+scheme, not full authority: :443 vs default and typos in
      // API_BASE_URL must not skip attaching Bearer (unauthenticated calls often
      // look like “404” on join / group detail).
      return req.scheme == base.scheme &&
          req.host.toLowerCase() == base.host.toLowerCase();
    } catch (_) {
      return false;
    }
  }

  /// Dio may leave [RequestOptions.path] empty on some platforms; [uri.path] is reliable.
  String _requestPath(RequestOptions options) {
    final p = options.path;
    if (p.isNotEmpty) return p;
    return options.uri.path;
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
          baseUrl: ApiConfig.resolvedBaseUrl,
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

