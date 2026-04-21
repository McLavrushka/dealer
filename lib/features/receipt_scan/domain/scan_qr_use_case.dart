import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/api_config.dart';
import 'fiscal_qr_parser.dart';
import 'receipt_line.dart';

/// Debug: lines prefixed `[ScanQR]` go to the **same terminal as `flutter run`**
/// (`debugPrint`). In **debug** without flags: logs only inside `assert` (typical `flutter run`).
/// Force logs in any mode: `flutter run --dart-define=SCAN_QR_DEBUG=true`
const bool _kScanQrVerbose = bool.fromEnvironment('SCAN_QR_DEBUG', defaultValue: false);

void _scanQrLog(String message) {
  if (_kScanQrVerbose) {
    debugPrint('[ScanQR] $message');
    return;
  }
  assert(() {
    debugPrint('[ScanQR] $message');
    return true;
  }());
}

void _scanQrLogError(String context, Object e, StackTrace st) {
  if (_kScanQrVerbose) {
    debugPrint('[ScanQR] $context: $e');
    debugPrint('[ScanQR] $st');
    return;
  }
  assert(() {
    debugPrint('[ScanQR] $context: $e');
    debugPrint('[ScanQR] $st');
    return true;
  }());
}

/// Parses fiscal QR and loads receipt positions when possible.
///
/// 1. **Official** proverkacheka `POST /api/v1/check/get` with [ApiConfig.proverkachekaToken]
///    and `qrraw` (per vendor spec) → `data.json.items`.
/// 2. Legacy GET `receipt-by-qr` (no token).
/// 3. FNS public mobile API ([_fnsBase]) — kopecks.
/// 4. Fallback: one line from `s=` in the QR.
class ScanQrUseCase {
  ScanQrUseCase(this._dio);

  final Dio _dio;

  static const _proverkaHost = 'https://proverkacheka.com';
  static const _fnsBase = 'https://proverkacheka.nalog.ru:9999/v1';

  /// FNS / proverkacheka are external; default Dio [connectTimeout] (10s) is often too low.
  static const _externalConnectTimeout = Duration(seconds: 30);
  static const _externalReceiveTimeout = Duration(seconds: 45);

  Future<List<ReceiptLine>> run(String rawQr) async {
    final trimmed = rawQr.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Empty QR payload');
    }

    final params = FiscalQrParser.parseParams(trimmed);
    final totalRub = FiscalQrParser.parseTotal(params);

    _scanQrLog(
      'start len=${trimmed.length} keys=[${params.keys.join(',')}] '
      'parseTotal(s)=${totalRub ?? "null"}',
    );

    final officialLines = await _tryProverkachekaOfficialPost(trimmed);
    _scanQrLog('after proverkacheka check/get: ${officialLines?.length ?? 0} line(s)');
    if (officialLines != null && officialLines.length >= 2) {
      return officialLines;
    }

    // Legacy GET (often 404 without vendor contract).
    final remoteLines = await _tryParseRemoteJson(trimmed, targetTotalRub: totalRub);
    _scanQrLog('after remote GET receipt-by-qr: ${remoteLines?.length ?? 0} line(s)');
    if (remoteLines != null && remoteLines.length >= 2) {
      return remoteLines;
    }

    final fnsLines = await _tryFetchFnsReceiptLines(params, targetTotalRub: totalRub);
    _scanQrLog('after FNS: ${fnsLines?.length ?? 0} line(s)');
    if (fnsLines != null && fnsLines.isNotEmpty) {
      return fnsLines;
    }

    if (officialLines != null && officialLines.isNotEmpty) {
      _scanQrLog('using proverkacheka official (${officialLines.length} line(s))');
      return officialLines;
    }

    if (remoteLines != null && remoteLines.isNotEmpty) {
      _scanQrLog('using remote single-line or short list (${remoteLines.length})');
      return remoteLines;
    }

    final total = totalRub;
    if (total == null || total <= 0) {
      throw StateError(
        'Could not parse receipt total from QR. Paste the full fiscal string.',
      );
    }

    _scanQrLog(
      'fallback → one line "Receipt (QR total)" price=$total '
      '(FNS/remote did not yield multiple lines; see logs above)',
    );
    return [
      ReceiptLine(
        name: 'Receipt (QR total)',
        price: total,
        quantity: 1,
      ),
    ];
  }

  /// FNS flow: existence check then ticket details (items in kopecks).
  Future<List<ReceiptLine>?> _tryFetchFnsReceiptLines(
    Map<String, String> params, {
    num? targetTotalRub,
  }) async {
    final query = FiscalQrParser.parseFnsCheckQuery(params);
    if (query == null) {
      _scanQrLog(
        'FNS skipped: parseFnsCheckQuery=null '
        '(need fn, i/fd, fp, t, s>0). t=${params['t']} s=${params['s']} '
        'fnLen=${params['fn']?.length ?? 0} fpLen=${params['fp']?.length ?? 0}',
      );
      return null;
    }
    _scanQrLog(
      'FNS query ok: fn=${query.fiscalNumber} fd=${query.fiscalDocument} '
      'n=${query.operation} sumKop=${query.sumKopecks} date=${query.formattedDate}',
    );

    final headers = <String, String>{
      'device-id': _randomDeviceId(),
      'device-os': 'Flutter',
    };

    final existPath =
        '/ofds/*/inns/*/fss/${query.fiscalNumber}/operations/${query.operation}/tickets/${query.fiscalDocument}';
    final existUri = Uri.parse('$_fnsBase$existPath').replace(
      queryParameters: <String, String>{
        'fiscalSign': query.fiscalSign,
        'date': query.formattedDate,
        'sum': '${query.sumKopecks}',
      },
    );

    try {
      final existResp = await _dio.get<dynamic>(
        existUri.toString(),
        options: Options(
          validateStatus: (s) => s != null && s < 600,
          connectTimeout: _externalConnectTimeout,
          receiveTimeout: _externalReceiveTimeout,
          headers: headers,
        ),
      );
      final existCode = existResp.statusCode;
      _scanQrLog('FNS exist HTTP $existCode');
      if (existCode == 451 || existCode == 406 || existCode == 403) {
        _scanQrLog('FNS exist blocked ($existCode) — often geo / anti-bot');
        return null;
      }
      // API historically used 204; some proxies return 200 with an empty body.
      if (existCode != 204 && existCode != 200) {
        _scanQrLog('FNS exist unexpected status $existCode — abort FNS chain');
        return null;
      }

      final detailPath =
          '/inns/*/kkts/*/fss/${query.fiscalNumber}/tickets/${query.fiscalDocument}';
      final detailUri = Uri.parse('$_fnsBase$detailPath').replace(
        queryParameters: <String, String>{
          'fiscalSign': query.fiscalSign,
          'sendToEmail': 'no',
        },
      );

      Response<dynamic> detailResp = await _dio.get<dynamic>(
        detailUri.toString(),
        options: Options(
          validateStatus: (s) => s != null && s < 600,
          connectTimeout: _externalConnectTimeout,
          receiveTimeout: _externalReceiveTimeout,
          headers: headers,
        ),
      );

      for (var i = 0; i < 3 && detailResp.statusCode == 202; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 700));
        detailResp = await _dio.get<dynamic>(
          detailUri.toString(),
          options: Options(
            validateStatus: (s) => s != null && s < 600,
            connectTimeout: _externalConnectTimeout,
            receiveTimeout: _externalReceiveTimeout,
            headers: headers,
          ),
        );
      }

      final code = detailResp.statusCode;
      _scanQrLog('FNS detail HTTP $code bodyType=${detailResp.data.runtimeType}');
      if (code == 451 || code == 406 || code == 403 || code != 200) {
        if (code == 202) {
          _scanQrLog('FNS detail still 202 after retries — ticket not ready');
        }
        return null;
      }
      final data = detailResp.data;
      final lines = _linesFromFnsTicketJson(data, targetTotalRub: targetTotalRub);
      _scanQrLog('FNS ticket parsed → ${lines?.length ?? 0} line(s)');
      return lines;
    } catch (e, st) {
      _scanQrLogError('FNS request failed', e, st);
      return null;
    }
  }

  String _randomDeviceId() {
    const chars = '0123456789abcdef';
    final r = Random();
    return List.generate(32, (_) => chars[r.nextInt(chars.length)]).join();
  }

  Map<String, dynamic>? _decodeJsonMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final t = data.trim();
      if (t.isEmpty) return null;
      try {
        final o = jsonDecode(t);
        if (o is Map) return Map<String, dynamic>.from(o);
      } catch (_) {}
    }
    return null;
  }

  /// Maps FNS / OFD ticket JSON (amounts usually in kopecks) to [ReceiptLine].
  List<ReceiptLine>? _linesFromFnsTicketJson(
    dynamic data, {
    num? targetTotalRub,
  }) {
    final root = _decodeJsonMap(data);
    if (root == null) {
      _scanQrLog(
        'ticket JSON: could not decode to Map (type=${data.runtimeType}, '
        'stringLen=${data is String ? data.length : 0})',
      );
      return null;
    }

    final receipt = _receiptMapFromTicketRoot(root);
    if (receipt != null) {
      final items = _discoverReceiptItemMaps(receipt);
      if (items != null && items.isNotEmpty) {
        final out = <ReceiptLine>[];
        for (var i = 0; i < items.length; i++) {
          final line = _receiptLineFromFnsItem(items[i], i);
          if (line != null) out.add(line);
        }
        if (out.length >= 2) {
          if (targetTotalRub == null || _linesRoughlyMatchTotal(out, targetTotalRub)) {
            return out;
          }
        } else if (out.isNotEmpty &&
            _linesRoughlyMatchTotal(out, targetTotalRub)) {
          return out;
        }
      }
    }

    final scanned = _scanTreeForBestLines(root, targetTotalRub: targetTotalRub);
    if (scanned != null && scanned.isNotEmpty) {
      _scanQrLog('ticket tree-scan → ${scanned.length} line(s)');
      return scanned;
    }

    _scanQrLog(
      'ticket parse: no lines (receiptMap=${receipt != null} '
      'topKeys=[${root.keys.take(12).join(",")}])',
    );
    return null;
  }

  /// DFS: find the longest list of product-like maps; pick kopecks vs rubles by [targetTotalRub].
  List<ReceiptLine>? _scanTreeForBestLines(
    Map<String, dynamic> root, {
    num? targetTotalRub,
  }) {
    List<ReceiptLine>? best;
    var bestScore = -1.0;

    double scoreFor(List<ReceiptLine> lines) {
      if (lines.length < 2) return -1;
      var s = lines.length.toDouble();
      if (targetTotalRub != null && targetTotalRub > 0) {
        final sum = lines.fold<double>(
          0,
          (a, l) => a + l.price * l.quantity * 1.0,
        );
        final err = (sum - targetTotalRub).abs() / targetTotalRub;
        s += 80 / (1 + err * 40);
      } else {
        s += 1;
      }
      return s;
    }

    void consider(List<Map<String, dynamic>> maps) {
      if (maps.length < 2) return;
      final priced = maps
          .where(
            (m) =>
                _parseNum(m['sum'] ?? m['price'] ?? m['total'] ?? m['productSum']) !=
                null,
          )
          .toList();
      if (priced.length < 2) return;

      final kLines = <ReceiptLine>[];
      final rLines = <ReceiptLine>[];
      for (var i = 0; i < priced.length; i++) {
        final k = _receiptLineFromFnsItem(priced[i], i);
        if (k != null) kLines.add(k);
        final r = _receiptLineFromRublesItem(priced[i], i);
        if (r != null) rLines.add(r);
      }
      for (final candidate in [kLines, rLines]) {
        if (candidate.length < 2) continue;
        final sc = scoreFor(candidate);
        if (sc > bestScore) {
          bestScore = sc;
          best = List<ReceiptLine>.from(candidate);
        }
      }
    }

    final stack = <Object?>[root];
    var steps = 0;
    while (stack.isNotEmpty && steps < 8000) {
      steps++;
      final cur = stack.removeLast();
      if (cur is List) {
        if (cur.length >= 2 && cur.every((e) => e is Map)) {
          consider(
            cur.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
          );
        }
        for (final e in cur) {
          stack.add(e);
        }
      } else if (cur is Map) {
        for (final v in cur.values) {
          stack.add(v);
        }
      }
    }
    return best;
  }

  ReceiptLine? _receiptLineFromRublesItem(Map<String, dynamic> m, int index) {
    final name = _fnsPositionName(m, index);
    var qty = _parseNum(m['quantity'] ?? m['qty'] ?? m['count'] ?? m['pieces']) ?? 1;
    if (qty <= 0) qty = 1;

    final sum = _parseNum(m['sum']) ??
        _parseNum(m['total']) ??
        _parseNum(m['productSum']) ??
        _parseNum(m['amount']);
    final price = _parseNum(m['price']) ?? _parseNum(m['cost']);

    num? unitRub;
    if (price != null && price > 0) {
      unitRub = price;
    } else if (sum != null && sum > 0) {
      unitRub = sum / qty;
    }
    if (unitRub == null || unitRub <= 0) return null;

    return ReceiptLine(name: name, price: unitRub, quantity: qty);
  }

  Map<String, dynamic>? _receiptMapFromTicketRoot(Map<String, dynamic> root) {
    final doc = root['document'];
    if (doc is Map) {
      final r = Map<String, dynamic>.from(doc)['receipt'];
      if (r is Map) return Map<String, dynamic>.from(r);
    }
    final jsonInner = root['json'];
    if (jsonInner is Map) {
      return _receiptMapFromTicketRoot(Map<String, dynamic>.from(jsonInner));
    }
    final content = root['content'];
    if (content is Map) {
      final r = Map<String, dynamic>.from(content)['receipt'];
      if (r is Map) return Map<String, dynamic>.from(r);
    }
    final r = root['receipt'];
    if (r is Map) return Map<String, dynamic>.from(r);
    return null;
  }

  /// FNS / OFD payloads expose positions under different keys and shapes.
  List<Map<String, dynamic>>? _discoverReceiptItemMaps(Map<String, dynamic> receipt) {
    const known = {'items', 'commodities', 'positions', 'goods'};
    for (final entry in receipt.entries) {
      final k = entry.key.toString().toLowerCase();
      if (!known.contains(k)) continue;
      final list = _coerceItemMapList(entry.value);
      if (list != null && list.isNotEmpty) return list;
    }
    for (final entry in receipt.entries) {
      if (known.contains(entry.key.toString().toLowerCase())) continue;
      final list = _coerceItemMapList(entry.value);
      if (list == null || list.isEmpty) continue;
      if (list.any(_looksLikeFnsPosition)) {
        return list;
      }
    }
    return null;
  }

  List<Map<String, dynamic>>? _coerceItemMapList(dynamic raw) {
    if (raw is List) {
      final out = <Map<String, dynamic>>[];
      for (final e in raw) {
        if (e is Map) out.add(Map<String, dynamic>.from(e));
      }
      return out.isEmpty ? null : out;
    }
    if (raw is Map) {
      final out = <Map<String, dynamic>>[];
      for (final v in raw.values) {
        if (v is Map) out.add(Map<String, dynamic>.from(v));
      }
      return out.isEmpty ? null : out;
    }
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        return _coerceItemMapList(jsonDecode(raw));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  bool _looksLikeFnsPosition(Map<String, dynamic> m) {
    final keys = m.keys.map((k) => k.toString().toLowerCase()).toSet();
    final hasAmount = keys.any(
      (k) =>
          k == 'sum' ||
          k == 'price' ||
          k == 'productsum' ||
          k == 'amount' ||
          k == 'totalsum' ||
          k == 'cost',
    );
    final hasName = keys.any(
      (k) =>
          k == 'name' ||
          k == 'nm' ||
          k == 'productname' ||
          k == 'itemname' ||
          k == 'subject' ||
          k.contains('name'),
    );
    final hasQty = keys.any(
      (k) => k == 'quantity' || k == 'qty' || k == 'count' || k == 'pieces',
    );
    return hasAmount && (hasName || hasQty);
  }

  ReceiptLine? _receiptLineFromFnsItem(Map<String, dynamic> m, int index) {
    final name = _fnsPositionName(m, index);

    final qtyRaw = m['quantity'] ?? m['qty'] ?? m['count'] ?? m['pieces'] ?? 1;
    var qty = _parseNum(qtyRaw) ?? 1;
    if (qty <= 0) qty = 1;

    num? priceK = _parseNum(m['price']) ??
        _parseNum(m['productPrice']) ??
        _parseNum(m['cost']);
    final sumK = _parseNum(m['sum']) ??
        _parseNum(m['productSum']) ??
        _parseNum(m['total']) ??
        _parseNum(m['amount']);

    if ((priceK == null || priceK <= 0) && sumK != null && sumK > 0) {
      priceK = sumK / qty;
    }
    if (priceK == null || priceK <= 0) return null;

    final unitRub = priceK / 100;
    return ReceiptLine(name: name, price: unitRub, quantity: qty);
  }

  String _fnsPositionName(Map<String, dynamic> m, int index) {
    for (final key in const [
      'name',
      'productName',
      'nm',
      'itemName',
      'text',
      'subject',
      'product',
    ]) {
      final v = m[key];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return 'Position ${index + 1}';
  }

  num? _parseNum(dynamic v) {
    if (v == null) return null;
    return num.tryParse(v.toString().replaceAll(',', '.'));
  }

  bool _linesRoughlyMatchTotal(List<ReceiptLine> lines, num? targetRub) {
    if (targetRub == null || targetRub <= 0 || lines.isEmpty) return true;
    final sum = lines.fold<double>(
      0,
      (a, l) => a + l.price * l.quantity * 1.0,
    );
    final err = (sum - targetRub).abs();
    return err <= 0.02 * targetRub + 1.0;
  }

  /// Official API: `POST /api/v1/check/get` with `qrraw` + `token` (vendor doc).
  Future<List<ReceiptLine>?> _tryProverkachekaOfficialPost(String rawQr) async {
    final token = ApiConfig.proverkachekaToken.trim();
    if (token.isEmpty) {
      _scanQrLog(
        'proverkacheka official: skip (PROVERKACHEKA_TOKEN empty). '
        'Pass --dart-define=PROVERKACHEKA_TOKEN=...',
      );
      return null;
    }

    try {
      Future<Response<dynamic>> postOnce() {
        return _dio.post<dynamic>(
          '$_proverkaHost/api/v1/check/get',
          data: <String, dynamic>{
            'token': token,
            'qrraw': rawQr,
            'qr': '1',
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            connectTimeout: _externalConnectTimeout,
            receiveTimeout: _externalReceiveTimeout,
            validateStatus: (s) => s != null && s < 500,
          ),
        );
      }

      var response = await postOnce();
      _scanQrLog(
        'proverkacheka POST check/get HTTP ${response.statusCode} '
        'bodyType=${response.data.runtimeType}',
      );
      if (response.statusCode != 200 || response.data == null) {
        return null;
      }

      var root = _decodeJsonMap(response.data);
      if (root == null) {
        _scanQrLog('proverkacheka: body is not JSON object');
        return null;
      }

      var apiCode = _proverkachekaResponseCode(root);
      _scanQrLog('proverkacheka response code=$apiCode');

      if (apiCode == 2) {
        _scanQrLog('proverkacheka code=2 (pending) — retry in 2s');
        await Future<void>.delayed(const Duration(seconds: 2));
        response = await postOnce();
        if (response.statusCode != 200 || response.data == null) {
          return null;
        }
        root = _decodeJsonMap(response.data);
        if (root == null) return null;
        apiCode = _proverkachekaResponseCode(root);
        _scanQrLog('proverkacheka retry response code=$apiCode');
      }

      if (apiCode != 1) {
        return null;
      }

      return _linesFromProverkachekaDataJson(root);
    } catch (e, st) {
      _scanQrLogError('proverkacheka check/get failed', e, st);
      return null;
    }
  }

  int _proverkachekaResponseCode(Map<String, dynamic> root) {
    final c = root['code'];
    if (c is int) return c;
    return int.tryParse(c?.toString() ?? '') ?? -1;
  }

  /// [root] is full JSON; items live under `data.json.items` (per vendor spec).
  List<ReceiptLine>? _linesFromProverkachekaDataJson(Map<String, dynamic> root) {
    final data = root['data'];
    if (data is! Map) {
      _scanQrLog('proverkacheka: missing data map');
      return null;
    }
    final d = Map<String, dynamic>.from(data);
    final receipt = _parseProverkachekaReceiptJson(d);
    if (receipt == null) {
      _scanQrLog('proverkacheka: missing data.json (keys: ${d.keys.join(",")})');
      return null;
    }

    final items = _coerceItemMapList(receipt['items']) ??
        _coerceItemMapList(receipt['commodities']) ??
        _coerceItemMapList(receipt['positions']) ??
        _firstListOfProductMapsInMap(receipt);
    if (items == null || items.isEmpty) {
      _scanQrLog(
        'proverkacheka: no item list (receipt keys: ${receipt.keys.join(",")})',
      );
      return null;
    }

    final out = <ReceiptLine>[];
    for (var i = 0; i < items.length; i++) {
      final line = _receiptLineFromProverkachekaItem(items[i], i);
      if (line != null) out.add(line);
    }
    _scanQrLog(
      'proverkacheka: rawItems=${items.length} parsedLines=${out.length}',
    );
    return out.isEmpty ? null : out;
  }

  Map<String, dynamic>? _parseProverkachekaReceiptJson(Map<String, dynamic> data) {
    for (final key in const ['json', 'JSON', 'Json', 'receipt', 'document']) {
      final jsonBlock = data[key];
      if (jsonBlock is Map) {
        return Map<String, dynamic>.from(jsonBlock);
      }
      if (jsonBlock is String) {
        try {
          final decoded = jsonDecode(jsonBlock.trim());
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
        } catch (_) {
          continue;
        }
      }
    }
    return null;
  }

  /// First [List] of [Map]s in [map] that look like receipt lines (sum/price + name/qty).
  List<Map<String, dynamic>>? _firstListOfProductMapsInMap(Map<String, dynamic> map) {
    for (final v in map.values) {
      final list = _coerceItemMapList(v);
      if (list == null || list.length < 2) continue;
      if (list.any(_looksLikeProverkachekaItem)) {
        return list;
      }
    }
    return null;
  }

  bool _looksLikeProverkachekaItem(Map<String, dynamic> m) {
    final sum = _numFromKeys(m, const ['sum', 'productSum', 'lineSum', 'total']);
    final price = _numFromKeys(m, const ['price', 'productPrice', 'cost']);
    if (sum != null && sum > 0) return true;
    if (price != null && price > 0) return true;
    final lower = {
      for (final e in m.entries) e.key.toString().toLowerCase(): e.value,
    };
    for (final k in const ['name', 'productname', 'nm', 'itemname', 'subject']) {
      final v = lower[k];
      if (v != null && v.toString().trim().isNotEmpty) return true;
    }
    return false;
  }

  num? _numFromKeys(Map<String, dynamic> m, List<String> keyOptions) {
    final lower = {
      for (final e in m.entries) e.key.toString().toLowerCase(): e.value,
    };
    for (final want in keyOptions) {
      final v = lower[want.toLowerCase()];
      if (v == null) continue;
      final n = _parseNum(v);
      if (n != null) return n;
    }
    return null;
  }

  String _strFromKeys(Map<String, dynamic> m, List<String> keyOptions, int index) {
    final lower = {
      for (final e in m.entries) e.key.toString().toLowerCase(): e.value,
    };
    for (final want in keyOptions) {
      final v = lower[want.toLowerCase()];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return 'Position ${index + 1}';
  }

  /// Spec: [sum] often **kopecks**; some payloads use rubles with decimals for [price]/[sum].
  ReceiptLine? _receiptLineFromProverkachekaItem(Map<String, dynamic> m, int index) {
    final name = _strFromKeys(
      m,
      const ['name', 'productName', 'nm', 'itemName', 'subject', 'text'],
      index,
    );

    var qty = _numFromKeys(m, const ['quantity', 'qty', 'count', 'pcs', 'productCount']) ?? 1;
    if (qty <= 0) qty = 1;

    final sumRaw = _numFromKeys(m, const ['sum', 'productSum', 'lineSum', 'total', 'amount']);
    final priceField =
        _numFromKeys(m, const ['price', 'productPrice', 'cost', 'priceValue']);

    num unitRub;
    if (priceField != null && priceField > 0) {
      if (priceField >= 1000 && priceField == priceField.roundToDouble()) {
        unitRub = priceField / 100;
      } else {
        unitRub = priceField;
      }
      if (sumRaw != null && sumRaw > 0) {
        final lineRubExpected = _proverkachekaMoneyToRubles(sumRaw, qty);
        final lineRub = unitRub * qty;
        if ((lineRub - lineRubExpected).abs() > 0.05 * lineRubExpected + 0.5) {
          unitRub = lineRubExpected / qty;
        }
      }
    } else if (sumRaw != null && sumRaw > 0) {
      unitRub = _proverkachekaMoneyToRubles(sumRaw, qty) / qty;
    } else {
      return null;
    }

    if (unitRub <= 0) return null;
    return ReceiptLine(name: name, price: unitRub, quantity: qty);
  }

  /// [v] is either line total in **kopecks** (large integer) or in **rubles** (smaller / fractional).
  num _proverkachekaMoneyToRubles(num v, num qty) {
    if (v <= 0) return 0;
    if (v < 1000 && v != v.roundToDouble()) {
      return v;
    }
    if (v >= 1000 && v == v.roundToDouble()) {
      return v / 100;
    }
    if (v < 500 && qty >= 1) {
      return v;
    }
    return v / 100;
  }

  /// Best-effort: if the site returns JSON with a recognizable items array.
  Future<List<ReceiptLine>?> _tryParseRemoteJson(
    String rawQr, {
    num? targetTotalRub,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '$_proverkaHost/api/v1/receipt-by-qr',
        queryParameters: {'qr': rawQr},
        options: Options(
          validateStatus: (s) => s != null && s < 500,
          connectTimeout: _externalConnectTimeout,
          receiveTimeout: _externalReceiveTimeout,
        ),
      );
      _scanQrLog(
        'remote proverkacheka.com HTTP ${response.statusCode} '
        'bodyType=${response.data.runtimeType}',
      );
      if (response.statusCode != 200 || response.data == null) {
        return null;
      }
      final root = _decodeJsonMap(response.data);
      if (root == null) {
        _scanQrLog('remote: body is not JSON object (after decode)');
        return null;
      }
      final lines = _mapJsonToLines(root, targetTotalRub: targetTotalRub);
      _scanQrLog('remote _mapJsonToLines → ${lines?.length ?? 0} line(s)');
      return lines;
    } catch (e, st) {
      _scanQrLogError('remote request failed', e, st);
      return null;
    }
  }

  List<ReceiptLine>? _mapJsonToLines(
    Map<String, dynamic> root, {
    num? targetTotalRub,
    int depth = 0,
  }) {
    if (depth > 8) return null;

    final fns = _linesFromFnsTicketJson(root, targetTotalRub: targetTotalRub);
    if (fns != null && fns.isNotEmpty) return fns;

    final candidates = <dynamic>[
      root['items'],
      root['positions'],
      root['goods'],
      root['data'],
      root['result'],
      root['ticket'],
      root['receipt'],
    ];
    List<dynamic>? list;
    for (final c in candidates) {
      if (c is List) {
        list = c;
        break;
      }
      if (c is Map && c['items'] is List) {
        list = c['items'] as List;
        break;
      }
    }
    if (list != null && list.isNotEmpty) {
      final out = <ReceiptLine>[];
      for (var i = 0; i < list.length; i++) {
        final e = list[i];
        if (e is! Map) continue;
        final m = Map<String, dynamic>.from(e);
        var name = (m['name'] ??
                m['nm'] ??
                m['productName'] ??
                m['productName2024'] ??
                m['itemName'] ??
                '')
            .toString()
            .trim();
        if (name.isEmpty) name = 'Position ${i + 1}';

        final priceRaw = m['price'] ?? m['sum'] ?? m['total'] ?? m['productSum'];
        final qtyRaw = m['quantity'] ?? m['qty'] ?? m['count'] ?? 1;
        if (priceRaw == null) continue;
        final price = num.tryParse(priceRaw.toString().replaceAll(',', '.'));
        final qty = num.tryParse(qtyRaw.toString().replaceAll(',', '.')) ?? 1;
        if (price == null) continue;
        out.add(ReceiptLine(name: name, price: price, quantity: qty));
      }
      if (out.isNotEmpty) {
        if (out.length >= 2) {
          if (targetTotalRub == null || _linesRoughlyMatchTotal(out, targetTotalRub)) {
            return out;
          }
        } else if (_linesRoughlyMatchTotal(out, targetTotalRub)) {
          return out;
        }
      }
    }

    for (final k in const ['data', 'result', 'ticket', 'json', 'content', 'body']) {
      final v = root[k];
      if (v is Map) {
        final inner = _mapJsonToLines(
          Map<String, dynamic>.from(v),
          targetTotalRub: targetTotalRub,
          depth: depth + 1,
        );
        if (inner != null && inner.isNotEmpty) return inner;
      }
    }
    return null;
  }
}
