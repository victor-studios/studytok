import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/level_theme.dart';
import '../models/subject.dart';
import '../models/student_profile.dart';
import '../data/mock/mock_data.dart';
import '../data/repositories/data_repository.dart';
import '../data/repositories/auth_repository.dart';

final appStateControllerProvider = Provider((ref) => AppStateController(ref));

class AppStateController {
  final Ref ref;
  AppStateController(this.ref);

  Future<void> fetchSubjectsForCurrentLevel() async {
    final tier = ref.read(selectedTierProvider);
    final grade = ref.read(selectedGradeProvider);
    if (tier == null || grade == null) return;
    
    final repo = ref.read(dataRepositoryProvider);
    final user = ref.read(authRepositoryProvider).currentUser;

    try {
       final classes = await repo.getAcademicClassesByLevel(tier.name);
       
       // Filter classes by selected grade name, fallback to first class if not matched perfectly
       final selectedClass = classes.firstWhere(
         (c) => c.name == grade, 
         orElse: () => classes.isNotEmpty ? classes.first : const AcademicClass(
            id: '', name: '', description: '', color: Colors.blue, level: AcademicLevel.grades1to8, subjects: []
         ),
       );
       
       var subjects = selectedClass.subjects;
       
       if (user != null) {
         final states = await repo.getUserLessonStates(user.id);
         
         // Deep mutate subjects to apply user state
         subjects = subjects.map((sub) {
           final updatedChapters = sub.chapters.map((ch) {
             final updatedLessons = ch.lessons.map((les) {
               final state = states[les.id];
               if (state != null) {
                 return les.copyWith(
                   isCompleted: state['is_completed'] == true,
                   isBookmarked: state['is_bookmarked'] == true,
                 );
               }
               return les;
             }).toList();
             // Chapter progress calculation happens automatically via getter
             return Chapter(
               id: ch.id, subjectId: ch.subjectId, title: ch.title,
               description: ch.description, orderIndex: ch.orderIndex,
               lessons: updatedLessons, status: ch.status,
             );
           }).toList();
           
           return Subject(
             id: sub.id, classId: sub.classId, name: sub.name, shortDescription: sub.shortDescription,
             icon: sub.icon, chapters: updatedChapters,
           );
         }).toList();
       }

       ref.read(availableSubjectsProvider.notifier).state = subjects;
    } catch (e) {
       debugPrint('Error fetching subjects: $e');
    }
  }
  Future<void> fetchActiveProfile() async {
    final repo = ref.read(dataRepositoryProvider);
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;
    
    try {
      final profile = await repo.getStudentProfile(user.id);
      if (profile != null) {
        ref.read(studentProfilesProvider.notifier).state = [profile];
        ref.read(activeProfileIdProvider.notifier).state = profile.id;
        
        ref.read(selectedTierProvider.notifier).state = 
            AcademicLevel.values.firstWhere((e) => e.name == profile.academicTier, orElse: () => AcademicLevel.grades1to8);
        ref.read(selectedGradeProvider.notifier).state = profile.currentGrade;
        ref.read(enrolledSubjectIdsProvider.notifier).state = profile.enrolledSubjectIds;
        
        await fetchSubjectsForCurrentLevel();
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }
}

// ─── Onboarding State ──────────────────────────────────────────

/// Whether onboarding has been completed.
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Whether user is "logged in" (mock).
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

// ─── Profile & Class Provider (Multi-Class Support) ─────────────

/// All the profiles (classes) the student is enrolled in.
final studentProfilesProvider = StateProvider<List<StudentProfile>>((ref) => []);

/// The ID of the currently active profile (class).
final activeProfileIdProvider = StateProvider<String?>((ref) => null);

/// The fully resolved active profile.
final activeProfileProvider = Provider<StudentProfile?>((ref) {
  final profiles = ref.watch(studentProfilesProvider);
  final activeId = ref.watch(activeProfileIdProvider);
  if (activeId == null || profiles.isEmpty) return null;
  return profiles.firstWhere(
    (p) => p.id == activeId,
    orElse: () => profiles.first,
  );
});

// ─── Academic Level & Grade ────────────────────────────────────

/// Currently selected academic tier (used heavily in onboarding).
final selectedTierProvider = StateProvider<AcademicLevel?>((ref) => null);

/// Currently selected grade/class within the tier.
final selectedGradeProvider = StateProvider<String?>((ref) => null);

// ─── Subject Selection ─────────────────────────────────────────

/// Available subjects based on tier + grade (Populated async from Supabase)
final availableSubjectsProvider = StateProvider<List<Subject>>((ref) => []);

/// IDs of subjects the student has enrolled in for the current profile.
final enrolledSubjectIdsProvider = StateProvider<List<String>>((ref) => []);

/// Enrolled subjects (full objects).
final enrolledSubjectsProvider = Provider<List<Subject>>((ref) {
  final available = ref.watch(availableSubjectsProvider);
  final enrolledIds = ref.watch(enrolledSubjectIdsProvider);
  return available.where((s) => enrolledIds.contains(s.id)).toList();
});

// ─── Current Learning State ────────────────────────────────────

/// Currently active subject in the learn feed.
final currentSubjectProvider = StateProvider<Subject?>((ref) => null);

/// Index of the currently active chapter.
final currentChapterIndexProvider = StateProvider<int>((ref) => 0);

/// Current lesson index within the lesson feed.
final currentLessonIndexProvider = StateProvider<int>((ref) => 0);

/// All lessons for the current subject, flattened across chapters.
final currentLessonsProvider = Provider<List<Lesson>>((ref) {
  final subject = ref.watch(currentSubjectProvider);
  if (subject == null) return [];
  return subject.chapters.expand((ch) => ch.lessons).toList();
});

/// Current chapter based on current lesson.
final currentChapterProvider = Provider<Chapter?>((ref) {
  final subject = ref.watch(currentSubjectProvider);
  final chapterIndex = ref.watch(currentChapterIndexProvider);
  if (subject == null || chapterIndex >= subject.chapters.length) return null;
  return subject.chapters[chapterIndex];
});

/// Whether the immersive video feed is currently playing.
final isVideoPlayingProvider = StateProvider<bool>((ref) => false);

/// Whether the UI overlays on the video feed should be visible.
final showOverlaysProvider = StateProvider<bool>((ref) => true);

// ─── Theme Provider ────────────────────────────────────────────

/// The current theme mode.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// The effective academic level for theming (defaults to grades1to8).
final effectiveLevelProvider = Provider<AcademicLevel>((ref) {
  return ref.watch(selectedTierProvider) ?? AcademicLevel.grades1to8;
});


// ─── Bookmarks Provider ────────────────────────────────────────

final bookmarkedLessonIdsProvider = StateProvider<Set<String>>((ref) => {});

// ─── Bottom Nav Index ──────────────────────────────────────────

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ─── Setup Complete ────────────────────────────────────────────

final setupCompleteProvider = StateProvider<bool>((ref) => false);
