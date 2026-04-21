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
