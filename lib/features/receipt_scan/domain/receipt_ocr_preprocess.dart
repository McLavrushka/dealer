import 'dart:typed_data';

import 'package:image/image.dart' as im;

/// Light preprocessing so on-device OCR (ML Kit) sees sharper edges and
/// stable scale — helpful on thermal / low-contrast photos.
Uint8List preprocessReceiptImageForOcr(Uint8List bytes) {
  final decoded = im.decodeImage(bytes);
  if (decoded == null) return bytes;

  var img = decoded;
  const maxSide = 2800;
  if (img.width > maxSide || img.height > maxSide) {
    if (img.width >= img.height) {
      img = im.copyResize(
        img,
        width: maxSide,
        interpolation: im.Interpolation.linear,
      );
    } else {
      img = im.copyResize(
        img,
        height: maxSide,
        interpolation: im.Interpolation.linear,
      );
    }
  }

  img = im.adjustColor(
    img,
    contrast: 1.14,
    brightness: 1.03,
    saturation: 1.06,
  );

  return Uint8List.fromList(im.encodeJpg(img, quality: 92));
}

/// Stronger pipeline for **Latin script** (English / EUR-US receipts): grayscale
/// + extra contrast helps ML Kit’s Latin model on thermal paper.
Uint8List preprocessReceiptImageForLatinScriptOcr(Uint8List bytes) {
  final warmed = preprocessReceiptImageForOcr(bytes);
  final decoded = im.decodeImage(warmed);
  if (decoded == null) return warmed;

  var img = im.grayscale(decoded);
  img = im.adjustColor(
    img,
    contrast: 1.12,
    brightness: 1.02,
    saturation: 1.0,
  );
  return Uint8List.fromList(im.encodeJpg(img, quality: 92));
}

/// Stronger contrast for faint thermal ink (second pass for OCR).
Uint8List preprocessReceiptImageForLatinHighContrast(Uint8List bytes) {
  final warmed = preprocessReceiptImageForOcr(bytes);
  final decoded = im.decodeImage(warmed);
  if (decoded == null) return warmed;

  var img = im.grayscale(decoded);
  img = im.adjustColor(
    img,
    contrast: 1.32,
    brightness: 1.04,
    saturation: 0,
  );
  return Uint8List.fromList(im.encodeJpg(img, quality: 92));
}

/// Upscale narrow photos so thin strokes survive downsampling in the pipeline.
Uint8List preprocessReceiptImageUpscaleIfNarrow(Uint8List bytes, {int minWidth = 1400}) {
  final decoded = im.decodeImage(bytes);
  if (decoded == null) return bytes;
  if (decoded.width >= minWidth) return bytes;
  final scale = minWidth / decoded.width;
  final h = (decoded.height * scale).round();
  final img = im.copyResize(
    decoded,
    width: minWidth,
    height: h,
    interpolation: im.Interpolation.cubic,
  );
  return Uint8List.fromList(im.encodeJpg(img, quality: 92));
}

int _luminance255(im.Color p) {
  final r = p.r.toInt();
  final g = p.g.toInt();
  final b = p.b.toInt();
  return ((0.299 * r) + (0.587 * g) + (0.114 * b)).round().clamp(0, 255);
}

/// Otsu threshold on a small grayscale image (fast), returns 0..255.
int _otsuThresholdLuminance(im.Image gray) {
  final hist = List<int>.filled(256, 0);
  var total = 0;
  for (var y = 0; y < gray.height; y++) {
    for (var x = 0; x < gray.width; x++) {
      final l = _luminance255(gray.getPixel(x, y));
      hist[l]++;
      total++;
    }
  }
  if (total == 0) return 128;

  var sumB = 0;
  var wB = 0;
  var wF = 0;
  var maxVar = -1.0;
  var threshold = 127;

  var sumTotal = 0;
  for (var t = 0; t < 256; t++) {
    sumTotal += t * hist[t];
  }

  for (var t = 0; t < 256; t++) {
    wB += hist[t];
    if (wB == 0) continue;
    wF = total - wB;
    if (wF == 0) break;

    sumB += t * hist[t];
    final mB = sumB / wB;
    final mF = (sumTotal - sumB) / wF;
    final between = wB * wF * (mB - mF) * (mB - mF);
    if (between > maxVar) {
      maxVar = between;
      threshold = t;
    }
  }
  return threshold;
}

/// Binarize receipt (dark text on light paper) using Otsu on a thumbnail, applied to full-res grayscale.
Uint8List preprocessReceiptImageForLatinOtsuBinarize(Uint8List bytes) {
  final warmed = preprocessReceiptImageForOcr(bytes);
  final decoded = im.decodeImage(warmed);
  if (decoded == null) return warmed;

  var gray = im.grayscale(decoded);
  gray = im.adjustColor(gray, contrast: 1.08, brightness: 1.02, saturation: 0);

  const thumbW = 640;
  final thumb = gray.width > thumbW
      ? im.copyResize(gray, width: thumbW, interpolation: im.Interpolation.linear)
      : gray;
  final t = _otsuThresholdLuminance(thumb);

  final out = im.Image.from(gray);
  for (var y = 0; y < out.height; y++) {
    for (var x = 0; x < out.width; x++) {
      final l = _luminance255(out.getPixel(x, y));
      final v = l <= t ? 0 : 255;
      out.setPixelRgb(x, y, v, v, v);
    }
  }
  return Uint8List.fromList(im.encodeJpg(out, quality: 92));
}
