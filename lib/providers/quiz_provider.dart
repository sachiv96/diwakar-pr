import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/firestore_service.dart';
import '../services/gemini_service.dart';
import 'package:uuid/uuid.dart';

class QuizProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiService _geminiService = GeminiService();
  final Uuid _uuid = const Uuid();

  List<QuizModel> _quizzes = [];
  List<QuizAttemptModel> _recentAttempts = [];
  QuizModel? _currentQuiz;
  QuizAttemptModel? _currentAttempt;
  bool _isLoading = false;
  String? _error;
  String? _aiFeedback;

  // Quiz attempt state
  int _currentQuestionIndex = 0;
  Map<String, int> _selectedAnswers = {};
  int _timeRemaining = 0;
  bool _isQuizActive = false;

  List<QuizModel> get quizzes => _quizzes;
  List<QuizAttemptModel> get recentAttempts => _recentAttempts;
  QuizModel? get currentQuiz => _currentQuiz;
  QuizAttemptModel? get currentAttempt => _currentAttempt;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get aiFeedback => _aiFeedback;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<String, int> get selectedAnswers => _selectedAnswers;
  int get timeRemaining => _timeRemaining;
  bool get isQuizActive => _isQuizActive;

  QuestionModel? get currentQuestion {
    if (_currentQuiz != null &&
        _currentQuestionIndex < _currentQuiz!.questions.length) {
      return _currentQuiz!.questions[_currentQuestionIndex];
    }
    return null;
  }

  void listenToQuizzes() {
    _firestoreService.getAvailableQuizzes().listen((quizzes) {
      _quizzes = quizzes;
      notifyListeners();
    });
  }

  Future<void> fetchQuiz(String quizId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentQuiz = await _firestoreService.getQuiz(quizId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void startQuiz() {
    if (_currentQuiz != null) {
      _currentQuestionIndex = 0;
      _selectedAnswers = {};
      _timeRemaining = _currentQuiz!.duration * 60; // Convert to seconds
      _isQuizActive = true;
      notifyListeners();
    }
  }

  void selectAnswer(String questionId, int optionIndex) {
    _selectedAnswers[questionId] = optionIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuiz != null &&
        _currentQuestionIndex < _currentQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (_currentQuiz != null &&
        index >= 0 &&
        index < _currentQuiz!.questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void updateTimeRemaining(int seconds) {
    _timeRemaining = seconds;
    notifyListeners();
  }

  Future<QuizAttemptModel?> submitQuiz(String userId) async {
    if (_currentQuiz == null) return null;

    try {
      _isLoading = true;
      _isQuizActive = false;
      notifyListeners();

      // Calculate results
      int correctAnswers = 0;
      List<AnswerModel> answers = [];
      List<String> wrongTopics = [];

      for (var question in _currentQuiz!.questions) {
        final selectedIndex = _selectedAnswers[question.id] ?? -1;
        final isCorrect = question.isCorrect(selectedIndex);

        if (isCorrect) {
          correctAnswers++;
        } else {
          wrongTopics.add(question.question);
        }

        answers.add(AnswerModel(
          questionId: question.id,
          selectedOptionIndex: selectedIndex,
          isCorrect: isCorrect,
        ));
      }

      final score = correctAnswers * 10 + 50; // Points calculation
      final timeTaken = (_currentQuiz!.duration * 60) - _timeRemaining;

      _currentAttempt = QuizAttemptModel(
        id: _uuid.v4(),
        quizId: _currentQuiz!.id,
        userId: userId,
        score: score,
        totalQuestions: _currentQuiz!.questions.length,
        correctAnswers: correctAnswers,
        timeTaken: timeTaken,
        answers: answers,
        attemptedAt: DateTime.now(),
        quizTitle: _currentQuiz!.title,
      );

      // Save to Firestore
      await _firestoreService.saveQuizAttempt(_currentAttempt!);

      // Add to recent attempts
      _recentAttempts.insert(0, _currentAttempt!);
      if (_recentAttempts.length > 10) {
        _recentAttempts = _recentAttempts.take(10).toList();
      }

      // Get AI feedback
      _aiFeedback = await _geminiService.getQuizFeedback(
        topic: _currentQuiz!.title,
        score: correctAnswers,
        totalQuestions: _currentQuiz!.questions.length,
        wrongTopics: wrongTopics.take(3).toList(),
      );

      _isLoading = false;
      notifyListeners();
      return _currentAttempt;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> generateAIQuiz({
    required String topic,
    int numberOfQuestions = 10,
    String difficulty = 'Medium',
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final questions = await _geminiService.generateQuizQuestions(
        topic: topic,
        numberOfQuestions: numberOfQuestions,
        difficulty: difficulty,
      );

      _isLoading = false;
      notifyListeners();
      return questions;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  void resetQuiz() {
    _currentQuiz = null;
    _currentAttempt = null;
    _currentQuestionIndex = 0;
    _selectedAnswers = {};
    _timeRemaining = 0;
    _isQuizActive = false;
    _aiFeedback = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
