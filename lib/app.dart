import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/level_theme.dart';
import 'core/router/app_router.dart';
import 'providers/app_providers.dart';

/// Root application widget.
class StudyTokApp extends ConsumerWidget {
  const StudyTokApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final level = ref.watch(effectiveLevelProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'StudyTok',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(level),
      darkTheme: AppTheme.dark(level),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
