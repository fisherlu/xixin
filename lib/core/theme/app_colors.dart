import "package:flutter/material.dart";

class AppColors {
  AppColors._();

  // Primary palette - Forest Green
  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryLight = Color(0xFF40916C);
  static const Color primaryDark = Color(0xFF1B4332);

  // Accent - Warm Orange
  static const Color accent = Color(0xFFF4A261);
  static const Color accentLight = Color(0xFFFFB77C);

  // Neutrals
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textOnDark = Color(0xFFF8F9FA);

  // Semantic
  static const Color success = Color(0xFF52B788);
  static const Color error = Color(0xFFE76F51);
  static const Color warning = Color(0xFFFFD166);

  // Meditation gradients
  static const List<Color> gradientMorning = [
    Color(0xFFF4A261),
    Color(0xFFE9C46A),
  ];
  static const List<Color> gradientEvening = [
    Color(0xFF2D6A4F),
    Color(0xFF264653),
  ];
  static const List<Color> gradientSleep = [
    Color(0xFF1B4332),
    Color(0xFF081C15),
  ];
  static const List<Color> gradientBreathing = [
    Color(0xFF40916C),
    Color(0xFF52B788),
  ];
}
