import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../../models/subject.dart';

class SelectSubjectsScreen extends ConsumerWidget {
  const SelectSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(availableSubjectsProvider);
    final enrolledIds = ref.watch(enrolledSubjectIdsProvider);
    final tier = ref.watch(selectedTierProvider);
    final palette = tier?.palette;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              GestureDetector(
                onTap: () => context.go('/setup/class'),
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      color: AppColors.secondaryText,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Pick your subjects',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Select the subjects you want to learn. You can change this later.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Selected count chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: palette?.primaryLight ?? AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${enrolledIds.length} subject${enrolledIds.length == 1 ? '' : 's'} selected',
                  style: AppTypography.labelLarge.copyWith(
                    color: palette?.primary ?? AppColors.primaryText,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Expanded(
                child: ListView.separated(
                  itemCount: subjects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final isSelected = enrolledIds.contains(subject.id);

                    return GestureDetector(
                      onTap: () {
                        final current = ref.read(enrolledSubjectIdsProvider);
                        if (isSelected) {
                          ref.read(enrolledSubjectIdsProvider.notifier).state =
                              current.where((id) => id != subject.id).toList();
                        } else {
                          ref.read(enrolledSubjectIdsProvider.notifier).state =
                              [...current, subject.id];
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? palette?.primaryLight ?? AppColors.surface
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? palette?.primary ?? AppColors.border
                                : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: subject.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                subject.icon,
                                color: subject.color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject.name,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    subject.shortDescription,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: isSelected
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      key: const ValueKey('checked'),
                                      color: palette?.primary,
                                      size: 24,
                                    )
                                  : Icon(
                                      Icons.add_circle_outline_rounded,
                                      key: const ValueKey('unchecked'),
                                      color: AppColors.mutedText,
                                      size: 24,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: enrolledIds.isNotEmpty
                        ? () => context.go('/setup/complete')
                        : null,
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
