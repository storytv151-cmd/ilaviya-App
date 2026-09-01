import 'package:flutter/material.dart';

/// Luxury White / Light E-commerce Theme design tokens for ILAVIYA.
class SplashTheme {
  SplashTheme._();

  // Core Palette - Crisp Luxury White & Champagne Gold
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundTop = Color(0xFFFFFFFF);
  static const Color backgroundBottom = Color(0xFFF7F8FA);

  static const Color goldLight = Color(0xFFF6DE9F);
  static const Color goldPrimary = Color(0xFFC79825);
  static const Color goldDark = Color(0xFF987214);
  static const Color goldSubtle = Color(0x1AD4AF37);
  static const Color goldSelectedBg = Color(0xFFFFFDF5);

  static const Color textPrimary = Color(0xFF11141A);
  static const Color textSecondary = Color(0xFF4B5565);
  static const Color textTertiary = Color(0xFF8C93A4);

  static const Color accentRose = Color(0xFFDF7E66);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFECEFF3);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, goldPrimary, goldDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFCFCFD),
      Color(0xFFF6F7FA),
    ],
  );

  static const LinearGradient darkOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x66000000),
      Color(0x11000000),
      Color(0x11000000),
      Color(0x88000000),
    ],
    stops: [0.0, 0.25, 0.75, 1.0],
  );

  static const RadialGradient ambientGlow = RadialGradient(
    center: Alignment.center,
    radius: 0.85,
    colors: [
      Color(0x14D4AF37),
      Color(0x00FFFFFF),
    ],
  );

  // Text Styles
  static const TextStyle brandTitleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 8.0,
    color: textPrimary,
  );

  static const TextStyle brandSubtitleStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 3.5,
    color: goldPrimary,
  );

  static const TextStyle badgeTextStyle = TextStyle(
    fontSize: 9.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.8,
    color: textSecondary,
  );

  static const TextStyle footerTextStyle = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.5,
    color: textTertiary,
  );
}
