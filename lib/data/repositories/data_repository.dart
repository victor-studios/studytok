import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/student_profile.dart';
import '../../models/subject.dart';
import 'auth_repository.dart';

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  final supabase = Supabase.instance.client;
  return DataRepository(supabase);
});

class DataRepository {
  final SupabaseClient _supabase;

  DataRepository(this._supabase);

  /// Get student profile
  Future<StudentProfile?> getStudentProfile(String id) async {
    try {
      final data = await _supabase
          .from('student_profiles')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (data == null) return null;
      return StudentProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  /// Create student profile
  Future<void> createStudentProfile(StudentProfile profile) async {
    try {
      await _supabase.from('student_profiles').upsert(profile.toJson());
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  /// Fetch classes with their nested subjects, chapters, and lessons
  Future<List<AcademicClass>> getAcademicClassesByLevel(String level) async {
    try {
      final data = await _supabase
          .from('academic_classes')
          .select('''
            *,
            subjects:subjects (
              *,
              chapters:chapters (
                *,
                lessons:lessons (*)
              )
            )
          ''')
          .eq('academic_level', level);

      return (data as List).map((e) => AcademicClass.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load academic classes: $e');
    }
  }

  /// Update user lesson state (completion/bookmark)
  Future<void> upsertUserLessonState({
    required String userId,
    required String lessonId,
    bool? isCompleted,
    bool? isBookmarked,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'user_id': userId,
        'lesson_id': lessonId,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      if (isCompleted != null) updates['is_completed'] = isCompleted;
      if (isBookmarked != null) updates['is_bookmarked'] = isBookmarked;

      await _supabase.from('user_lesson_state').upsert(updates);
    } catch (e) {
      throw Exception('Failed to update state: $e');
    }
  }

  /// Fetch user active lesson states
  Future<Map<String, Map<String, dynamic>>> getUserLessonStates(String userId) async {
    try {
      final result = await _supabase
          .from('user_lesson_state')
          .select('lesson_id, is_completed, is_bookmarked')
          .eq('user_id', userId);
      
      final Map<String, Map<String, dynamic>> mapping = {};
      for (var row in result) {
        mapping[row['lesson_id']] = row;
      }
      return mapping;
    } catch (e) {
      throw Exception('Failed to load lesson states: $e');
    }
  }
}
