import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/custom_button.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? _selectedGoal;

  final List<GoalOption> _goals = [
    GoalOption(
      id: 'learn',
      icon: '📚',
      title: 'Learn New Skills',
      subtitle: 'Courses, tutorials',
    ),
    GoalOption(
      id: 'jobs',
      icon: '💼',
      title: 'Find Internships/Jobs',
      subtitle: 'Opportunities',
    ),
    GoalOption(
      id: 'compete',
      icon: '🏆',
      title: 'Compete & Rank',
      subtitle: 'Quizzes, leaderboard',
    ),
    GoalOption(
      id: 'connect',
      icon: '👥',
      title: 'Connect with Peers',
      subtitle: 'Network, study groups',
    ),
    GoalOption(
      id: 'all',
      icon: '🎯',
      title: 'All of the above',
      subtitle: 'Everything KonneqtED offers',
    ),
  ];

  void _selectGoal(String goalId) {
    setState(() {
      _selectedGoal = goalId;
    });
  }

  void _continue() {
    if (_selectedGoal != null) {
      // TODO: Save goal to user profile/preferences
      Navigator.pushReplacementNamed(context, AppRoutes.interestSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Title
              Text(
                'What brings you to',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                  height: 1.2,
                ),
              ),
              Text(
                'KonneqtED?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your primary goal',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),

              // Goal options
              Expanded(
                child: ListView.separated(
                  itemCount: _goals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSelected = _selectedGoal == goal.id;
                    return _buildGoalCard(goal, isSelected);
                  },
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: CustomButton(
                  text: 'Continue',
                  onPressed: _selectedGoal != null ? _continue : null,
                  width: double.infinity,
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(GoalOption goal, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectGoal(goal.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  goal.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    goal.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class GoalOption {
  final String id;
  final String icon;
  final String title;
  final String subtitle;

  GoalOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
