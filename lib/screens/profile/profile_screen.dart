import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../../core/utils/ui_utils.dart';
import 'profile_switcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    final palette = ref.watch(effectiveLevelProvider).palette;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
               showProfileSwitcher(context, ref);
            },
            icon: const Icon(Icons.swap_horiz_rounded),
            label: const Text('Switch Class'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            // Avatar and info
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: palette.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: palette.primary.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  profile.name.substring(0, 1).toUpperCase(),
                  style: AppTypography.displayLarge.copyWith(
                    color: palette.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(profile.name, style: AppTypography.headlineMedium),
            const SizedBox(height: 4),
            Text(
              '${profile.currentGrade} • ${profile.academicTier}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Profile actions
            _ProfileAction(
              icon: Icons.bookmark_rounded,
              label: 'Saved Lessons',
              onTap: () => context.push('/saved'),
              iconColor: palette.primary,
            ),
            _ProfileAction(
              icon: Icons.history_rounded,
              label: 'Test History',
              onTap: () => context.go('/tests'),
              iconColor: palette.secondary,
            ),
            _ProfileAction(
              icon: Icons.military_tech_rounded,
              label: 'Achievements',
              onTap: () => UiUtils.showComingSoonSnackBar(context),
              iconColor: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Help & Support
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Support',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileAction(
              icon: Icons.help_outline_rounded,
              label: 'Help Center',
              onTap: () => UiUtils.showComingSoonSnackBar(context),
            ),
            _ProfileAction(
              icon: Icons.feedback_outlined,
              label: 'Send Feedback',
              onTap: () => UiUtils.showComingSoonSnackBar(context),
            ),
            _ProfileAction(
              icon: Icons.info_outline_rounded,
              label: 'About StudyTok',
              onTap: () => UiUtils.showComingSoonSnackBar(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.secondaryText).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.secondaryText,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(label, style: AppTypography.bodyLarge)),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
