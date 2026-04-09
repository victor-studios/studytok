import 'package:flutter/material.dart';
import '../core/theme/level_theme.dart';

/// Represents a subject within a class/grade.
class Subject {
  final String id;
  final String name;
  final String shortDescription;
  final IconData icon;
  final Color color;
  final List<Chapter> chapters;
  final AcademicLevel level;
  final String grade;

  const Subject({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.icon,
    required this.color,
    this.chapters = const [],
    required this.level,
    required this.grade,
  });

  int get totalLessons =>
      chapters.fold(0, (sum, ch) => sum + ch.lessons.length);

  int get completedLessons => chapters.fold(
    0,
    (sum, ch) => sum + ch.lessons.where((l) => l.isCompleted).length,
  );

  double get progressPercent =>
      totalLessons == 0 ? 0 : completedLessons / totalLessons;

  factory Subject.fromJson(Map<String, dynamic> json) {
    // A robust mapping of icon strings to IconData would go here. For now, default to local mapping or a fallback.
    IconData parseIcon(String iconStr) {
      if (iconStr.contains('calculator')) return Icons.calculate;
      if (iconStr.contains('zap')) return Icons.bolt;
      return Icons.book;
    }

    Color parseColor(String colorStr) {
      if (colorStr.startsWith('0x')) {
        return Color(int.parse(colorStr));
      }
      return Colors.blue;
    }

    return Subject(
      id: json['id'],
      name: json['name'],
      shortDescription: json['short_description'] ?? '',
      icon: parseIcon(json['icon_name'] ?? ''),
      color: parseColor(json['color_hex'] ?? ''),
      level: AcademicLevel.values.firstWhere(
        (e) => e.name == json['academic_level'],
        orElse: () => AcademicLevel.grades1to8,
      ),
      grade: json['grade'] ?? '',
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((c) => Chapter.fromJson(c))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_description': shortDescription,
      'icon_name': icon.toString(),
      'color_hex': '0xff${color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      'academic_level': level.name,
      'grade': grade,
      'chapters': chapters.map((c) => c.toJson()).toList(),
    };
  }
}

/// Represents a chapter within a subject.
class Chapter {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final int orderIndex;
  final List<Lesson> lessons;
  final ChapterStatus status;

  const Chapter({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.orderIndex,
    this.lessons = const [],
    this.status = ChapterStatus.notStarted,
  });

  int get completedLessons => lessons.where((l) => l.isCompleted).length;

  double get progressPercent =>
      lessons.isEmpty ? 0 : completedLessons / lessons.length;

  bool get isCompleted =>
      lessons.isNotEmpty && completedLessons == lessons.length;

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      subjectId: json['subject_id'],
      title: json['title'],
      description: json['description'] ?? '',
      orderIndex: json['order_index'] ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((l) => Lesson.fromJson(l))
              .toList() ??
          [],
      status: ChapterStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ChapterStatus.notStarted,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'title': title,
      'description': description,
      'order_index': orderIndex,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'status': status.name,
    };
  }
}

enum ChapterStatus {
  locked,
  notStarted,
  current,
  completed;

  String get label {
    switch (this) {
      case ChapterStatus.locked:
        return 'Locked';
      case ChapterStatus.notStarted:
        return 'Not Started';
      case ChapterStatus.current:
        return 'In Progress';
      case ChapterStatus.completed:
        return 'Completed';
    }
  }
}

/// Represents a single lesson (a short video card in the feed).
class Lesson {
  final String id;
  final String chapterId;
  final String subjectId;
  final String title;
  final String subtitle;
  final String chapterTitle;
  final int lessonNumber;
  final int totalLessonsInChapter;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? transcript;
  final List<String> keyPoints;
  final List<String> formulas;
  final Duration duration;
  final bool isCompleted;
  final bool isBookmarked;
  final String? teacherName;

  const Lesson({
    required this.id,
    required this.chapterId,
    required this.subjectId,
    required this.title,
    required this.subtitle,
    required this.chapterTitle,
    required this.lessonNumber,
    required this.totalLessonsInChapter,
    this.videoUrl,
    this.thumbnailUrl,
    this.transcript,
    this.keyPoints = const [],
    this.formulas = const [],
    this.duration = const Duration(minutes: 3),
    this.isCompleted = false,
    this.isBookmarked = false,
    this.teacherName,
  });

  Lesson copyWith({bool? isCompleted, bool? isBookmarked}) {
    return Lesson(
      id: id,
      chapterId: chapterId,
      subjectId: subjectId,
      title: title,
      subtitle: subtitle,
      chapterTitle: chapterTitle,
      lessonNumber: lessonNumber,
      totalLessonsInChapter: totalLessonsInChapter,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      transcript: transcript,
      keyPoints: keyPoints,
      formulas: formulas,
      duration: duration,
      isCompleted: isCompleted ?? this.isCompleted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      teacherName: teacherName,
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      chapterId: json['chapter_id'],
      subjectId: json['subject_id'],
      title: json['title'],
      subtitle: json['subtitle'] ?? '',
      chapterTitle: json['chapter_title'] ?? '',
      lessonNumber: json['lesson_number'] ?? 1,
      totalLessonsInChapter: json['total_lessons_in_chapter'] ?? 1,
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      transcript: json['transcript'],
      keyPoints: List<String>.from(json['key_points'] ?? []),
      formulas: List<String>.from(json['formulas'] ?? []),
      duration: Duration(seconds: json['duration_seconds'] ?? 180),
      teacherName: json['teacher_name'],
      isCompleted: false, // Populated via user_lesson_state
      isBookmarked: false, // Populated via user_lesson_state
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'subject_id': subjectId,
      'title': title,
      'subtitle': subtitle,
      'chapter_title': chapterTitle,
      'lesson_number': lessonNumber,
      'total_lessons_in_chapter': totalLessonsInChapter,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'transcript': transcript,
      'key_points': keyPoints,
      'formulas': formulas,
      'duration_seconds': duration.inSeconds,
      'teacher_name': teacherName,
    };
  }
}
