import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../../models/subject.dart';

class SubjectOverviewScreen extends ConsumerWidget {
  final String subjectId;
  const SubjectOverviewScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(enrolledSubjectsProvider);
    final subject = subjects.cast<Subject?>().firstWhere(
      (s) => s?.id == subjectId,
      orElse: () => null,
    );
    final palette = ref.watch(effectiveLevelProvider).palette;

    if (subject == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Subject not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: subject.color,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      subject.color,
                      subject.color.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          subject.name,
                          style: AppTypography.headlineLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(subject.progressPercent * 100).toInt()}% complete · ${subject.chapters.length} chapters',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Continue learning card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: palette.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled_rounded,
                          color: palette.primary,
                          size: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Continue Learning',
                                style: AppTypography.bodySmallMedium.copyWith(
                                  color: palette.primary,
                                ),
                              ),
                              Text(
                                subject.chapters.isNotEmpty
                                    ? subject.chapters.first.title
                                    : '',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: palette.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Chapters list
                  Text('Chapters', style: AppTypography.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  ...subject.chapters.asMap().entries.map((entry) {
                    final i = entry.key;
                    final ch = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: ch.isCompleted
                                        ? palette.primary
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: ch.isCompleted
                                        ? const Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          )
                                        : Text(
                                            '${i + 1}',
                                            style:
                                                AppTypography.bodySmallMedium,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ch.title,
                                        style: AppTypography.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${ch.lessons.length} lessons',
                                        style: AppTypography.labelSmall
                                            .copyWith(
                                              color: AppColors.mutedText,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${(ch.progressPercent * 100).toInt()}%',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: palette.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              lineHeight: 4,
                              percent: ch.progressPercent,
                              backgroundColor: AppColors.border,
                              progressColor: palette.primary,
                              barRadius: const Radius.circular(2),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
