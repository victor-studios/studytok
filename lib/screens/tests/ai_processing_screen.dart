import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});

  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  final _steps = [
    ('Upload received', Icons.cloud_done_rounded),
    ('Reading your answers', Icons.document_scanner_rounded),
    ('Analyzing responses', Icons.psychology_rounded),
    ('Checking accuracy', Icons.fact_check_rounded),
    ('Generating feedback', Icons.auto_awesome_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _runSteps();
  }

  Future<void> _runSteps() async {
    for (var i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) setState(() => _currentStep = i + 1);
    }
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) context.go('/test/results/mock-test-1');
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Pulsing icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.9, end: 1.1),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [palette.primary, palette.secondary],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: palette.primary.withOpacity(0.3),
                        blurRadius: 32,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'AI is checking your work',
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This usually takes a few seconds',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Steps
              ...List.generate(_steps.length, (i) {
                final done = i < _currentStep;
                final active = i == _currentStep;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: done
                              ? palette.primary
                              : active
                              ? palette.primary.withOpacity(0.15)
                              : AppColors.background,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: done || active
                                ? palette.primary
                                : AppColors.border,
                          ),
                        ),
                        child: done
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                            : active
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: palette.primary,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Icon(
                        _steps[i].$2,
                        size: 18,
                        color: done
                            ? palette.primary
                            : active
                            ? AppColors.primaryText
                            : AppColors.mutedText,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _steps[i].$1,
                        style: AppTypography.bodyLarge.copyWith(
                          color: done || active
                              ? AppColors.primaryText
                              : AppColors.mutedText,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
