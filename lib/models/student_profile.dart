/// Student profile model.
class StudentProfile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String academicTier;
  final String currentGrade;
  final List<String> enrolledSubjectIds;
  final DateTime joinedDate;
  final int currentStreak;
  final int totalStudyMinutes;
  final Map<String, double> subjectProgress;

  const StudentProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.academicTier,
    required this.currentGrade,
    this.enrolledSubjectIds = const [],
    required this.joinedDate,
    this.currentStreak = 0,
    this.totalStudyMinutes = 0,
    this.subjectProgress = const {},
  });

  StudentProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? academicTier,
    String? currentGrade,
    List<String>? enrolledSubjectIds,
    int? currentStreak,
    int? totalStudyMinutes,
    Map<String, double>? subjectProgress,
  }) {
    return StudentProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      academicTier: academicTier ?? this.academicTier,
      currentGrade: currentGrade ?? this.currentGrade,
      enrolledSubjectIds: enrolledSubjectIds ?? this.enrolledSubjectIds,
      joinedDate: joinedDate,
      currentStreak: currentStreak ?? this.currentStreak,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      subjectProgress: subjectProgress ?? this.subjectProgress,
    );
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      academicTier: json['academic_tier'] as String,
      currentGrade: json['current_grade'] as String,
      enrolledSubjectIds: List<String>.from(json['enrolled_subject_ids'] ?? []),
      joinedDate: DateTime.parse(json['joined_date']).toLocal(),
      currentStreak: json['current_streak'] as int? ?? 0,
      totalStudyMinutes: json['total_study_minutes'] as int? ?? 0,
      subjectProgress: Map<String, double>.from(json['subject_progress'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'academic_tier': academicTier,
      'current_grade': currentGrade,
      'enrolled_subject_ids': enrolledSubjectIds,
      'joined_date': joinedDate.toUtc().toIso8601String(),
      'current_streak': currentStreak,
      'total_study_minutes': totalStudyMinutes,
      'subject_progress': subjectProgress,
    };
  }
}
