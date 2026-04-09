import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';

void showProfileSwitcher(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final profiles = ref.watch(studentProfilesProvider);
      final activeProfileId = ref.watch(activeProfileIdProvider);
      final palette = ref.watch(effectiveLevelProvider).palette;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch Class',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              ...profiles.map((p) {
                final isActive = p.id == activeProfileId;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isActive
                          ? palette.primary.withValues(alpha: 0.1)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive ? palette.primary : AppColors.border,
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        p.name.substring(0, 1).toUpperCase(),
                        style: AppTypography.titleMedium.copyWith(
                          color: isActive ? palette.primary : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    p.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    '${p.currentGrade} • ${p.academicTier}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                  trailing: isActive
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: palette.primary,
                        )
                      : null,
                  onTap: () {
                    ref.read(activeProfileIdProvider.notifier).state = p.id;
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                title: Text(
                  'Add New Class',
                  style: AppTypography.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  // Setup tier for new profile
                  ref.read(selectedTierProvider.notifier).state = null;
                  ref.read(selectedGradeProvider.notifier).state = null;
                  context.push('/setup/tier');
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      );
    },
  );
}
