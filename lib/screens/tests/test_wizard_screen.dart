import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../../models/test_model.dart';

class TestWizardScreen extends ConsumerStatefulWidget {
  const TestWizardScreen({super.key});

  @override
  ConsumerState<TestWizardScreen> createState() => _TestWizardScreenState();
}

class _TestWizardScreenState extends ConsumerState<TestWizardScreen> {
  int _step = 0;
  String? _selectedSubjectId;
  String? _selectedChapterId;
  TestDifficulty _difficulty = TestDifficulty.standard;
  AnswerMode _answerMode = AnswerMode.onPhone;
  QuestionStyle _questionStyle = QuestionStyle.mixed;

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(effectiveLevelProvider).palette;
    final subjects = ref.watch(enrolledSubjectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Create Test', style: AppTypography.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: List.generate(5, (i) {
                return Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: i <= _step ? palette.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: _buildStep(subjects, palette),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text('Back'),
                      ),
                    ),
                  ),
                if (_step > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _canAdvance()
                          ? () {
                              if (_step < 4) {
                                setState(() => _step++);
                              } else {
                                // Generate test → navigate to preview/take
                                if (_answerMode == AnswerMode.onPhone) {
                                  context.go('/test/take/mock-test-1');
                                } else {
                                  context.go('/test/upload');
                                }
                              }
                            }
                          : null,
                      child: Text(_step == 4 ? 'Generate Test' : 'Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _canAdvance() {
    switch (_step) {
      case 0:
        return _selectedSubjectId != null;
      case 1:
        return _selectedChapterId != null;
      default:
        return true;
    }
  }

  Widget _buildStep(List subjects, LevelPalette palette) {
    switch (_step) {
      case 0:
        return _StepSubject(
          subjects: subjects,
          selectedId: _selectedSubjectId,
          onSelect: (id) => setState(() {
            _selectedSubjectId = id;
            _selectedChapterId = null;
          }),
        );
      case 1:
        final subject = subjects.firstWhere(
          (s) => s.id == _selectedSubjectId,
          orElse: () => subjects.first,
        );
        return _StepChapter(
          chapters: subject.chapters,
          selectedId: _selectedChapterId,
          onSelect: (id) => setState(() => _selectedChapterId = id),
          palette: palette,
        );
      case 2:
        return _StepDifficulty(
          selected: _difficulty,
          onSelect: (d) => setState(() => _difficulty = d),
          palette: palette,
        );
      case 3:
        return _StepAnswerMode(
          selected: _answerMode,
          onSelect: (m) => setState(() => _answerMode = m),
          palette: palette,
        );
      case 4:
        return _StepQuestionStyle(
          selected: _questionStyle,
          onSelect: (s) => setState(() => _questionStyle = s),
          palette: palette,
        );
      default:
        return const SizedBox();
    }
  }
}

class _StepSubject extends StatelessWidget {
  final List subjects;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  const _StepSubject({
    required this.subjects,
    this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Subject', style: AppTypography.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Which subject do you want to test?',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView.separated(
            itemCount: subjects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final s = subjects[i];
              final sel = s.id == selectedId;
              return _OptionTile(
                icon: s.icon,
                color: s.color,
                title: s.name,
                subtitle: s.shortDescription,
                isSelected: sel,
                onTap: () => onSelect(s.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StepChapter extends StatelessWidget {
  final List chapters;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final LevelPalette palette;
  const _StepChapter({
    required this.chapters,
    this.selectedId,
    required this.onSelect,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Chapter', style: AppTypography.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Choose a topic to generate questions from',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView.separated(
            itemCount: chapters.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final ch = chapters[i];
              final sel = ch.id == selectedId;
              return _OptionTile(
                icon: Icons.book_rounded,
                color: palette.primary,
                title: ch.title,
                subtitle: ch.description,
                isSelected: sel,
                onTap: () => onSelect(ch.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StepDifficulty extends StatelessWidget {
  final TestDifficulty selected;
  final ValueChanged<TestDifficulty> onSelect;
  final LevelPalette palette;
  const _StepDifficulty({
    required this.selected,
    required this.onSelect,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Difficulty Level', style: AppTypography.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'How challenging should the test be?',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ...TestDifficulty.values.map(
          (d) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OptionTile(
              icon: d == TestDifficulty.basic
                  ? Icons.star_outline_rounded
                  : d == TestDifficulty.standard
                  ? Icons.star_half_rounded
                  : Icons.star_rounded,
              color: palette.primary,
              title: d.label,
              subtitle: d.description,
              isSelected: d == selected,
              onTap: () => onSelect(d),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepAnswerMode extends StatelessWidget {
  final AnswerMode selected;
  final ValueChanged<AnswerMode> onSelect;
  final LevelPalette palette;
  const _StepAnswerMode({
    required this.selected,
    required this.onSelect,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Answer Mode', style: AppTypography.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'How will you answer?',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ...AnswerMode.values.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OptionTile(
              icon: m == AnswerMode.onPhone
                  ? Icons.phone_android_rounded
                  : Icons.description_rounded,
              color: palette.primary,
              title: m.label,
              subtitle: m.description,
              isSelected: m == selected,
              onTap: () => onSelect(m),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepQuestionStyle extends StatelessWidget {
  final QuestionStyle selected;
  final ValueChanged<QuestionStyle> onSelect;
  final LevelPalette palette;
  const _StepQuestionStyle({
    required this.selected,
    required this.onSelect,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Question Style', style: AppTypography.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'What type of questions?',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ...QuestionStyle.values.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OptionTile(
              icon: Icons.format_list_bulleted_rounded,
              color: palette.primary,
              title: s.label,
              subtitle: s.description,
              isSelected: s == selected,
              onTap: () => onSelect(s),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  const _OptionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}
