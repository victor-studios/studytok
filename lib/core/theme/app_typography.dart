import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for StudyTok.
/// Uses Inter on Android/Web, SF Pro on iOS (via system fallback).
/// Strong hierarchy with scalable text for educational content.
class AppTypography {
  AppTypography._();

  static String? _fontFamily;

  static String get fontFamily {
    _fontFamily ??= GoogleFonts.inter().fontFamily;
    return _fontFamily!;
  }

  // ─── Display / Hero: 30–34, Semibold ─────────────────────────
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  // ─── Section title: 22–24, Semibold ──────────────────────────
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.2,
  );

  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  // ─── Card title: 18–20, Semibold ─────────────────────────────
  static TextStyle get titleLarge =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4);

  static TextStyle get titleMedium =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);

  // ─── Body: 16, Regular ───────────────────────────────────────
  static TextStyle get bodyLarge =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);

  static TextStyle get bodyMedium =>
      GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5);

  // ─── Support text: 14, Regular/Medium ────────────────────────
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static TextStyle get bodySmallMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  // ─── Chip / label: 12–13, Medium ─────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.2,
  );

  // ─── Button text: 15–16, Semibold ────────────────────────────
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  // ─── Numeric progress / scores: 20–24, Bold ─────────────────
  static TextStyle get numericLarge =>
      GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2);

  static TextStyle get numericMedium =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, height: 1.2);

  /// Build a complete TextTheme for Material ThemeData.
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelSmall: labelSmall,
  );
}
