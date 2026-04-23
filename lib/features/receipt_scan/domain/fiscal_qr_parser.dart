/// Parses Russian fiscal QR payload (query string or URL with query).
abstract final class FiscalQrParser {
  /// Key/value pairs from QR (e.g. t, s, fn, i, fp, n).
  static Map<String, String> parseParams(String raw) {
    final trimmed = raw.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri != null &&
        uri.hasQuery &&
        uri.queryParameters.isNotEmpty) {
      return Map<String, String>.from(uri.queryParameters);
    }
    var q = trimmed;
    if (q.startsWith('?')) q = q.substring(1);
    return Uri.splitQueryString(q);
  }

  /// Total from field `s` (Итог), if present.
  static num? parseTotal(Map<String, String> params) {
    final s = params['s'];
    if (s == null || s.isEmpty) return null;
    return num.tryParse(s.replaceAll(',', '.'));
  }

  /// Parses `t=` from QR (e.g. `20180518T220500`) into a local [DateTime].
  static DateTime? parseDateTime(String? t) {
    if (t == null || t.isEmpty) return null;
    final s = t.trim();
    final tIdx = s.indexOf('T');
    if (tIdx == 8 && tIdx + 1 < s.length) {
      final datePart = s.substring(0, tIdx);
      final timePart = s.substring(tIdx + 1);
      if (timePart.length < 4) return null;
      final y = int.tryParse(datePart.substring(0, 4));
      final mo = int.tryParse(datePart.substring(4, 6));
      final da = int.tryParse(datePart.substring(6, 8));
      final hh = int.tryParse(timePart.substring(0, 2));
      final mm = int.tryParse(timePart.substring(2, 4));
      if (y == null || mo == null || da == null || hh == null || mm == null) {
        return null;
      }
      var ss = 0;
      if (timePart.length >= 6) {
        ss = int.tryParse(timePart.substring(4, 6)) ?? 0;
      }
      return DateTime(y, mo, da, hh, mm, ss);
    }

    // No `T`: compact `yyyyMMddHHmm` / `yyyyMMddHHmmss` (some OFD QRs).
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 12) return null;
    final y = int.tryParse(digits.substring(0, 4));
    final mo = int.tryParse(digits.substring(4, 6));
    final da = int.tryParse(digits.substring(6, 8));
    final hh = int.tryParse(digits.substring(8, 10));
    final mm = int.tryParse(digits.substring(10, 12));
    if (y == null || mo == null || da == null || hh == null || mm == null) {
      return null;
    }
    var ss = 0;
    if (digits.length >= 14) {
      ss = int.tryParse(digits.substring(12, 14)) ?? 0;
    }
    return DateTime(y, mo, da, hh, mm, ss);
  }

  /// Whole kopecks from ruble total (`s=`) for FNS mobile API query `sum`.
  static int? rublesToKopecks(num? rubles) {
    if (rubles == null) return null;
    return (rubles * 100).round();
  }

  /// Parameters for FNS public receipt check when QR has fn / i / fp / t / s / n.
  static FnsCheckQuery? parseFnsCheckQuery(Map<String, String> params) {
    final fn = params['fn']?.trim();
    final fd = (params['i'] ?? params['fd'])?.trim();
    final fp = params['fp']?.trim();
    if (fn == null || fn.isEmpty || fd == null || fd.isEmpty || fp == null || fp.isEmpty) {
      return null;
    }
    final total = parseTotal(params);
    final kop = rublesToKopecks(total);
    if (kop == null || kop <= 0) return null;
    final dt = parseDateTime(params['t']);
    if (dt == null) return null;
    final op = int.tryParse(params['n']?.trim() ?? '') ?? 1;
    return FnsCheckQuery(
      fiscalNumber: fn,
      fiscalDocument: fd,
      fiscalSign: fp,
      operation: op,
      receiptDateTime: dt,
      sumKopecks: kop,
    );
  }
}

/// FNS `proverkacheka.nalog.ru:9999` check request derived from fiscal QR.
final class FnsCheckQuery {
  const FnsCheckQuery({
    required this.fiscalNumber,
    required this.fiscalDocument,
    required this.fiscalSign,
    required this.operation,
    required this.receiptDateTime,
    required this.sumKopecks,
  });

  final String fiscalNumber;
  final String fiscalDocument;
  final String fiscalSign;
  final int operation;
  final DateTime receiptDateTime;
  final int sumKopecks;

  /// `yyyy-MM-ddTHH:mm:ss` as used by the public FNS mobile API.
  String get formattedDate {
    String p2(int n) => n.toString().padLeft(2, '0');
    return '${receiptDateTime.year}-${p2(receiptDateTime.month)}-${p2(receiptDateTime.day)}'
        'T${p2(receiptDateTime.hour)}:${p2(receiptDateTime.minute)}:${p2(receiptDateTime.second)}';
  }
}
