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

  /// Primary brand color - Fresh green
  static const Color primary = Color(0xFF4CAF50);

  /// Primary variant - Light green
  static const Color primaryVariant = Color(0xFF66BB6A);

  /// Accent color - Mint green
  static const Color accent = Color(0xFF00E676);

  /// Secondary color - Soft green
  static const Color secondary = Color(0xFF81C784);

  // ===========================
  // Background Colors
  // ===========================

  /// Main background color
  static const Color background = Color(0xFFFFFFFF);

  /// Surface color for cards and elevated elements
  static const Color surface = Color(0xFFFFFFFF);

  /// Light surface color
  static const Color surfaceLight = Color(0xFFF5F5F5);

  // ===========================
  // Text Colors
  // ===========================

  /// Primary text color - Dark slate
  static const Color textPrimary = Color(0xFF1E293B);

  /// Secondary text color - Grey
  static const Color textSecondary = Color(0xFF64748B);

  /// Disabled text color
  static const Color textDisabled = Color(0xFF94A3B8);

  /// Text on primary color background
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text on accent color background
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // ===========================
  // UI Element Colors
  // ===========================

  /// Border color
  static const Color border = Color(0xFFE2E8F0);

  /// Divider color
  static const Color divider = Color(0xFFCBD5E1);

  /// Input field fill color
  static const Color inputFill = Color(0xFFF1F5F9);

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

  /// White with 90% opacity
  static Color get whiteLight90 => Colors.white.withValues(alpha: 0.9);

  // ===========================
  // Gradient Colors
  // ===========================

  /// Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryVariant],
  );

  /// Accent gradient
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, secondary],
  );

  /// Subtle background gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surfaceLight],
  );
}
