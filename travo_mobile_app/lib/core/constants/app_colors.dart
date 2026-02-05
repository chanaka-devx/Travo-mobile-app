import 'package:flutter/material.dart';

/// Application color constants
///
/// This class provides a centralized color palette for the Travo mobile app.
/// All color definitions should be referenced from this class to maintain
/// consistency across the application.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ===========================
  // Primary Colors
  // ===========================

  /// Primary brand color - Deep teal (headers, main CTA)
  static const Color primary = Color(0xFF0A445A);

  /// Primary variant - Same as primary for consistency
  static const Color primaryVariant = Color(0xFF0A445A);

  /// Accent color - Interactive blue (links, icons, focus)
  static const Color accent = Color(0xFF13418C);

  /// Secondary color - Neutral accent (timelines, tags)
  static const Color secondary = Color(0xFFB9B3AB);

  // ===========================
  // Background Colors
  // ===========================

  /// Main background color
  static const Color background = Color(0xFFFFFFFF);

  /// Surface color for cards and elevated elements
  static const Color surface = Color(0xFFFFFFFF);

  /// Section background color
  static const Color surfaceLight = Color(0xFFDDDDDD);

  // ===========================
  // Text Colors
  // ===========================

  /// Primary text color - Black
  static const Color textPrimary = Color(0xFF000000);

  /// Secondary text color - Dark grey
  static const Color textSecondary = Color(0xFF4C4C4C);

  /// Disabled text color / Placeholder
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// Text on primary color background (dark surfaces)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text on accent color background (dark surfaces)
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // ===========================
  // UI Element Colors
  // ===========================

  /// Border color
  static const Color border = Color(0xFFDDDDDD);

  /// Divider color
  static const Color divider = Color(0xFFDDDDDD);

  /// Input field fill color
  static const Color inputFill = Color(0xFFF5F5F5);

  /// Shadow color
  static const Color shadow = Color(0x1A000000);

  // ===========================
  // Status Colors
  // ===========================

  /// Success color
  static const Color success = Color(0xFF10B981);

  /// Warning color
  static const Color warning = Color(0xFFF59E0B);

  /// Error color
  static const Color error = Color(0xFFEF4444);

  /// Info color
  static const Color info = Color(0xFF3B82F6);

  // ===========================
  // Transparent Variations
  // ===========================

  /// Primary color with 10% opacity
  static Color get primaryLight10 => primary.withValues(alpha: 0.1);

  /// Primary color with 20% opacity
  static Color get primaryLight20 => primary.withValues(alpha: 0.2);

  /// Primary color with 50% opacity
  static Color get primaryLight50 => primary.withValues(alpha: 0.5);

  /// Accent color with 10% opacity
  static Color get accentLight10 => accent.withValues(alpha: 0.1);

  /// Accent color with 20% opacity
  static Color get accentLight20 => accent.withValues(alpha: 0.2);

  /// Black with 10% opacity
  static Color get blackLight10 => Colors.black.withValues(alpha: 0.1);

  /// Black with 20% opacity
  static Color get blackLight20 => Colors.black.withValues(alpha: 0.2);

  /// White with 50% opacity (overlay cards)
  static Color get whiteLight50 => Colors.white.withValues(alpha: 0.5);

  /// White with 90% opacity
  static Color get whiteLight90 => Colors.white.withValues(alpha: 0.9);

  /// Black with 50% opacity (modal backdrop)
  static Color get modalBackdrop => Colors.black.withValues(alpha: 0.5);

  // ===========================
  // Gradient Colors
  // ===========================

  /// Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );

  /// Accent gradient
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, primary],
  );

  /// Subtle background gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surfaceLight],
  );
}
