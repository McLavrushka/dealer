import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme textTheme(ColorScheme scheme) {
    return Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        );
  }
}

