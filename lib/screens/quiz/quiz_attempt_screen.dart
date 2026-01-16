import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';

class QuizAttemptScreen extends StatefulWidget {
  final String quizId;

  const QuizAttemptScreen({super.key, required this.quizId});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  Timer? _timer;
  final ScrollController _navigatorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final quizProvider = context.read<QuizProvider>();
      if (quizProvider.timeRemaining > 0) {
        quizProvider.updateTimeRemaining(quizProvider.timeRemaining - 1);
      } else {
        _submitQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _navigatorScrollController.dispose();
    super.dispose();
  }

  Future<void> _submitQuiz() async {
    final confirmed = await _showSubmitConfirmation();
    if (confirmed != true) return;

    _timer?.cancel();
    final userId = context.read<AuthProvider>().user?.id ?? '';
    final attempt = await context.read<QuizProvider>().submitQuiz(userId);

    if (attempt != null && mounted) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.quizResult,
        arguments: {
          'quizId': widget.quizId,
          'score': attempt.score,
          'totalQuestions': attempt.totalQuestions,
          'timeTaken': attempt.timeTaken,
        },
      );
    }
  }

  Color _getTimerColor(int timeRemaining) {
    if (timeRemaining < 60) return AppColors.error; // Red at 1 minute
    if (timeRemaining < 300) return AppColors.warning; // Orange at 5 minutes
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final quiz = quizProvider.currentQuiz;
    final question = quizProvider.currentQuestion;

    if (quiz == null || question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final minutes = quizProvider.timeRemaining ~/ 60;
    final seconds = quizProvider.timeRemaining % 60;
    final timerColor = _getTimerColor(quizProvider.timeRemaining);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _showExitConfirmation();
          if (shouldExit == true && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () async {
              final shouldExit = await _showExitConfirmation();
              if (shouldExit == true && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            quiz.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: timerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: timerColor),
                  const SizedBox(width: 4),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: timerColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${quizProvider.currentQuestionIndex + 1} of ${quiz.questionCount}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${((quizProvider.currentQuestionIndex + 1) / quiz.questionCount * 100).round()}%',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (quizProvider.currentQuestionIndex + 1) /
                          quiz.questionCount,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            // Question content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options
                    ...List.generate(
                      question.options.length,
                      (index) => _buildOption(
                        index,
                        question.options[index],
                        quizProvider.selectedAnswers[question.id] == index,
                        () => quizProvider.selectAnswer(question.id, index),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom navigation section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Question navigator
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Question Navigator',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Row(
                                children: [
                                  _buildLegendItem(
                                      '●', 'Answered', AppColors.primary),
                                  const SizedBox(width: 12),
                                  _buildLegendItem(
                                      '○', 'Unanswered', Colors.grey.shade400),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 36,
                            child: ListView.builder(
                              controller: _navigatorScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: quiz.questionCount,
                              itemBuilder: (context, index) {
                                final questionId = quiz.questions[index].id;
                                final isAnswered = quizProvider.selectedAnswers
                                    .containsKey(questionId);
                                final isCurrent =
                                    index == quizProvider.currentQuestionIndex;

                                return GestureDetector(
                                  onTap: () {
                                    quizProvider.goToQuestion(index);
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: isCurrent
                                          ? AppColors.primary
                                          : isAnswered
                                              ? AppColors.primary
                                                  .withOpacity(0.15)
                                              : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isCurrent
                                            ? AppColors.primary
                                            : isAnswered
                                                ? AppColors.primary
                                                : Colors.grey.shade300,
                                        width: isCurrent ? 2 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isCurrent
                                              ? Colors.white
                                              : isAnswered
                                                  ? AppColors.primary
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Navigation buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(
                        children: [
                          if (quizProvider.currentQuestionIndex > 0)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: quizProvider.previousQuestion,
                                icon: const Icon(Icons.arrow_back, size: 18),
                                label: const Text('Prev'),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            )
                          else
                            const Spacer(),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: quizProvider.currentQuestionIndex <
                                      quiz.questionCount - 1
                                  ? quizProvider.nextQuestion
                                  : _submitQuiz,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    quizProvider.currentQuestionIndex <
                                            quiz.questionCount - 1
                                        ? AppColors.primary
                                        : AppColors.success,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    quizProvider.currentQuestionIndex <
                                            quiz.questionCount - 1
                                        ? 'Next'
                                        : 'Submit Quiz',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    quizProvider.currentQuestionIndex <
                                            quiz.questionCount - 1
                                        ? Icons.arrow_forward
                                        : Icons.check_circle_outline,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String symbol, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          symbol,
          style: TextStyle(color: color, fontSize: 12),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
    int index,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final labels = ['A', 'B', 'C', 'D', 'E', 'F'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text('Exit Quiz?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost and you won\'t be able to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showSubmitConfirmation() {
    final quizProvider = context.read<QuizProvider>();
    final quiz = quizProvider.currentQuiz;
    final answeredCount = quizProvider.selectedAnswers.length;
    final totalQuestions = quiz?.questionCount ?? 0;
    final unansweredCount = totalQuestions - answeredCount;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.assignment_turned_in, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Submit Quiz?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have answered $answeredCount out of $totalQuestions questions.',
              style: const TextStyle(fontSize: 15),
            ),
            if (unansweredCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$unansweredCount question${unansweredCount > 1 ? 's' : ''} unanswered',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Review'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
