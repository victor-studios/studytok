/// Test model for AI-generated tests.
class TestModel {
  final String id;
  final String subjectId;
  final String subjectName;
  final String chapterId;
  final String chapterName;
  final String topicName;
  final TestDifficulty difficulty;
  final AnswerMode answerMode;
  final QuestionStyle questionStyle;
  final int questionCount;
  final Duration estimatedDuration;
  final List<Question> questions;
  final DateTime createdAt;
  final TestStatus status;

  const TestModel({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.chapterName,
    required this.topicName,
    required this.difficulty,
    required this.answerMode,
    required this.questionStyle,
    required this.questionCount,
    required this.estimatedDuration,
    this.questions = const [],
    required this.createdAt,
    this.status = TestStatus.ready,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'],
      subjectId: json['subject_id'],
      subjectName: json['subject_name'] ?? '',
      chapterId: json['chapter_id'],
      chapterName: json['chapter_name'] ?? '',
      topicName: json['topic_name'] ?? '',
      difficulty: TestDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => TestDifficulty.standard,
      ),
      answerMode: AnswerMode.values.firstWhere(
        (e) => e.name == json['answer_mode'],
        orElse: () => AnswerMode.onPhone,
      ),
      questionStyle: QuestionStyle.values.firstWhere(
        (e) => e.name == json['question_style'],
        orElse: () => QuestionStyle.mixed,
      ),
      questionCount: json['question_count'] ?? 0,
      estimatedDuration: Duration(minutes: json['estimated_duration_mins'] ?? 15),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      status: TestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TestStatus.ready,
      ),
      // Questions serialization skipped for brevity in mock transition
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'chapter_id': chapterId,
      'chapter_name': chapterName,
      'topic_name': topicName,
      'difficulty': difficulty.name,
      'answer_mode': answerMode.name,
      'question_style': questionStyle.name,
      'question_count': questionCount,
      'estimated_duration_mins': estimatedDuration.inMinutes,
      'created_at': createdAt.toUtc().toIso8601String(),
      'status': status.name,
    };
  }
}

enum TestDifficulty {
  basic('Basic', 'Foundation-level questions'),
  standard('Standard', 'Curriculum-aligned questions'),
  challenge('Challenge', 'Advanced problem-solving');

  final String label;
  final String description;
  const TestDifficulty(this.label, this.description);
}

enum AnswerMode {
  onPhone('Answer on Phone', 'Type answers directly in the app'),
  onPaper('Answer on Paper', 'Write on paper and upload for AI checking');

  final String label;
  final String description;
  const AnswerMode(this.label, this.description);
}

enum QuestionStyle {
  mcq('Multiple Choice', 'Select the correct answer'),
  shortAnswer('Short Answer', 'Write a brief response'),
  mixed('Mixed', 'Variety of question types'),
  problemSolving('Problem Solving', 'Structured response questions');

  final String label;
  final String description;
  const QuestionStyle(this.label, this.description);
}

enum TestStatus { ready, inProgress, submitted, processing, completed }

/// A single question in a test.
class Question {
  final String id;
  final int number;
  final String questionText;
  final QuestionType type;
  final List<String>? options;
  final String? correctAnswer;
  final String? explanation;
  final String? studentAnswer;
  final bool? isCorrect;
  final double? score;

  const Question({
    required this.id,
    required this.number,
    required this.questionText,
    required this.type,
    this.options,
    this.correctAnswer,
    this.explanation,
    this.studentAnswer,
    this.isCorrect,
    this.score,
  });
}

enum QuestionType { multipleChoice, shortAnswer, numeric, structured }

/// Test result model.
class TestResult {
  final String id;
  final String testId;
  final double overallScore;
  final String gradeBand;
  final int correctCount;
  final int totalCount;
  final Duration timeTaken;
  final List<Question> answeredQuestions;
  final List<String> weakTopics;
  final List<String> strongTopics;
  final String? aiFeedbackSummary;
  final List<String>? uploadedPageUrls;
  final DateTime completedAt;

  const TestResult({
    required this.id,
    required this.testId,
    required this.overallScore,
    required this.gradeBand,
    required this.correctCount,
    required this.totalCount,
    required this.timeTaken,
    this.answeredQuestions = const [],
    this.weakTopics = const [],
    this.strongTopics = const [],
    this.aiFeedbackSummary,
    this.uploadedPageUrls,
    required this.completedAt,
  });
}
