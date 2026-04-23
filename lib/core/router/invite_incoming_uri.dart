import '../network/api_config.dart';

/// Extracts an invite code from a shared link or [`dealer://join?code=`] fallback.
String? parseInviteCodeFromIncomingUri(Uri uri) {
  if (uri.scheme == 'dealer' && uri.host.toLowerCase() == 'join') {
    final c = uri.queryParameters['code'] ?? uri.queryParameters['invite'];
    if (c != null && c.trim().isNotEmpty) return c.trim();
    return null;
  }

  Uri expected;
  try {
    expected = Uri.parse(ApiConfig.inviteShareUrl.trim());
  } catch (_) {
    return null;
  }
  if (uri.host.isEmpty || expected.host.isEmpty) return null;
  if (uri.host.toLowerCase() != expected.host.toLowerCase()) return null;

  final qp = uri.queryParameters['code'] ?? uri.queryParameters['invite'];
  if (qp != null && qp.trim().isNotEmpty) return qp.trim();

  final segs = uri.pathSegments.where((e) => e.isNotEmpty).toList();
  final i = segs.indexWhere((e) => e.toLowerCase() == 'join');
  if (i >= 0 && i + 1 < segs.length) return segs[i + 1].trim();
  return null;
}
