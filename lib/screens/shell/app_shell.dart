import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/app_providers.dart';

/// App shell with the global bottom navigation bar.
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const _tabs = [
    '/learn',
    '/subjects',
    '/tests',
    '/dashboard',
    '/profile',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t));
    final isLearnFeed = location == '/learn';

    return Scaffold(
      body: child,
      extendBody: isLearnFeed,
      bottomNavigationBar: AnimatedOpacity(
        opacity: (isLearnFeed && ref.watch(isVideoPlayingProvider)) ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            color: isLearnFeed
                ? Colors.black.withValues(alpha: 0.85)
                : AppColors.surface,
            border: isLearnFeed
                ? null
                : const Border(
                    top: BorderSide(color: AppColors.border, width: 0.5),
                  ),
          ),
          child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.play_circle_filled_rounded,
                  label: 'Learn',
                  isSelected: currentIndex == 0,
                  isOnDark: isLearnFeed,
                  onTap: () => context.go(_tabs[0]),
                ),
                _NavItem(
                  icon: Icons.library_books_rounded,
                  label: 'Subjects',
                  isSelected: currentIndex == 1,
                  isOnDark: isLearnFeed,
                  onTap: () => context.go(_tabs[1]),
                ),
                _NavItem(
                  icon: Icons.quiz_rounded,
                  label: 'Tests',
                  isSelected: currentIndex == 2,
                  isOnDark: isLearnFeed,
                  onTap: () => context.go(_tabs[2]),
                ),
                _NavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: currentIndex == 3,
                  isOnDark: isLearnFeed,
                  onTap: () => context.go(_tabs[3]),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: currentIndex == 4,
                  isOnDark: isLearnFeed,
                  onTap: () => context.go(_tabs[4]),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isOnDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isOnDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final activeColor = isOnDark ? Colors.white : primary;
    final inactiveColor = isOnDark
        ? Colors.white.withValues(alpha: 0.5)
        : AppColors.mutedText;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isOnDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : primary.withValues(alpha: 0.1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
