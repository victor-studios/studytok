import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../core/constants/radii.dart';
import '../../providers/app_providers.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/data_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Logo
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.play_lesson_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'Welcome back',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Sign in to continue your learning journey',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Social login buttons
              _SocialButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Continue with Google',
                backgroundColor: AppColors.surface,
                textColor: AppColors.primaryText,
                borderColor: AppColors.border,
                onTap: () => _signInWithGoogle(context, ref),
              ),
              const SizedBox(height: AppSpacing.sm),

              _SocialButton(
                icon: Icons.apple_rounded,
                label: 'Continue with Apple',
                backgroundColor: AppColors.primaryText,
                textColor: Colors.white,
                onTap: () => _mockLogin(context, ref),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'or',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Email field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email address',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.mutedText,
                    size: 20,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Phone field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColors.mutedText,
                    size: 20,
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Continue button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () => _mockLogin(context, ref),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Returning student
              Center(
                child: TextButton(
                  onPressed: () => _mockLogin(context, ref),
                  child: Text(
                    'Continue as returning student',
                    style: AppTypography.bodySmallMedium.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Terms
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithGoogle();
      
      final user = authRepo.currentUser;
      if (user != null) {
         final dataRepo = ref.read(dataRepositoryProvider);
         final profile = await dataRepo.getStudentProfile(user.id);
         
         if (context.mounted) {
           ref.read(isAuthenticatedProvider.notifier).state = true;
           if (profile != null) {
             // Returning user
             await ref.read(appStateControllerProvider).fetchActiveProfile();
             if (context.mounted) context.go('/learn');
           } else {
             // New user needs setup
             context.go('/setup/tier');
           }
         }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _mockLogin(BuildContext context, WidgetRef ref) {
    ref.read(isAuthenticatedProvider.notifier).state = true;
    context.go('/setup/tier');
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor ?? Colors.transparent, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.buttonSmall),
          ],
        ),
      ),
    );
  }
}
