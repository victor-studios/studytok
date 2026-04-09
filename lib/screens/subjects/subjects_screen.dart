import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../profile/profile_switcher.dart';

class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(enrolledSubjectsProvider);
    final currentSubject = ref.watch(currentSubjectProvider);
    final palette = ref.watch(effectiveLevelProvider).palette;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Subjects'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
               showProfileSwitcher(context, ref);
            },
            icon: const Icon(Icons.swap_horiz_rounded),
            label: const Text('Switch Class'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 56,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(height: 16),
                  Text('No subjects yet', style: AppTypography.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Add subjects from your setup',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final isCurrent = currentSubject?.id == subject.id;
                final progress = subject.progressPercent;

                return GestureDetector(
                  onTap: () => context.push('/subject/${subject.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCurrent ? palette.primary : AppColors.border,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 28,
                          lineWidth: 4,
                          percent: progress,
                          center: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: subject.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              subject.icon,
                              color: subject.color,
                              size: 18,
                            ),
                          ),
                          progressColor: subject.color,
                          backgroundColor: AppColors.border,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    subject.name,
                                    style: AppTypography.titleMedium,
                                  ),
                                  if (isCurrent) ...[
                                    const SizedBox(width: 8),
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
                                        'Current',
                                        style: AppTypography.labelSmall
                                            .copyWith(
                                              color: palette.primary,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${subject.chapters.length} chapters · ${subject.completedLessons}/${subject.totalLessons} lessons',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: AppTypography.numericMedium.copyWith(
                            color: subject.color,
                          ),
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
