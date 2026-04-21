import 'receipt_line.dart';

/// Heuristic parsing of OCR text into line items (mixed **Latin / Cyrillic**).
///
/// When OCR runs with ML Kit’s **Latin** model, English / European slips parse best;
/// Cyrillic-only lines are often garbled. Prefer **QR** for Russian fiscal receipts.
class ParseOcrUseCase {
  const ParseOcrUseCase();

  /// Decimal amount: digits, optional inner spaces, comma or dot, 1–2 fraction digits.
  static final _amount = r'(\d{1,7}(?:[\s\u00A0]*[.,]\s*\d{1,2}))';

  /// Line ends with a single amount: `Name ... 123,45`
  static final _nameThenAmount = RegExp(
    r'^(.+?)\s+' + _amount + r'\s*$',
  );

  /// `Name ... qty x unitPrice lineTotal` (line total preferred)
  static final _qtyXUnitTotal = RegExp(
    r'^(.+?)\s+(\d{1,3})\s*[xх×]\s*' + _amount + r'\s+' + _amount + r'\s*$',
    caseSensitive: false,
  );

  /// `Name ... qty x unitPrice` (no separate total column)
  static final _qtyXUnit = RegExp(
    r'^(.+?)\s+(\d{1,3})\s*[xх×]\s*' + _amount + r'\s*$',
    caseSensitive: false,
  );

  /// `Name ... qty @ unitPrice` (common on English receipts)
  static final _qtyAtUnit = RegExp(
    r'^(.+?)\s+(\d{1,3})\s*@\s*' + _amount + r'\s*$',
    caseSensitive: false,
  );

  /// Wide column gap before amount (common in printed receipts)
  static final _twoColumnAmount = RegExp(
    r'^(.+?)\s{2,}' + _amount + r'\s*$',
  );

  static final _junkLine = RegExp(
    r'^(итог|всего|сумма|к\s*оплат|оплат|сдача|ндс|налог|сбис|фн\b|фд\b|фп\b|рн\b|ккт|касс'
    r'|чек\b|смена|позиц|наименован|стоимост|кол-во|ед\.|изм\.|шт\.'
    r'|visa|master|mir|мир\b|карт'
    r'|total\b|subtotal|balance\s*due|amount\s*due|change|tax\b|vat\b|hst\b|gst\b'
    r'|gratuity|service\s*charge|tip\b|payment|debit|credit|discount'
    r'|thank\s*you|receipt|invoice|cashier|register)',
    caseSensitive: false,
  );

  List<ReceiptLine> run(String rawText) {
    final normalized = _normalizeFullWidthDigits(rawText)
        .replaceAll('\r', '\n')
        .replaceAll('\t', ' ');
    final rawLines = normalized
        .split('\n')
        .map(_collapseSpaces)
        .where((l) => l.isNotEmpty)
        .toList();

    final merged = _mergeWrappedLines(rawLines);
    final out = <ReceiptLine>[];

    for (final line in merged) {
      if (_shouldSkipLine(line)) continue;
      final parsed = _parseLine(line);
      if (parsed != null) out.add(parsed);
    }
    return out;
  }

  static String _collapseSpaces(String s) =>
      s.replaceAll(RegExp(r'\s+'), ' ').trim();

  static bool _shouldSkipLine(String line) {
    if (line.length < 4) return true;
    final lower = line.toLowerCase().replaceAll('ё', 'е');
    if (_junkLine.hasMatch(lower)) return true;
    // Single token or almost only digits — not a product line
    if (!RegExp(r'[A-Za-zА-Яа-яЁё]').hasMatch(line)) return true;
    return false;
  }

  /// If a product name wraps to the next line, OCR often gives:
  /// `Длинное наименование` then `123,45`. Join when the second line is only an amount.
  static List<String> _mergeWrappedLines(List<String> lines) {
    final out = <String>[];
    final onlyAmount = RegExp(r'^' + _amount + r'\s*$');

    var i = 0;
    while (i < lines.length) {
      final line = lines[i];
      final hasTrailingPrice = _nameThenAmount.hasMatch(line) ||
          _qtyXUnitTotal.hasMatch(line) ||
          _qtyAtUnit.hasMatch(line) ||
          _qtyXUnit.hasMatch(line) ||
          _twoColumnAmount.hasMatch(line);

      final next = i + 1 < lines.length ? lines[i + 1] : null;
      if (!hasTrailingPrice &&
          next != null &&
          onlyAmount.hasMatch(next) &&
          !_shouldSkipLine(line) &&
          line.length <= 80 &&
          !RegExp(r'\d{1,7}[\s\u00A0]*[.,]\s*\d{1,2}\s*$').hasMatch(line)) {
        out.add('$line ${onlyAmount.firstMatch(next)!.group(1)!}');
        i += 2;
        continue;
      }

      out.add(line);
      i++;
    }
    return out;
  }

  static ReceiptLine? _parseLine(String line) {
    final qtyTotal = _qtyXUnitTotal.firstMatch(line);
    if (qtyTotal != null) {
      final name = qtyTotal.group(1)!.trim();
      final qty = num.tryParse(qtyTotal.group(2)!) ?? 1;
      if (qty <= 0) return null;
      final unit = _parseAmount(qtyTotal.group(3)!);
      final lineTotal = _parseAmount(qtyTotal.group(4)!);
      if (unit != null && unit > 0) {
        if (lineTotal != null && lineTotal > 0) {
          final implied = unit * qty;
          if ((implied - lineTotal).abs() <= 0.05 * lineTotal + 0.5) {
            return ReceiptLine(name: _clipName(name), price: unit, quantity: qty);
          }
          return ReceiptLine(
            name: _clipName(name),
            price: lineTotal / qty,
            quantity: qty,
          );
        }
        return ReceiptLine(name: _clipName(name), price: unit, quantity: qty);
      }
      if (lineTotal != null && lineTotal > 0) {
        return ReceiptLine(
          name: _clipName(name),
          price: lineTotal / qty,
          quantity: qty,
        );
      }
      return null;
    }

    final qtyAt = _qtyAtUnit.firstMatch(line);
    if (qtyAt != null) {
      final name = qtyAt.group(1)!.trim();
      final qty = num.tryParse(qtyAt.group(2)!) ?? 1;
      final unit = _parseAmount(qtyAt.group(3)!);
      if (unit == null || unit <= 0 || qty <= 0) return null;
      return ReceiptLine(name: _clipName(name), price: unit, quantity: qty);
    }

    final qtyUnit = _qtyXUnit.firstMatch(line);
    if (qtyUnit != null) {
      final name = qtyUnit.group(1)!.trim();
      final qty = num.tryParse(qtyUnit.group(2)!) ?? 1;
      final unit = _parseAmount(qtyUnit.group(3)!);
      if (unit == null || unit <= 0 || qty <= 0) return null;
      return ReceiptLine(
        name: _clipName(name),
        price: unit,
        quantity: qty,
      );
    }

    final twoCol = _twoColumnAmount.firstMatch(line);
    if (twoCol != null) {
      final name = twoCol.group(1)!.trim();
      final price = _parseAmount(twoCol.group(2)!);
      if (price == null || price <= 0) return null;
      return ReceiptLine(name: _clipName(name), price: price, quantity: 1);
    }

    final m = _nameThenAmount.firstMatch(line);
    if (m != null) {
      final name = m.group(1)!.trim();
      final price = _parseAmount(m.group(2)!);
      if (price == null || price <= 0) return null;
      return ReceiptLine(name: _clipName(name), price: price, quantity: 1);
    }
    return null;
  }

  static num? _parseAmount(String raw) {
    var t = raw.trim();
    t = t.replaceFirst(RegExp(r'^[\$€£]\s*'), '');
    t = t.replaceAll(RegExp(r'\s|\u00A0'), '').replaceAll(',', '.');
    return num.tryParse(t);
  }

  static String _clipName(String name) {
    if (name.length <= 120) return name;
    return '${name.substring(0, 117)}...';
  }

  /// Fullwidth digits (common in some PDFs / mixed encodings) → ASCII.
  static String _normalizeFullWidthDigits(String s) {
    var out = s;
    for (var i = 0; i < 10; i++) {
      out = out.replaceAll(String.fromCharCode(0xFF10 + i), '$i');
    }
    return out;
  }
}
