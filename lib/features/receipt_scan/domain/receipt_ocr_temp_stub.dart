/// Web / wasm: no `dart:io`; OCR from a gallery file is not used in this app on web.
Future<String> writeReceiptOcrTempJpeg(List<int> bytes) async {
  throw UnsupportedError('Receipt OCR temp files are not supported on this platform');
}

Future<void> deleteReceiptOcrTemp(String path) async {}
