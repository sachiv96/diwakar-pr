import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// User Goal Model
class UserGoal {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final int currentValue;
  final int targetValue;
  final String unit;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  final List<GoalMilestone> milestones;

  const UserGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.milestones = const [],
  });

  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
  bool get isOverdue => DateTime.now().isAfter(endDate) && !isCompleted;
}

/// Goal Milestone Model
class GoalMilestone {
  final String title;
  final int targetValue;
  final bool isAchieved;
  final String? reward;

  const GoalMilestone({
    required this.title,
    required this.targetValue,
    this.isAchieved = false,
    this.reward,
  });
}

/// Goals Screen - Personal Goals Tracking
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Learning',
    'Quiz',
    'Social',
    'Daily'
  ];

  // Mock data for goals
  final List<UserGoal> _goals = [
    UserGoal(
      id: '1',
      title: 'Complete 100 Quizzes',
      description: 'Master your knowledge by completing quizzes',
      category: 'Quiz',
      icon: Icons.quiz,
      color: const Color(0xFF4CAF50),
      currentValue: 67,
      targetValue: 100,
      unit: 'quizzes',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      milestones: [
        const GoalMilestone(
          title: 'Beginner',
          targetValue: 25,
          isAchieved: true,
          reward: '50 XP',
        ),
        const GoalMilestone(
          title: 'Intermediate',
          targetValue: 50,
          isAchieved: true,
          reward: '100 XP',
        ),
        const GoalMilestone(
          title: 'Expert',
          targetValue: 75,
          isAchieved: false,
          reward: '150 XP',
        ),
        const GoalMilestone(
          title: 'Master',
          targetValue: 100,
          isAchieved: false,
          reward: '300 XP + Badge',
        ),
      ],
    ),
    UserGoal(
      id: '2',
      title: 'Study 50 Hours',
      description: 'Dedicate time to learning',
      category: 'Learning',
      icon: Icons.schedule,
      color: const Color(0xFF2196F3),
      currentValue: 32,
      targetValue: 50,
      unit: 'hours',
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      endDate: DateTime.now().add(const Duration(days: 40)),
      milestones: [
        const GoalMilestone(
          title: '10 Hours',
          targetValue: 10,
          isAchieved: true,
          reward: '25 XP',
        ),
        const GoalMilestone(
          title: '25 Hours',
          targetValue: 25,
          isAchieved: true,
          reward: '50 XP',
        ),
        const GoalMilestone(
          title: '50 Hours',
          targetValue: 50,
          isAchieved: false,
          reward: '200 XP + Badge',
        ),
      ],
    ),
    UserGoal(
      id: '3',
      title: 'Reach Top 100 Rank',
      description: 'Climb the leaderboard',
      category: 'Social',
      icon: Icons.emoji_events,
      color: const Color(0xFFFFB300),
      currentValue: 156,
      targetValue: 100,
      unit: 'rank',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 45)),
    ),
    UserGoal(
      id: '4',
      title: 'Daily Streak: 30 Days',
      description: 'Keep your streak alive!',
      category: 'Daily',
      icon: Icons.local_fire_department,
      color: const Color(0xFFFF5722),
      currentValue: 12,
      targetValue: 30,
      unit: 'days',
      startDate: DateTime.now().subtract(const Duration(days: 12)),
      endDate: DateTime.now().add(const Duration(days: 18)),
    ),
    UserGoal(
      id: '5',
      title: 'Make 20 Friends',
      description: 'Connect with other learners',
      category: 'Social',
      icon: Icons.people,
      color: const Color(0xFF9C27B0),
      currentValue: 15,
      targetValue: 20,
      unit: 'friends',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
    ),
    UserGoal(
      id: '6',
      title: 'Complete 5 Courses',
      description: 'Finish complete learning paths',
      category: 'Learning',
      icon: Icons.school,
      color: const Color(0xFF00BCD4),
      currentValue: 3,
      targetValue: 5,
      unit: 'courses',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<UserGoal> _getFilteredGoals(String category) {
    if (category == 'All') return _goals;
    return _goals.where((g) => g.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Goals'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showAddGoalDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Summary
          _buildStatsSummary(),

          // Category Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: _categories.map((c) => Tab(text: c)).toList(),
            ),
          ),

          // Goals List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                final goals = _getFilteredGoals(category);
                if (goals.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    return _buildGoalCard(goals[index]);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    final totalGoals = _goals.length;
    final completedGoals = _goals.where((g) => g.isCompleted).length;
    final activeGoals = _goals.where((g) => !g.isCompleted).length;
    final overdueGoals = _goals.where((g) => g.isOverdue).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', '$totalGoals', Icons.flag),
              _buildStatItem('Active', '$activeGoals', Icons.play_arrow),
              _buildStatItem('Done', '$completedGoals', Icons.check_circle),
              _buildStatItem('Overdue', '$overdueGoals', Icons.warning,
                  color: overdueGoals > 0 ? Colors.orange[300] : Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          // Overall Progress
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(_calculateOverallProgress() * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _calculateOverallProgress(),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  double _calculateOverallProgress() {
    if (_goals.isEmpty) return 0;
    double totalProgress = _goals.fold(0.0, (sum, goal) => sum + goal.progress);
    return totalProgress / _goals.length;
  }

  Widget _buildGoalCard(UserGoal goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _showGoalDetails(goal),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: goal.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(goal.icon, color: goal.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            goal.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(goal),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress Bar
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${goal.currentValue} / ${goal.targetValue} ${goal.unit}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${(goal.progress * 100).round()}%',
                          style: TextStyle(
                            color: goal.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: goal.progress,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  goal.color.withOpacity(0.7),
                                  goal.color,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Milestones preview (if any)
                if (goal.milestones.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: goal.milestones.map((milestone) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: milestone.isAchieved
                                ? goal.color.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: milestone.isAchieved
                                  ? goal.color
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                milestone.isAchieved
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 12,
                                color: milestone.isAchieved
                                    ? goal.color
                                    : Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                milestone.title,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: milestone.isAchieved
                                      ? goal.color
                                      : Colors.grey[600],
                                  fontWeight: milestone.isAchieved
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                // Days remaining
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: goal.isOverdue ? Colors.red : Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      goal.isOverdue
                          ? 'Overdue by ${goal.daysRemaining.abs()} days'
                          : '${goal.daysRemaining} days remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: goal.isOverdue ? Colors.red : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(UserGoal goal) {
    if (goal.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 12, color: Colors.green),
            SizedBox(width: 2),
            Text(
              'Done',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    if (goal.isOverdue) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 12, color: Colors.red),
            SizedBox(width: 2),
            Text(
              'Overdue',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }

    if (goal.progress >= 0.75) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department, size: 12, color: Colors.orange),
            SizedBox(width: 2),
            Text(
              'Almost!',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: goal.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, size: 12, color: goal.color),
          const SizedBox(width: 2),
          Text(
            'Active',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: goal.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Goals Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your first goal to start tracking progress!',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddGoalDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Goal'),
          ),
        ],
      ),
    );
  }

  void _showGoalDetails(UserGoal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: goal.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(goal.icon, color: goal.color, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                goal.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Progress Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Progress',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${(goal.progress * 100).round()}%',
                                style: TextStyle(
                                  color: goal.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: goal.progress,
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(goal.color),
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${goal.currentValue} ${goal.unit}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${goal.targetValue} ${goal.unit}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Milestones
                    if (goal.milestones.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Milestones',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...goal.milestones.map((milestone) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: milestone.isAchieved
                                ? goal.color.withOpacity(0.1)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: milestone.isAchieved
                                  ? goal.color
                                  : Colors.grey[200]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                milestone.isAchieved
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: milestone.isAchieved
                                    ? goal.color
                                    : Colors.grey[400],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      milestone.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: milestone.isAchieved
                                            ? goal.color
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      '${milestone.targetValue} ${goal.unit}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (milestone.reward != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: milestone.isAchieved
                                        ? Colors.green[100]
                                        : Colors.amber[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    milestone.reward!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: milestone.isAchieved
                                          ? Colors.green
                                          : Colors.amber[800],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ],

                    // Timeline Info
                    const SizedBox(height: 24),
                    const Text(
                      'Timeline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimelineItem(
                            'Started',
                            _formatDate(goal.startDate),
                            Icons.play_circle_outline,
                          ),
                        ),
                        Expanded(
                          child: _buildTimelineItem(
                            'Deadline',
                            _formatDate(goal.endDate),
                            Icons.flag_outlined,
                            isOverdue: goal.isOverdue,
                          ),
                        ),
                        Expanded(
                          child: _buildTimelineItem(
                            'Days Left',
                            goal.isOverdue
                                ? '-${goal.daysRemaining.abs()}'
                                : '${goal.daysRemaining}',
                            Icons.schedule,
                            isOverdue: goal.isOverdue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // TODO: Edit goal
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit Goal'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // TODO: Update progress
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Log Progress'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTimelineItem(String label, String value, IconData icon,
      {bool isOverdue = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isOverdue ? Colors.red : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isOverdue ? Colors.red : Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isOverdue ? Colors.red[300] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  void _showAddGoalDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddGoalSheet(),
    );
  }
}

/// Add Goal Bottom Sheet
class _AddGoalSheet extends StatefulWidget {
  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  String _selectedCategory = 'Learning';
  String _selectedUnit = 'quizzes';

  final _categories = ['Learning', 'Quiz', 'Social', 'Daily'];
  final _units = ['quizzes', 'hours', 'courses', 'friends', 'days', 'points'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Create New Goal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Goal Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g., Complete 50 quizzes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),

            const SizedBox(height: 16),

            // Target and Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _targetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Target',
                      hintText: '50',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _units.map((unit) {
                      return DropdownMenuItem(value: unit, child: Text(unit));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedUnit = value);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Create goal
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Goal created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create Goal'),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
