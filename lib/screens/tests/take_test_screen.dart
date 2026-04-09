import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';

class TakeTestScreen extends StatefulWidget {
  final String testId;
  const TakeTestScreen({super.key, required this.testId});

  @override
  State<TakeTestScreen> createState() => _TakeTestScreenState();
}

class _TakeTestScreenState extends State<TakeTestScreen> {
  int _currentQuestion = 0;
  final int _totalQuestions = 8;
  int? _selectedOption;
  final List<int?> _answers = List.filled(8, null);

  final _questions = [
    _MockQuestion('What is the value of x in 2x + 4 = 10?', [
      'x = 2',
      'x = 3',
      'x = 4',
      'x = 6',
    ], 1),
    _MockQuestion('Which of these is a prime number?', [
      '4',
      '9',
      '13',
      '15',
    ], 2),
    _MockQuestion(
      'What is the area of a rectangle with length 5 and width 3?',
      ['8', '12', '15', '20'],
      2,
    ),
    _MockQuestion('Simplify: 3(x + 2) - x', [
      '2x + 6',
      '2x + 2',
      '3x + 6',
      '4x + 2',
    ], 0),
    _MockQuestion('What is 25% of 200?', ['25', '50', '75', '100'], 1),
    _MockQuestion('Which angle is supplementary to 60°?', [
      '30°',
      '90°',
      '120°',
      '180°',
    ], 2),
    _MockQuestion('What is the square root of 144?', [
      '10',
      '11',
      '12',
      '14',
    ], 2),
    _MockQuestion('If y = 3x and x = 4, what is y?', [
      '7',
      '12',
      '16',
      '34',
    ], 1),
  ];

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
    final palette = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Question ${_currentQuestion + 1} of $_totalQuestions'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save Draft',
              style: AppTypography.bodySmallMedium.copyWith(
                color: palette.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentQuestion + 1) / _totalQuestions,
            minHeight: 3,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    q.question,
                    style: AppTypography.titleLarge.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ...q.options.asMap().entries.map((e) {
                    final idx = e.key;
                    final opt = e.value;
                    final isSelected = _selectedOption == idx;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedOption = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? palette.primary.withValues(alpha: 0.08)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? palette.primary
                                  : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? palette.primary
                                      : AppColors.background,
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? null
                                      : Border.all(color: AppColors.border),
                                ),
                                child: Center(
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : Text(
                                          String.fromCharCode(65 + idx),
                                          style: AppTypography.bodySmallMedium,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  opt,
                                  style: AppTypography.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                if (_currentQuestion > 0)
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => setState(() {
                          _currentQuestion--;
                          _selectedOption = _answers[_currentQuestion];
                        }),
                        child: const Text('Previous'),
                      ),
                    ),
                  ),
                if (_currentQuestion > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _selectedOption != null
                          ? () {
                              _answers[_currentQuestion] = _selectedOption;
                              if (_currentQuestion < _totalQuestions - 1) {
                                setState(() {
                                  _currentQuestion++;
                                  _selectedOption = _answers[_currentQuestion];
                                });
                              } else {
                                context.go('/test/results/mock-test-1');
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _totalQuestions - 1
                            ? 'Submit'
                            : 'Next',
                      ),
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
}

class _MockQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  const _MockQuestion(this.question, this.options, this.correctIndex);
}
