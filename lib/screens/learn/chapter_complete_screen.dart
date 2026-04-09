import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';

class ChapterCompleteScreen extends ConsumerWidget {
  const ChapterCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(currentChapterProvider);
    final palette = ref.watch(effectiveLevelProvider).palette;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Celebration icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [palette.primary, palette.secondary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: palette.primary.withOpacity(0.3),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.celebration_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Chapter Complete!', style: AppTypography.headlineLarge),
              const SizedBox(height: 8),
              Text(
                chapter?.title ?? 'Chapter',
                style: AppTypography.titleMedium.copyWith(
                  color: palette.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Stats
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _StatRow(
                      'Lessons completed',
                      '${chapter?.lessons.length ?? 0}',
                    ),
                    const Divider(height: 24),
                    _StatRow(
                      'Concepts learned',
                      '${(chapter?.lessons.length ?? 0) * 3}',
                    ),
                    const Divider(height: 24),
                    _StatRow(
                      'Time spent',
                      '~${(chapter?.lessons.length ?? 0) * 3} min',
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => context.go('/learn'),
                  child: const Text('Continue to Next Chapter'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => context.push('/test/create'),
                  child: const Text('Take a Quick Test'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        Text(value, style: AppTypography.numericMedium),
      ],
    );
  }
}
