import 'package:flutter/material.dart';

/// App color palette based on the custom color scheme
class AppColors {
  AppColors._();

  // Primary color palette
  static const Color primary = Color(0xFF2F5249); // Dark Forest Green
  static const Color secondary = Color(0xFF437057); // Medium Forest Green
  static const Color accent = Color(0xFF97B067); // Sage Green
  static const Color highlight = Color(0xFFE3DE61); // Soft Yellow
  static const Color background = Color(0xFFFBFBFB); // Off White

  // Derived colors for better UI consistency
  static const Color primaryLight = Color(0xFF3D6B5F);
  static const Color primaryDark = Color(0xFF1E3530);
  static const Color secondaryLight = Color(0xFF578268);
  static const Color secondaryDark = Color(0xFF2F5A46);
  static const Color accentLight = Color(0xFFA8C277);
  static const Color accentDark = Color(0xFF7A9651);

  // Semantic colors
  static const Color success = Color(0xFF97B067);
  static const Color warning = Color(0xFFE3DE61);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF437057);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Surface colors with opacity
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withValues(alpha: opacity);
  static Color accentWithOpacity(double opacity) =>
      accent.withValues(alpha: opacity);
  static Color highlightWithOpacity(double opacity) =>
      highlight.withValues(alpha: opacity);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, highlight],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, grey50],
  );
}
