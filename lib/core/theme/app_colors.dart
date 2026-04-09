import 'package:flutter/material.dart';

/// Core neutral colors used across all academic levels.
/// These provide a consistent brand identity regardless of tier.
class AppColors {
  AppColors._();

  // ─── Global Neutrals ─────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF475569);
  static const Color mutedText = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // ─── Dark Mode Neutrals ──────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);
  static const Color darkPrimaryText = Color(0xFFF8FAFC);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkMutedText = Color(0xFF64748B);
  static const Color darkBorder = Color(0xFF334155);

  // ─── Semantic Colors ─────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFEAB308);
  static const Color warningLight = Color(0xFFFEF9C3);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoLight = Color(0xFFE0F2FE);

  // ─── Overlay Colors (for video feed) ─────────────────────────
  static const Color videoOverlayTop = Color(0x80000000);
  static const Color videoOverlayBottom = Color(0xCC000000);
  static const Color videoOverlayLight = Color(0x33000000);

  // ─── Shimmer Colors ──────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF1F5F9);
}

/// Level-specific accent palettes.
/// Each academic tier has its own color identity while sharing the same layout.
class LevelPalette {
  final Color primary;
  final Color primaryLight;
  final Color secondary;
  final Color support;

  const LevelPalette({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.support,
  });

  // ─── Level 1: Grades 1–8 ────────────────────────────────────
  // Warm, light, welcoming, playful without looking childish.
  static const grades1to8 = LevelPalette(
    primary: Color(0xFFD95D39),
    primaryLight: Color(0xFFFFF1EC),
    secondary: Color(0xFFFFD166),
    support: Color(0xFF7BDFF2),
  );

  // ─── Level 2: Grades 9–10 ───────────────────────────────────
  // Fresh, energetic, focused.
  static const grades9to10 = LevelPalette(
    primary: Color(0xFF0F766E),
    primaryLight: Color(0xFFECFEF9),
    secondary: Color(0xFF60A5FA),
    support: Color(0xFFA7F3D0),
  );

  // ─── Level 3: Grades 11–12 ──────────────────────────────────
  // Confident, structured, exam-focused.
  static const grades11to12 = LevelPalette(
    primary: Color(0xFF4338CA),
    primaryLight: Color(0xFFEEF2FF),
    secondary: Color(0xFF8B5CF6),
    support: Color(0xFFC7D2FE),
  );

  // ─── Level 4: University ────────────────────────────────────
  // Mature, premium, calm, credible.
  static const university = LevelPalette(
    primary: Color(0xFF1E3A8A),
    primaryLight: Color(0xFFEFF6FF),
    secondary: Color(0xFF0F766E),
    support: Color(0xFFCBD5E1),
  );
}
