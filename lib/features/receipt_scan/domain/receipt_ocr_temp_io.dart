import 'dart:io';

/// Writes [bytes] to a unique JPEG in the system temp directory.
Future<String> writeReceiptOcrTempJpeg(List<int> bytes) async {
  final path =
      '${Directory.systemTemp.path}/dealer_ocr_${DateTime.now().microsecondsSinceEpoch}.jpg';
  final f = File(path);
  await f.writeAsBytes(bytes, flush: true);
  return f.path;
}

Future<void> deleteReceiptOcrTemp(String path) async {
  try {
    final f = File(path);
    if (f.existsSync()) f.deleteSync();
  } catch (_) {}
}
