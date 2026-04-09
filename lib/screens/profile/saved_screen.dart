import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedLessonIdsProvider);
    final allLessons = ref.watch(currentLessonsProvider);
    final savedLessons = allLessons
        .where((l) => bookmarkedIds.contains(l.id))
        .toList();
    final palette = ref.watch(effectiveLevelProvider).palette;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Saved Lessons')),
      body: savedLessons.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(height: 16),
                  Text('No saved lessons yet', style: AppTypography.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any video to save it',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: savedLessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lesson = savedLessons[index];
                return GestureDetector(
                  onTap: () => context.push('/lesson/${lesson.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                palette.primary.withOpacity(0.8),
                                palette.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_filled_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: palette.primaryLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  lesson.chapterTitle,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: palette.primary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                lesson.title,
                                style: AppTypography.bodySmallMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${lesson.duration.inMinutes} mins',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.error,
                          ),
                          onPressed: () {
                            ref
                                .read(bookmarkedLessonIdsProvider.notifier)
                                .state = bookmarkedIds
                                .where((id) => id != lesson.id)
                                .toSet();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
