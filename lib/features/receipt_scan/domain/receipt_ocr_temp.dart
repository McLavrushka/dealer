import 'receipt_ocr_temp_stub.dart'
    if (dart.library.io) 'receipt_ocr_temp_io.dart' as impl;

Future<String> writeReceiptOcrTempJpeg(List<int> bytes) =>
    impl.writeReceiptOcrTempJpeg(bytes);

Future<void> deleteReceiptOcrTemp(String path) =>
    impl.deleteReceiptOcrTemp(path);
