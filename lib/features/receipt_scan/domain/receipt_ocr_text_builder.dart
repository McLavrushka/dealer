import 'package:google_ml_kit/google_ml_kit.dart';

/// Builds plain text from [RecognizedText] using line bounding boxes.
///
/// ML Kit’s aggregated [RecognizedText.text] can reorder lines badly on
/// multi-column receipts; sorting by vertical position then **left** edge
/// restores reading order and improves downstream parsing for Russian checks.
abstract final class ReceiptOcrTextBuilder {
  static String build(RecognizedText recognized) {
    final lines = <TextLine>[];
    for (final block in recognized.blocks) {
      lines.addAll(block.lines);
    }
    if (lines.isEmpty) return recognized.text;

    const rowTol = 10.0;
    int rowKey(TextLine l) =>
        ((l.boundingBox.top + l.boundingBox.height / 2) / rowTol).round();

    lines.sort((a, b) {
      final rk = rowKey(a).compareTo(rowKey(b));
      if (rk != 0) return rk;
      return a.boundingBox.left.compareTo(b.boundingBox.left);
    });

    return lines
        .map((e) => e.text.trim())
        .where((t) => t.isNotEmpty)
        .join('\n');
  }
}
