import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand / accent
  static const accent = Color(0xFF8B5CFF);
  static const accent2 = Color(0xFF915CFF);

  // Backgrounds / surfaces
  static const bg = Color(0xFF05060B);
  static const surface = Color(0xFF080816);
  static const card = Color(0xFF1E1A2B);
  static const card2 = Color(0xFF242036);

  // Text
  static const textPrimary = Color(0xFFF7F3FF);
  static const textSecondary = Color(0xFFB0B2C4);
  static const textMuted = Color(0xFF8283A0);

  // Chips
  static const chipVioletBg = Color(0xFF3C245F);
  static const chipOrange = Color(0xFFF29F3C);

  // Light fallback
  static const neutralBg = Color(0xFFF6F7F9);

  // Back-compat: used in some widgets (e.g. AdaptiveLayout side background).
  static const neutralBgDark = bg;
// Accents / glow
  static const glow = Color(0xFF3E1859);
}

