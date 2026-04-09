import 'package:flutter/material.dart';

/// Border radius tokens for consistent rounded corners.
class AppRadii {
  AppRadii._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 14;
  static const double card = 20;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 999;

  // Pre-built BorderRadius objects
  static final BorderRadius cardRadius = BorderRadius.circular(card);
  static final BorderRadius chipRadius = BorderRadius.circular(full);
  static final BorderRadius buttonRadius = BorderRadius.circular(md);
  static final BorderRadius inputRadius = BorderRadius.circular(sm);
  static final BorderRadius sheetRadius = const BorderRadius.vertical(
    top: Radius.circular(24),
  );
  static final BorderRadius smallRadius = BorderRadius.circular(xs);
}
