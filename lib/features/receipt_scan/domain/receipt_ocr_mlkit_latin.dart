import 'dart:typed_data';

import 'package:google_ml_kit/google_ml_kit.dart';

import 'parse_ocr_use_case.dart';
import 'receipt_ocr_preprocess.dart';
import 'receipt_ocr_temp.dart';
import 'receipt_ocr_text_builder.dart';

/// On-device OCR using ML Kit **Latin** script with several preprocess variants.
///
/// Picks the variant that yields the best downstream parse (more line items),
/// with a fallback score from digit density and raw text length.
abstract final class ReceiptOcrMlKitLatin {
  ReceiptOcrMlKitLatin._();

  static int _score(String text, ParseOcrUseCase parse) {
    if (text.trim().isEmpty) return 0;
    final items = parse.run(text).length;
    final digits = RegExp(r'\d').allMatches(text).length;
    return items * 10000 + digits * 10 + text.trim().length;
  }

  /// Runs ML Kit Latin OCR on multiple preprocessed images and returns the best text.
  static Future<String> recognizeBestFromBytes(
    Uint8List rawBytes,
    ParseOcrUseCase parse,
  ) async {
    final upscaled = preprocessReceiptImageUpscaleIfNarrow(rawBytes);
    final variants = <Uint8List>[
      preprocessReceiptImageForLatinScriptOcr(upscaled),
      preprocessReceiptImageForLatinHighContrast(rawBytes),
      preprocessReceiptImageForLatinOtsuBinarize(upscaled),
    ];

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      var bestText = '';
      var bestScore = -1;

      for (final bytes in variants) {
        String? tmp;
        try {
          tmp = await writeReceiptOcrTempJpeg(bytes);
          final input = InputImage.fromFilePath(tmp);
          final result = await recognizer.processImage(input);
          final text = ReceiptOcrTextBuilder.build(result);
          final sc = _score(text, parse);
          if (sc > bestScore) {
            bestScore = sc;
            bestText = text;
          }
        } finally {
          if (tmp != null) await deleteReceiptOcrTemp(tmp);
        }
      }

      return bestText;
    } finally {
      await recognizer.close();
    }
  }
}
