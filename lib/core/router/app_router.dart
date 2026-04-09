import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/setup/select_tier_screen.dart';
import '../../screens/setup/select_class_screen.dart';
import '../../screens/setup/select_subjects_screen.dart';
import '../../screens/setup/setup_complete_screen.dart';
import '../../screens/shell/app_shell.dart';
import '../../screens/learn/learn_feed_screen.dart';
import '../../screens/learn/lesson_detail_screen.dart';
import '../../screens/learn/chapter_complete_screen.dart';
import '../../screens/subjects/subjects_screen.dart';
import '../../screens/subjects/subject_overview_screen.dart';
import '../../screens/tests/tests_screen.dart';
import '../../screens/tests/test_wizard_screen.dart';
import '../../screens/tests/take_test_screen.dart';
import '../../screens/tests/paper_upload_screen.dart';
import '../../screens/tests/ai_processing_screen.dart';
import '../../screens/tests/test_results_screen.dart';
import '../../screens/tests/result_detail_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/dashboard/progress_history_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/settings_screen.dart';
import '../../screens/profile/saved_screen.dart';
import '../../screens/profile/search_screen.dart';
import '../../screens/profile/notifications_screen.dart';

/// App router configuration using go_router.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // ─── Splash & Onboarding ─────────────────────────────
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // ─── Setup Flow ──────────────────────────────────────
      GoRoute(
        path: '/setup/tier',
        builder: (context, state) => const SelectTierScreen(),
      ),
      GoRoute(
        path: '/setup/class',
        builder: (context, state) => const SelectClassScreen(),
      ),
      GoRoute(
        path: '/setup/subjects',
        builder: (context, state) => const SelectSubjectsScreen(),
      ),
      GoRoute(
        path: '/setup/complete',
        builder: (context, state) => const SetupCompleteScreen(),
      ),

      // ─── Main App Shell ──────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/learn',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LearnFeedScreen()),
          ),
          GoRoute(
            path: '/subjects',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SubjectsScreen()),
          ),
          GoRoute(
            path: '/tests',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TestsScreen()),
          ),
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // ─── Detail Screens ──────────────────────────────────
      GoRoute(
        path: '/lesson/:id',
        builder: (context, state) =>
            LessonDetailScreen(lessonId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/chapter-complete',
        builder: (context, state) => const ChapterCompleteScreen(),
      ),
      GoRoute(
        path: '/subject/:id',
        builder: (context, state) =>
            SubjectOverviewScreen(subjectId: state.pathParameters['id']!),
      ),

      // ─── Test Flow ───────────────────────────────────────
      GoRoute(
        path: '/test/create',
        builder: (context, state) => const TestWizardScreen(),
      ),
      GoRoute(
        path: '/test/take/:id',
        builder: (context, state) =>
            TakeTestScreen(testId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/test/upload',
        builder: (context, state) => const PaperUploadScreen(),
      ),
      GoRoute(
        path: '/test/processing',
        builder: (context, state) => const AiProcessingScreen(),
      ),
      GoRoute(
        path: '/test/results/:id',
        builder: (context, state) =>
            TestResultsScreen(testId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/test/result-detail/:id',
        builder: (context, state) =>
            ResultDetailScreen(questionId: state.pathParameters['id']!),
      ),

      // ─── Utility Screens ─────────────────────────────────
      GoRoute(
        path: '/progress-history',
        builder: (context, state) => const ProgressHistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(path: '/saved', builder: (context, state) => const SavedScreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});
