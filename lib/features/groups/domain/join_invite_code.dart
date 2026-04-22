/// Parses invite input (plain code, pasted share text, or URL).
///
/// **API paths must use [extract] / [forJoinPathSegment]** — the server invite
/// code is case-sensitive in practice (`ZIWlo9lu` ≠ `ZIWLO9LU`). [normalize] is
/// only for display / UX (uppercase).
abstract final class JoinInviteCode {
  /// Uppercase, trimmed — good for showing in a text field; **do not** send this
  /// to [POST /groups/join/…] if the backend is case-sensitive.
  static String normalize(String raw) => extract(raw).toUpperCase();

  /// Trims, parses `code:` lines and URLs, **preserves casing** of the invite token.
  static String extract(String raw) {
    var s = raw.trim();
    if (s.isEmpty) return s;

    for (final line in s.split(RegExp(r'\r?\n'))) {
      final lineTrim = line.trim();
      final m = RegExp(r'^code:\s*(.+)$', caseSensitive: false).firstMatch(lineTrim);
      if (m != null) {
        return _trimToken(m.group(1)!);
      }
    }

    final single = RegExp(r'^code:\s*(.+)$', caseSensitive: false).firstMatch(s);
    if (single != null) {
      return _trimToken(single.group(1)!);
    }

    if (s.contains('://')) {
      try {
        final u = Uri.parse(s);
        final qp = u.queryParameters['code'] ?? u.queryParameters['invite'];
        if (qp != null && qp.trim().isNotEmpty) {
          return _trimToken(qp);
        }
        final segments = u.pathSegments.where((e) => e.isNotEmpty).toList();
        final i = segments.indexWhere((e) => e.toLowerCase() == 'join');
        if (i >= 0 && i + 1 < segments.length) {
          return _trimToken(segments[i + 1]);
        }
        if (segments.isNotEmpty) {
          return _trimToken(segments.last);
        }
      } catch (_) {}
    }

    return _trimToken(s);
  }

  static String _trimToken(String code) => code.trim();

  /// Single path segment for [POST /groups/join/…]: same as [extract], then
  /// strip whitespace / zero-width / characters that break one path segment.
  static String forJoinPathSegment(String raw) {
    return extract(raw)
        .replaceAll(RegExp(r'[\s\u200B-\u200D\uFEFF]+'), '')
        .replaceAll(RegExp(r'[/\\?#&]+'), '');
  }
}
