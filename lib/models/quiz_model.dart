import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int duration; // in minutes
  final List<QuestionModel> questions;
  final int participantsCount;
  final DateTime scheduledDate;
  final bool isActive;
  final String? imageUrl;
  final DateTime createdAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficulty = 'Medium',
    this.duration = 30,
    required this.questions,
    this.participantsCount = 0,
    required this.scheduledDate,
    this.isActive = true,
    this.imageUrl,
    required this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      duration: json['duration'] ?? 30,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      participantsCount: json['participantsCount'] ?? 0,
      scheduledDate:
          (json['scheduledDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'duration': duration,
      'questions': questions.map((q) => q.toJson()).toList(),
      'participantsCount': participantsCount,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'isActive': isActive,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  int get questionCount => questions.length;
}

class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;
  final int timeLimit; // in seconds

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
    this.timeLimit = 60,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correctOptionIndex'] ?? 0,
      explanation: json['explanation'],
      timeLimit: json['timeLimit'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'timeLimit': timeLimit,
    };
  }

  bool isCorrect(int selectedIndex) => selectedIndex == correctOptionIndex;
}

class QuizAttemptModel {
  final String id;
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeTaken; // in seconds
  final List<AnswerModel> answers;
  final DateTime attemptedAt;
  final String? quizTitle;
  final int? rank;

  QuizAttemptModel({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.answers,
    required this.attemptedAt,
    this.quizTitle,
    this.rank,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      id: json['id'] ?? '',
      quizId: json['quizId'] ?? '',
      userId: json['userId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      timeTaken: json['timeTaken'] ?? 0,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => AnswerModel.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      attemptedAt:
          (json['attemptedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      quizTitle: json['quizTitle'],
      rank: json['rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeTaken': timeTaken,
      'answers': answers.map((a) => a.toJson()).toList(),
      'attemptedAt': Timestamp.fromDate(attemptedAt),
      'quizTitle': quizTitle,
      'rank': rank,
    };
  }

  double get percentage => (correctAnswers / totalQuestions) * 100;
}

class AnswerModel {
  final String questionId;
  final int selectedOptionIndex;
  final bool isCorrect;

  AnswerModel({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.isCorrect,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      questionId: json['questionId'] ?? '',
      selectedOptionIndex: json['selectedOptionIndex'] ?? -1,
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOptionIndex': selectedOptionIndex,
      'isCorrect': isCorrect,
    };
  }
}
