import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../../core/utils/ui_utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionHeader('Preferences'),
          _SettingsTile(
            title: 'Theme',
            subtitle: themeMode == ThemeMode.system
                ? 'System'
                : themeMode == ThemeMode.light
                ? 'Light'
                : 'Dark',
            icon: Icons.palette_outlined,
            onTap: () {
              // Toggle theme for demo purposes
              final current = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          _SettingsTile(
            title: 'Language',
            subtitle: 'English',
            icon: Icons.language_rounded,
            onTap: () => UiUtils.showComingSoonSnackBar(context),
          ),
          _SettingsTile(
            title: 'Academic Level',
            subtitle: 'Change your tier or grade',
            icon: Icons.school_outlined,
            onTap: () => context.push('/setup/tier'),
          ),

          _SectionHeader('Notifications'),
          _SwitchTile(
            title: 'Daily Reminders',
            subtitle: 'Push notifications to study',
            value: true,
            onChanged: (v) {},
          ),
          _SwitchTile(
            title: 'New Lessons',
            subtitle: 'Get notified when new content is added',
            value: true,
            onChanged: (v) {},
          ),

          _SectionHeader('Account'),
          _SettingsTile(
            title: 'Edit Profile',
            icon: Icons.edit_outlined,
            onTap: () => UiUtils.showComingSoonSnackBar(context),
          ),
          _SettingsTile(
            title: 'Data & Privacy',
            icon: Icons.privacy_tip_outlined,
            onTap: () => UiUtils.showComingSoonSnackBar(context),
          ),

          const SizedBox(height: AppSpacing.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(isAuthenticatedProvider.notifier).state = false;
                  context.go('/login');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Log Out'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: AppTypography.titleMedium.copyWith(color: AppColors.primaryText),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondaryText),
      title: Text(title, style: AppTypography.bodyLarge),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.mutedText,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.mutedText,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: AppTypography.bodyLarge),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(color: AppColors.mutedText),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}
