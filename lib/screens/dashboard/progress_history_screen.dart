import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';

class ProgressHistoryScreen extends StatelessWidget {
  const ProgressHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Progress History')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level tabs
            Row(
              children: [
                _Tab('Current', true, palette.primary),
                const SizedBox(width: 8),
                _Tab('Previous', false, palette.primary),
                const SizedBox(width: 8),
                _Tab('All Time', false, palette.primary),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    'Chapters',
                    '12',
                    Icons.book_rounded,
                    palette.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryCard(
                    'Lessons',
                    '48',
                    Icons.play_circle_rounded,
                    AppColors.info,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryCard(
                    'Tests',
                    '6',
                    Icons.quiz_rounded,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('Score Trends', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 160,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: CustomPaint(
                size: const Size(double.infinity, 120),
                painter: _TrendPainter(palette.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('Strongest Topics', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            _TopicBar('Geometry', 0.92, AppColors.success),
            _TopicBar('Algebra', 0.85, AppColors.success),
            _TopicBar('Number Systems', 0.78, palette.primary),
            const SizedBox(height: AppSpacing.xl),

            Text('Weakest Topics', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            _TopicBar('Statistics', 0.45, AppColors.error),
            _TopicBar('Measurement', 0.52, AppColors.warning),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;
  const _Tab(this.label, this.isActive, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? color : AppColors.border),
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge.copyWith(
          color: isActive ? Colors.white : AppColors.secondaryText,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _SummaryCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.numericMedium.copyWith(color: color),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicBar extends StatelessWidget {
  final String topic;
  final double percent;
  final Color color;
  const _TopicBar(this.topic, this.percent, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(topic, style: AppTypography.bodySmall),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percent * 100).toInt()}%',
            style: AppTypography.labelLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final Color color;
  _TrendPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final points = [0.6, 0.5, 0.7, 0.65, 0.8, 0.75, 0.85];
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height * (1 - points[i]);
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
