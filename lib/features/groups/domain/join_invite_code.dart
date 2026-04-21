/// Normalizes invite input from the Join field (plain code, pasted share text, or URL).
abstract final class JoinInviteCode {
  static String normalize(String raw) {
    var s = raw.trim();
    if (s.isEmpty) return s;

    for (final line in s.split(RegExp(r'\r?\n'))) {
      final lineTrim = line.trim();
      final m = RegExp(r'^code:\s*(.+)$', caseSensitive: false).firstMatch(lineTrim);
      if (m != null) {
        return _normalizeToken(m.group(1)!);
      }
    }

    final single = RegExp(r'^code:\s*(.+)$', caseSensitive: false).firstMatch(s);
    if (single != null) {
      return _normalizeToken(single.group(1)!);
    }

    if (s.contains('://')) {
      try {
        final u = Uri.parse(s);
        final qp = u.queryParameters['code'];
        if (qp != null && qp.trim().isNotEmpty) {
          return _normalizeToken(qp);
        }
        final segments = u.pathSegments.where((e) => e.isNotEmpty).toList();
        final i = segments.indexWhere((e) => e.toLowerCase() == 'join');
        if (i >= 0 && i + 1 < segments.length) {
          return _normalizeToken(segments[i + 1]);
        }
        if (segments.isNotEmpty) {
          return _normalizeToken(segments.last);
        }
      } catch (_) {}
    }

    return _normalizeToken(s);
  }

  static String _normalizeToken(String code) => code.trim().toUpperCase();
}
