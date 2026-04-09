import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../../models/subject.dart';

class LessonDetailScreen extends ConsumerWidget {
  final String lessonId;
  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(currentLessonsProvider);
    final lesson = lessons.cast<Lesson?>().firstWhere(
      (l) => l?.id == lessonId,
      orElse: () => null,
    );
    final palette = ref.watch(effectiveLevelProvider).palette;
    final isBookmarked = ref
        .watch(bookmarkedLessonIdsProvider)
        .contains(lessonId);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Mini video header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: palette.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isBookmarked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  final bookmarks = ref.read(bookmarkedLessonIdsProvider);
                  if (bookmarks.contains(lessonId)) {
                    ref.read(bookmarkedLessonIdsProvider.notifier).state =
                        bookmarks.where((id) => id != lessonId).toSet();
                  } else {
                    ref.read(bookmarkedLessonIdsProvider.notifier).state = {
                      ...bookmarks,
                      lessonId,
                    };
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [palette.primary, palette.secondary],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: palette.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lesson.chapterTitle,
                      style: AppTypography.labelLarge.copyWith(
                        color: palette.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Title
                  Text(lesson.title, style: AppTypography.headlineLarge),
                  const SizedBox(height: 6),
                  Text(
                    lesson.subtitle,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Meta row
                  Row(
                    children: [
                      _MetaChip(
                        Icons.timer_outlined,
                        '${lesson.duration.inMinutes} min',
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        Icons.playlist_play_rounded,
                        'Lesson ${lesson.lessonNumber}/${lesson.totalLessonsInChapter}',
                      ),
                      if (lesson.teacherName != null) ...[
                        const SizedBox(width: 8),
                        _MetaChip(
                          Icons.person_outline_rounded,
                          lesson.teacherName!,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Transcript section
                  _SectionHeader('Transcript', Icons.description_outlined),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      lesson.transcript ?? 'Transcript not available',
                      style: AppTypography.bodyLarge.copyWith(height: 1.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Key Points
                  if (lesson.keyPoints.isNotEmpty) ...[
                    _SectionHeader(
                      'Key Points',
                      Icons.lightbulb_outline_rounded,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...lesson.keyPoints.map(
                      (point) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: palette.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                point,
                                style: AppTypography.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Formulas
                  if (lesson.formulas.isNotEmpty) ...[
                    _SectionHeader(
                      'Formulas & Definitions',
                      Icons.functions_rounded,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: lesson.formulas.map((f) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: palette.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: palette.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            f,
                            style: AppTypography.titleMedium.copyWith(
                              color: palette.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Action buttons
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/test/create'),
                      icon: const Icon(Icons.quiz_rounded, size: 20),
                      label: const Text('Take Quick Test'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: const Text('Resume Chapter'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaChip(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.mutedText),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondaryText),
        const SizedBox(width: 8),
        Text(title, style: AppTypography.titleMedium),
      ],
    );
  }
}
