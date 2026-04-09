import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Represents the four configurable academic tiers.
enum AcademicLevel {
  grades1to8,
  grades9to10,
  grades11to12,
  university;

  String get label {
    switch (this) {
      case AcademicLevel.grades1to8:
        return 'Grades 1–8';
      case AcademicLevel.grades9to10:
        return 'Grades 9–10';
      case AcademicLevel.grades11to12:
        return 'Grades 11–12';
      case AcademicLevel.university:
        return 'University';
    }
  }

  String get shortLabel {
    switch (this) {
      case AcademicLevel.grades1to8:
        return 'Primary';
      case AcademicLevel.grades9to10:
        return 'Middle';
      case AcademicLevel.grades11to12:
        return 'High School';
      case AcademicLevel.university:
        return 'University';
    }
  }

  String get description {
    switch (this) {
      case AcademicLevel.grades1to8:
        return 'Build your foundation with fun, engaging lessons';
      case AcademicLevel.grades9to10:
        return 'Strengthen your skills and explore new subjects';
      case AcademicLevel.grades11to12:
        return 'Prepare for exams with structured study paths';
      case AcademicLevel.university:
        return 'Master advanced concepts at your own pace';
    }
  }

  IconData get icon {
    switch (this) {
      case AcademicLevel.grades1to8:
        return Icons.auto_stories_rounded;
      case AcademicLevel.grades9to10:
        return Icons.science_rounded;
      case AcademicLevel.grades11to12:
        return Icons.school_rounded;
      case AcademicLevel.university:
        return Icons.account_balance_rounded;
    }
  }

  LevelPalette get palette {
    switch (this) {
      case AcademicLevel.grades1to8:
        return LevelPalette.grades1to8;
      case AcademicLevel.grades9to10:
        return LevelPalette.grades9to10;
      case AcademicLevel.grades11to12:
        return LevelPalette.grades11to12;
      case AcademicLevel.university:
        return LevelPalette.university;
    }
  }

  List<String> get grades {
    switch (this) {
      case AcademicLevel.grades1to8:
        return List.generate(8, (i) => 'Grade ${i + 1}');
      case AcademicLevel.grades9to10:
        return ['Grade 9', 'Grade 10'];
      case AcademicLevel.grades11to12:
        return ['Grade 11', 'Grade 12'];
      case AcademicLevel.university:
        return ['Year 1', 'Year 2', 'Year 3', 'Year 4'];
    }
  }
}
