import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/level_theme.dart';
import '../../models/subject.dart';

/// Mock data generator for all academic tiers.
class MockData {
  MockData._();

  /// Get subjects for a given tier and grade.
  static List<Subject> getSubjects(AcademicLevel level, String grade) {
    switch (level) {
      case AcademicLevel.grades1to8:
        return _primarySubjects(level, grade);
      case AcademicLevel.grades9to10:
        return _middleSubjects(level, grade);
      case AcademicLevel.grades11to12:
        return _highSchoolSubjects(level, grade);
      case AcademicLevel.university:
        return _universitySubjects(level, grade);
    }
  }

  static List<Subject> _primarySubjects(AcademicLevel level, String grade) {
    return [
      _buildSubject(
        'math-primary',
        'Mathematics',
        'Numbers, shapes, and patterns',
        LucideIcons.calculator,
        const Color(0xFFD95D39),
        level,
        grade,
        _mathChapters('math-primary'),
      ),
      _buildSubject(
        'science-primary',
        'Science',
        'Explore the world around you',
        LucideIcons.flaskConical,
        const Color(0xFF7BDFF2),
        level,
        grade,
        _scienceChapters('science-primary'),
      ),
      _buildSubject(
        'english-primary',
        'English',
        'Reading, writing, and grammar',
        LucideIcons.bookOpen,
        const Color(0xFFFFD166),
        level,
        grade,
        _englishChapters('english-primary'),
      ),
      _buildSubject(
        'social-primary',
        'Social Studies',
        'History, geography, and civics',
        LucideIcons.globe,
        const Color(0xFF60A5FA),
        level,
        grade,
        [],
      ),
      _buildSubject(
        'art-primary',
        'Art & Creativity',
        'Express yourself through art',
        LucideIcons.palette,
        const Color(0xFFA78BFA),
        level,
        grade,
        [],
      ),
    ];
  }

  static List<Subject> _middleSubjects(AcademicLevel level, String grade) {
    return [
      _buildSubject(
        'math-middle',
        'Mathematics',
        'Algebra, geometry, and data',
        LucideIcons.calculator,
        const Color(0xFF0F766E),
        level,
        grade,
        _mathChapters('math-middle'),
      ),
      _buildSubject(
        'physics-middle',
        'Physics',
        'Forces, energy, and motion',
        LucideIcons.zap,
        const Color(0xFF60A5FA),
        level,
        grade,
        _physicsChapters('physics-middle'),
      ),
      _buildSubject(
        'chemistry-middle',
        'Chemistry',
        'Elements, compounds, and reactions',
        LucideIcons.flaskConical,
        const Color(0xFFA7F3D0),
        level,
        grade,
        [],
      ),
      _buildSubject(
        'biology-middle',
        'Biology',
        'Life, cells, and ecosystems',
        LucideIcons.microscope,
        const Color(0xFF4ADE80),
        level,
        grade,
        [],
      ),
      _buildSubject(
        'english-middle',
        'English',
        'Literature and composition',
        LucideIcons.bookOpen,
        const Color(0xFFFBBF24),
        level,
        grade,
        [],
      ),
    ];
  }

  static List<Subject> _highSchoolSubjects(AcademicLevel level, String grade) {
    return [
      _buildSubject(
        'math-hs',
        'Mathematics',
        'Calculus, statistics, and advanced algebra',
        LucideIcons.calculator,
        const Color(0xFF4338CA),
        level,
        grade,
        _mathChapters('math-hs'),
      ),
      _buildSubject(
        'physics-hs',
        'Physics',
        'Mechanics, waves, and thermodynamics',
        LucideIcons.zap,
        const Color(0xFF8B5CF6),
        level,
        grade,
        _physicsChapters('physics-hs'),
      ),
      _buildSubject(
        'chemistry-hs',
        'Chemistry',
        'Organic, inorganic, and physical chemistry',
        LucideIcons.flaskConical,
        const Color(0xFFC7D2FE),
        level,
        grade,
        [],
      ),
      _buildSubject(
        'biology-hs',
        'Biology',
        'Genetics, evolution, and ecology',
        LucideIcons.microscope,
        const Color(0xFF34D399),
        level,
        grade,
        [],
      ),
      _buildSubject(
        'economics-hs',
        'Economics',
        'Micro and macroeconomics',
        LucideIcons.trendingUp,
        const Color(0xFFF59E0B),
        level,
        grade,
        [],
      ),
      _buildSubject(
        'cs-hs',
        'Computer Science',
        'Programming and algorithms',
        LucideIcons.code,
        const Color(0xFF06B6D4),
        level,
        grade,
        [],
      ),
    ];
  }

  static List<Subject> _universitySubjects(AcademicLevel level, String grade) {
    return [
      _buildSubject(
        'math-uni',
        'Advanced Mathematics',
        'Linear algebra, differential equations',
        LucideIcons.calculator,
        const Color(0xFF1E3A8A),
        level,
        grade,
        _mathChapters('math-uni'),
      ),
      _buildSubject(
        'physics-uni',
        'Physics',
        'Quantum mechanics and electrodynamics',
        LucideIcons.zap,
        const Color(0xFF0F766E),
        level,
        grade,
        _physicsChapters('physics-uni'),
      ),
      _buildSubject(
        'cs-uni',
        'Computer Science',
        'Data structures, AI, and systems',
        LucideIcons.code,
        const Color(0xFF7C3AED),
        level,
        grade,
        [],
      ),
      _buildSubject(
        'economics-uni',
        'Economics',
        'Econometrics and game theory',
        LucideIcons.trendingUp,
        const Color(0xFFCBD5E1),
        level,
        grade,
        [],
      ),
    ];
  }

  static Subject _buildSubject(
    String id,
    String name,
    String desc,
    IconData icon,
    Color color,
    AcademicLevel level,
    String grade,
    List<Chapter> chapters,
  ) {
    return Subject(
      id: id,
      name: name,
      shortDescription: desc,
      icon: icon,
      color: color,
      chapters: chapters,
      level: level,
      grade: grade,
    );
  }

  // ─── Chapter & Lesson Generators ─────────────────────────────

  static List<Chapter> _mathChapters(String subjectId) {
    final chapterData = [
      ('ch1', 'Number Systems', 'Understanding integers, rationals, and reals'),
      ('ch2', 'Algebra Basics', 'Expressions, equations, and inequalities'),
      ('ch3', 'Geometry', 'Shapes, angles, and spatial reasoning'),
      (
        'ch4',
        'Data & Statistics',
        'Collecting, organizing, and interpreting data',
      ),
      ('ch5', 'Measurement', 'Units, conversions, and applications'),
    ];

    return chapterData.asMap().entries.map((e) {
      final idx = e.key;
      final d = e.value;
      return Chapter(
        id: '${subjectId}-${d.$1}',
        subjectId: subjectId,
        title: d.$2,
        description: d.$3,
        orderIndex: idx,
        status: idx == 0
            ? ChapterStatus.current
            : idx < 0
            ? ChapterStatus.completed
            : ChapterStatus.notStarted,
        lessons: _generateLessons(subjectId, '${subjectId}-${d.$1}', d.$2, 6, isFirstChapter: idx == 0),
      );
    }).toList();
  }

  static List<Chapter> _scienceChapters(String subjectId) {
    final chapterData = [
      ('ch1', 'Living Things', 'Plants, animals, and organisms'),
      ('ch2', 'Matter & Materials', 'States of matter and properties'),
      ('ch3', 'Forces & Energy', 'Push, pull, and energy forms'),
      ('ch4', 'Earth & Space', 'Our planet and the solar system'),
    ];

    return chapterData.asMap().entries.map((e) {
      final idx = e.key;
      final d = e.value;
      return Chapter(
        id: '${subjectId}-${d.$1}',
        subjectId: subjectId,
        title: d.$2,
        description: d.$3,
        orderIndex: idx,
        status: idx == 0 ? ChapterStatus.current : ChapterStatus.notStarted,
        lessons: _generateLessons(subjectId, '${subjectId}-${d.$1}', d.$2, 5, isFirstChapter: idx == 0),
      );
    }).toList();
  }

  static List<Chapter> _englishChapters(String subjectId) {
    final chapterData = [
      ('ch1', 'Grammar Essentials', 'Parts of speech and sentence structure'),
      ('ch2', 'Reading Comprehension', 'Understanding texts and contexts'),
      ('ch3', 'Writing Skills', 'Paragraphs, essays, and creative writing'),
    ];

    return chapterData.asMap().entries.map((e) {
      final idx = e.key;
      final d = e.value;
      return Chapter(
        id: '${subjectId}-${d.$1}',
        subjectId: subjectId,
        title: d.$2,
        description: d.$3,
        orderIndex: idx,
        status: idx == 0 ? ChapterStatus.current : ChapterStatus.notStarted,
        lessons: _generateLessons(subjectId, '${subjectId}-${d.$1}', d.$2, 4, isFirstChapter: idx == 0),
      );
    }).toList();
  }

  static List<Chapter> _physicsChapters(String subjectId) {
    final chapterData = [
      ('ch1', 'Mechanics', 'Motion, forces, and Newton\'s laws'),
      ('ch2', 'Energy & Work', 'Kinetic, potential, and conservation'),
      ('ch3', 'Waves & Sound', 'Oscillations, wave properties, and acoustics'),
      ('ch4', 'Electricity', 'Circuits, current, and resistance'),
      ('ch5', 'Optics', 'Light, reflection, and refraction'),
    ];

    return chapterData.asMap().entries.map((e) {
      final idx = e.key;
      final d = e.value;
      return Chapter(
        id: '${subjectId}-${d.$1}',
        subjectId: subjectId,
        title: d.$2,
        description: d.$3,
        orderIndex: idx,
        status: idx == 0 ? ChapterStatus.current : ChapterStatus.notStarted,
        lessons: _generateLessons(subjectId, '${subjectId}-${d.$1}', d.$2, 7, isFirstChapter: idx == 0),
      );
    }).toList();
  }

  static List<Lesson> _generateLessons(
    String subjectId,
    String chapterId,
    String chapterTitle,
    int count, {
    bool isFirstChapter = false,
  }) {
    final lessonTitles = [
      'Introduction & Overview',
      'Core Concepts Explained',
      'Key Definitions & Terms',
      'Worked Examples',
      'Practice Problems',
      'Real-World Applications',
      'Summary & Review',
      'Advanced Techniques',
    ];

    final sampleVideos = [
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    ];

    return List.generate(count, (i) {
      final String demoVideoUrl = sampleVideos[i % sampleVideos.length];

      return Lesson(
        id: '$chapterId-lesson-${i + 1}',
        chapterId: chapterId,
        subjectId: subjectId,
        title: lessonTitles[i % lessonTitles.length],
        subtitle: 'Learn the fundamentals step by step',
        chapterTitle: chapterTitle,
        lessonNumber: i + 1,
        totalLessonsInChapter: count,
        videoUrl: demoVideoUrl,
        duration: Duration(minutes: 2 + (i % 4)),
        transcript:
            'This is a detailed transcript for lesson ${i + 1} of $chapterTitle. '
            'In this lesson, we will explore key concepts and work through examples together. '
            'Pay attention to the formulas and definitions highlighted throughout.',
        keyPoints: [
          'Key concept ${i + 1}.1: Understanding the basics',
          'Key concept ${i + 1}.2: Applying the formula',
          'Key concept ${i + 1}.3: Common mistakes to avoid',
        ],
        formulas: i % 2 == 0 ? ['E = mc²', 'F = ma', 'a² + b² = c²'] : [],
        teacherName: 'Dr. Sarah Chen',
        isCompleted: false,
        isBookmarked: false,
      );
    });
  }
}
