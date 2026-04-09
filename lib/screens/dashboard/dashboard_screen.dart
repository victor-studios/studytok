import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../profile/profile_switcher.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(effectiveLevelProvider).palette;
    final tier = ref.watch(selectedTierProvider);
    final grade = ref.watch(selectedGradeProvider);
    final subjects = ref.watch(enrolledSubjectsProvider);
    final profile = ref.watch(activeProfileProvider);

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showProfileSwitcher(context, ref);
          },
          child: Row(
            children: [
              Text(profile.name),
              const Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push('/progress-history'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.primary, palette.secondary],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier?.label ?? '',
                          style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          grade ?? '',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              color: Colors.orangeAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${profile.currentStreak} day streak',
                              style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 36,
                    lineWidth: 5,
                    percent: 0.35,
                    center: Text(
                      '35%',
                      style: AppTypography.bodySmallMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Continue learning
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: palette.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.play_circle_filled_rounded,
                      color: palette.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue Learning',
                          style: AppTypography.bodySmallMedium,
                        ),
                        Text(
                          subjects.isNotEmpty
                              ? subjects.first.name
                              : 'No subjects',
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
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _DashStat(
                    Icons.timer_rounded,
                    '${profile.totalStudyMinutes}',
                    'Minutes\nStudied',
                    palette.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DashStat(
                    Icons.check_circle_rounded,
                    '12',
                    'Lessons\nDone',
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DashStat(
                    Icons.quiz_rounded,
                    '3',
                    'Tests\nTaken',
                    palette.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DashStat(
                    Icons.star_rounded,
                    '85%',
                    'Avg\nScore',
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Subject progress
            Text('Subject Progress', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...subjects.map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(s.icon, color: s.color, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s.name,
                              style: AppTypography.bodySmallMedium,
                            ),
                          ),
                          Text(
                            '${(s.progressPercent * 100).toInt()}%',
                            style: AppTypography.labelLarge.copyWith(
                              color: s.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        lineHeight: 6,
                        percent: s.progressPercent,
                        backgroundColor: AppColors.border,
                        progressColor: s.color,
                        barRadius: const Radius.circular(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Weekly activity
            Text('This Week', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .asMap()
                    .entries
                    .map((e) {
                      final heights = [0.4, 0.7, 0.5, 0.9, 0.6, 0.3, 0.0];
                      final isToday = e.key == 3;
                      return Column(
                        children: [
                          Container(
                            width: 24,
                            height: 80,
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 24,
                              height: 80 * heights[e.key],
                              decoration: BoxDecoration(
                                color: isToday
                                    ? palette.primary
                                    : palette.primary.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e.value,
                            style: AppTypography.labelSmall.copyWith(
                              color: isToday
                                  ? palette.primary
                                  : AppColors.mutedText,
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _DashStat extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _DashStat(this.icon, this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.numericMedium.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.mutedText,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
