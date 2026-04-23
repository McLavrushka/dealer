import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  // Light: keep a simple neutral scheme, so the app is still usable in light mode.
  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: Brightness.light,
  );

  // Dark: explicit scheme from the provided palette (avoid `fromSeed` defaults).
  static final ColorScheme _darkScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.accent,
    onPrimary: AppColors.textPrimary,
    primaryContainer: AppColors.glow,
    onPrimaryContainer: AppColors.textPrimary,

    secondary: AppColors.accent2,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: AppColors.card2,
    onSecondaryContainer: AppColors.textPrimary,

    tertiary: AppColors.chipOrange,
    onTertiary: Color(0xFF1A1208),
    tertiaryContainer: Color(0xFF3A2A12),
    onTertiaryContainer: AppColors.textPrimary,

    error: Color(0xFFFF5C73),
    onError: Color(0xFF22060A),
    errorContainer: Color(0xFF3A0F18),
    onErrorContainer: AppColors.textPrimary,

    background: AppColors.bg,
    onBackground: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,

    // M3 "surface containers" used by text fields / sheets.
    surfaceVariant: AppColors.card2,
    onSurfaceVariant: AppColors.textSecondary,
    outline: Color(0xFF3B3556),
    outlineVariant: Color(0xFF2B2741),

    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.bg,
    inversePrimary: AppColors.accent,
    surfaceTint: AppColors.accent,
  );

  static final ThemeData light = _base(_lightScheme);
  static final ThemeData dark = _base(_darkScheme);

  static ThemeData _base(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme(scheme),
    );

    return base.copyWith(
      scaffoldBackgroundColor:
          scheme.brightness == Brightness.light ? AppColors.neutralBg : scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        color: scheme.brightness == Brightness.dark ? AppColors.card : scheme.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.brightness == Brightness.dark
            ? AppColors.card2
            : scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        hintStyle: base.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        // M3 default for light uses inverse (dark) snackbars; set explicit surfaces.
        backgroundColor: scheme.brightness == Brightness.dark
            ? AppColors.card2
            : scheme.surfaceContainerHighest,
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: scheme.brightness == Brightness.dark
              ? AppColors.textPrimary
              : scheme.onSurface,
        ),
        actionTextColor: scheme.primary,
      ),
    );
  }
}

