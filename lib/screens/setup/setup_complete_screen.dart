import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';

import '../../models/student_profile.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/data_repository.dart';

class SetupCompleteScreen extends ConsumerWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSaving = false; // We should ideally use State handling, but for now we proceed

    final tier = ref.watch(selectedTierProvider);
    final grade = ref.watch(selectedGradeProvider);
    final subjects = ref.watch(enrolledSubjectsProvider);
    final palette = tier?.palette;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      palette?.primary ?? const Color(0xFF4338CA),
                      palette?.secondary ?? const Color(0xFF7C3AED),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: (palette?.primary ?? const Color(0xFF4338CA))
                          .withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                'You\'re all set!',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your personalised learning path is ready',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      icon: Icons.school_rounded,
                      label: 'Level',
                      value: tier?.label ?? '',
                    ),
                    const Divider(height: 24, color: AppColors.divider),
                    _SummaryRow(
                      icon: Icons.class_rounded,
                      label: 'Class',
                      value: grade ?? '',
                    ),
                    const Divider(height: 24, color: AppColors.divider),
                    _SummaryRow(
                      icon: Icons.library_books_rounded,
                      label: 'Subjects',
                      value: '${subjects.length} selected',
                    ),
                    if (subjects.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: subjects.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  palette?.primaryLight ?? AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(s.icon, size: 14, color: s.color),
                                const SizedBox(width: 6),
                                Text(
                                  s.name,
                                  style: AppTypography.labelLarge.copyWith(
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Start Learning button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Set first subject as current
                    if (subjects.isNotEmpty) {
                      ref.read(currentSubjectProvider.notifier).state =
                          subjects.first;
                    }
                    
                    final user = ref.read(authRepositoryProvider).currentUser;
                    if (user != null && tier != null && grade != null) {
                      final profile = StudentProfile(
                        id: user.id,
                        name: user.userMetadata?['full_name'] ?? 'Student',
                        email: user.email,
                        academicTier: tier.name,
                        currentGrade: grade,
                        enrolledSubjectIds: ref.read(enrolledSubjectIdsProvider),
                        joinedDate: DateTime.now(),
                      );
                      try {
                        await ref.read(dataRepositoryProvider).createStudentProfile(profile);
                        await ref.read(appStateControllerProvider).fetchActiveProfile();
                      } catch (e) {
                         // Fallback logic
                         debugPrint('Error creating profile: $e');
                      }
                    }

                    ref.read(setupCompleteProvider.notifier).state = true;
                    if (context.mounted) context.go('/learn');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Start Learning'),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => context.go('/setup/tier'),
                  child: Text(
                    'Edit Choices',
                    style: AppTypography.buttonSmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.mutedText),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.bodySmallMedium.copyWith(
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
