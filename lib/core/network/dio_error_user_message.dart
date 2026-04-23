import 'package:dio/dio.dart';

/// Pulls FastAPI-style `detail` and always includes the request URI so a wrong
/// [ApiConfig.baseUrl] or path is obvious when debugging 404/502 etc.
String userMessageForApiError(Object error) {
  if (error is! DioException) return error.toString();

  final uri = error.requestOptions.uri;
  final status = error.response?.statusCode;
  final detail = _extractDetail(error.response?.data);

  final lines = <String>[];
  if (detail != null && detail.isNotEmpty) {
    lines.add(detail);
  }
  if (status != null) {
    lines.add('HTTP $status');
  }
  lines.add(uri.toString());
  return lines.join('\n');
}

String? _extractDetail(dynamic data) {
  if (data == null) return null;
  if (data is Map) {
    final d = data['detail'];
    if (d is String) return d;
    if (d is List) {
      return d.map((e) => e.toString()).join('; ');
    }
  }
  if (data is String) return data;
  return null;
}
