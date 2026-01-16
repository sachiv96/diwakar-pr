import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _filters = [
    {'id': 'all', 'label': 'All', 'icon': Icons.grid_view},
    {'id': 'streak', 'label': 'Streak', 'icon': Icons.local_fire_department},
    {'id': 'quiz', 'label': 'Quiz', 'icon': Icons.quiz},
    {'id': 'course', 'label': 'Course', 'icon': Icons.school},
    {'id': 'rank', 'label': 'Rank', 'icon': Icons.leaderboard},
    {'id': 'social', 'label': 'Social', 'icon': Icons.people},
    {'id': 'special', 'label': 'Special', 'icon': Icons.star},
  ];

  // All available badges in the system
  final List<UserBadge> _allBadges = [
    // Streak Badges
    UserBadge(
        id: 'streak_1',
        name: 'First Steps',
        description: 'Complete your first day of learning',
        emoji: '🌟',
        type: BadgeType.streak,
        rarity: BadgeRarity.common,
        xpReward: 50),
    UserBadge(
        id: 'streak_7',
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        emoji: '🔥',
        type: BadgeType.streak,
        rarity: BadgeRarity.common,
        xpReward: 100),
    UserBadge(
        id: 'streak_30',
        name: 'Month Master',
        description: 'Maintain a 30-day streak',
        emoji: '💪',
        type: BadgeType.streak,
        rarity: BadgeRarity.rare,
        xpReward: 500),
    UserBadge(
        id: 'streak_100',
        name: 'Century Club',
        description: 'Maintain a 100-day streak',
        emoji: '💯',
        type: BadgeType.streak,
        rarity: BadgeRarity.epic,
        xpReward: 2000),
    UserBadge(
        id: 'streak_365',
        name: 'Year Champion',
        description: 'Maintain a 365-day streak',
        emoji: '👑',
        type: BadgeType.streak,
        rarity: BadgeRarity.legendary,
        xpReward: 10000),

    // Quiz Badges
    UserBadge(
        id: 'quiz_1',
        name: 'Quiz Starter',
        description: 'Complete your first quiz',
        emoji: '📝',
        type: BadgeType.quiz,
        rarity: BadgeRarity.common,
        xpReward: 25),
    UserBadge(
        id: 'quiz_10',
        name: 'Quiz Enthusiast',
        description: 'Complete 10 quizzes',
        emoji: '📚',
        type: BadgeType.quiz,
        rarity: BadgeRarity.common,
        xpReward: 100),
    UserBadge(
        id: 'quiz_master',
        name: 'Quiz Master',
        description: 'Score 100% in 10 quizzes',
        emoji: '🎯',
        type: BadgeType.quiz,
        rarity: BadgeRarity.rare,
        xpReward: 500),
    UserBadge(
        id: 'quiz_50',
        name: 'Quiz Expert',
        description: 'Complete 50 quizzes',
        emoji: '🧠',
        type: BadgeType.quiz,
        rarity: BadgeRarity.epic,
        xpReward: 1000),
    UserBadge(
        id: 'quiz_legend',
        name: 'Quiz Legend',
        description: 'Complete 100 quizzes with avg 90%+',
        emoji: '🏆',
        type: BadgeType.quiz,
        rarity: BadgeRarity.legendary,
        xpReward: 5000),

    // Course Badges
    UserBadge(
        id: 'course_1',
        name: 'Course Starter',
        description: 'Complete your first course',
        emoji: '📖',
        type: BadgeType.course,
        rarity: BadgeRarity.common,
        xpReward: 100),
    UserBadge(
        id: 'course_5',
        name: 'Course Completer',
        description: 'Complete 5 courses',
        emoji: '🎓',
        type: BadgeType.course,
        rarity: BadgeRarity.rare,
        xpReward: 300),
    UserBadge(
        id: 'course_all_math',
        name: 'Math Wizard',
        description: 'Complete all Math courses',
        emoji: '🔢',
        type: BadgeType.course,
        rarity: BadgeRarity.epic,
        xpReward: 2000),
    UserBadge(
        id: 'course_all_science',
        name: 'Science Sage',
        description: 'Complete all Science courses',
        emoji: '🔬',
        type: BadgeType.course,
        rarity: BadgeRarity.epic,
        xpReward: 2000),
    UserBadge(
        id: 'course_complete',
        name: 'Complete Scholar',
        description: 'Complete 20 courses',
        emoji: '📚',
        type: BadgeType.course,
        rarity: BadgeRarity.legendary,
        xpReward: 5000),

    // Rank Badges
    UserBadge(
        id: 'rank_top_1000',
        name: 'Rising Star',
        description: 'Reach Top 1000 nationally',
        emoji: '⭐',
        type: BadgeType.rank,
        rarity: BadgeRarity.common,
        xpReward: 200),
    UserBadge(
        id: 'rank_top_500',
        name: 'Top Performer',
        description: 'Reach Top 500 nationally',
        emoji: '🌟',
        type: BadgeType.rank,
        rarity: BadgeRarity.rare,
        xpReward: 500),
    UserBadge(
        id: 'rank_top_100',
        name: 'Top 100',
        description: 'Reach Top 100 nationally',
        emoji: '🏅',
        type: BadgeType.rank,
        rarity: BadgeRarity.epic,
        xpReward: 1500),
    UserBadge(
        id: 'rank_top_10',
        name: 'Elite 10',
        description: 'Reach Top 10 nationally',
        emoji: '💎',
        type: BadgeType.rank,
        rarity: BadgeRarity.legendary,
        xpReward: 5000),
    UserBadge(
        id: 'rank_1',
        name: 'National Champion',
        description: 'Reach #1 nationally',
        emoji: '👑',
        type: BadgeType.rank,
        rarity: BadgeRarity.legendary,
        xpReward: 10000),

    // Social Badges
    UserBadge(
        id: 'social_first_friend',
        name: 'First Friend',
        description: 'Add your first friend',
        emoji: '🤝',
        type: BadgeType.social,
        rarity: BadgeRarity.common,
        xpReward: 25),
    UserBadge(
        id: 'social_5_friends',
        name: 'Social Starter',
        description: 'Have 5 friends',
        emoji: '👋',
        type: BadgeType.social,
        rarity: BadgeRarity.common,
        xpReward: 50),
    UserBadge(
        id: 'social_butterfly',
        name: 'Social Butterfly',
        description: 'Have 25 friends',
        emoji: '🦋',
        type: BadgeType.social,
        rarity: BadgeRarity.rare,
        xpReward: 200),
    UserBadge(
        id: 'social_community',
        name: 'Community Leader',
        description: 'Join 5 communities',
        emoji: '👥',
        type: BadgeType.social,
        rarity: BadgeRarity.rare,
        xpReward: 300),
    UserBadge(
        id: 'social_influencer',
        name: 'Influencer',
        description: 'Have 100 friends',
        emoji: '⭐',
        type: BadgeType.social,
        rarity: BadgeRarity.legendary,
        xpReward: 2000),

    // Special Badges
    UserBadge(
        id: 'special_early_bird',
        name: 'Early Bird',
        description: 'Join during beta',
        emoji: '🐣',
        type: BadgeType.special,
        rarity: BadgeRarity.epic,
        xpReward: 1000),
    UserBadge(
        id: 'special_founder',
        name: 'Founder',
        description: 'Among first 1000 users',
        emoji: '🏛️',
        type: BadgeType.special,
        rarity: BadgeRarity.legendary,
        xpReward: 5000),
    UserBadge(
        id: 'special_event',
        name: 'Event Champion',
        description: 'Win a special event',
        emoji: '🎪',
        type: BadgeType.special,
        rarity: BadgeRarity.epic,
        xpReward: 1500),
    UserBadge(
        id: 'special_mentor',
        name: 'Mentor',
        description: 'Help 10 students improve',
        emoji: '🎓',
        type: BadgeType.special,
        rarity: BadgeRarity.epic,
        xpReward: 2000),
    UserBadge(
        id: 'special_perfectionist',
        name: 'Perfectionist',
        description: 'Achieve 100% on everything',
        emoji: '✨',
        type: BadgeType.special,
        rarity: BadgeRarity.legendary,
        xpReward: 10000),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(child: _buildStats(context)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'All Badges'),
                    Tab(text: 'Locked'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildFilterChips(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllBadgesTab(),
                  _buildLockedBadgesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  '🏆',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Achievements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<ProfileProvider>(
                  builder: (context, provider, _) {
                    final earnedCount =
                        provider.currentProfile?.badges.length ?? 0;
                    return Text(
                      '$earnedCount / ${_allBadges.length} badges earned',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final badges = provider.currentProfile?.badges ?? [];
        final commonCount =
            badges.where((b) => b.rarity == BadgeRarity.common).length;
        final rareCount =
            badges.where((b) => b.rarity == BadgeRarity.rare).length;
        final epicCount =
            badges.where((b) => b.rarity == BadgeRarity.epic).length;
        final legendaryCount =
            badges.where((b) => b.rarity == BadgeRarity.legendary).length;

        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatBadge('Common', commonCount, Colors.grey),
              _buildStatBadge('Rare', rareCount, Colors.blue),
              _buildStatBadge('Epic', epicCount, Colors.purple),
              _buildStatBadge('Legendary', legendaryCount, Colors.amber),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filter['icon'],
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(filter['label']),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter['id'];
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAllBadgesTab() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final earnedBadgeIds =
            provider.currentProfile?.badges.map((b) => b.id).toSet() ?? {};

        var filteredBadges = _allBadges;
        if (_selectedFilter != 'all') {
          final type = BadgeType.values.firstWhere(
            (t) => t.name == _selectedFilter,
            orElse: () => BadgeType.streak,
          );
          filteredBadges = filteredBadges.where((b) => b.type == type).toList();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredBadges.length,
          itemBuilder: (context, index) {
            final badge = filteredBadges[index];
            final isEarned = earnedBadgeIds.contains(badge.id);
            return _buildBadgeCard(badge, isEarned);
          },
        );
      },
    );
  }

  Widget _buildLockedBadgesTab() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final earnedBadgeIds =
            provider.currentProfile?.badges.map((b) => b.id).toSet() ?? {};

        var lockedBadges =
            _allBadges.where((b) => !earnedBadgeIds.contains(b.id)).toList();
        if (_selectedFilter != 'all') {
          final type = BadgeType.values.firstWhere(
            (t) => t.name == _selectedFilter,
            orElse: () => BadgeType.streak,
          );
          lockedBadges = lockedBadges.where((b) => b.type == type).toList();
        }

        if (lockedBadges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'All badges earned!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'You\'re a true champion!',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: lockedBadges.length,
          itemBuilder: (context, index) {
            return _buildBadgeCard(lockedBadges[index], false);
          },
        );
      },
    );
  }

  Widget _buildBadgeCard(UserBadge badge, bool isEarned) {
    return GestureDetector(
      onTap: () => _showBadgeDetails(badge, isEarned),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isEarned ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isEarned ? _getRarityColor(badge.rarity) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isEarned
              ? [
                  BoxShadow(
                    color: _getRarityColor(badge.rarity).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 36,
                    color: isEarned ? null : Colors.grey,
                  ),
                ),
                if (!isEarned)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              badge.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isEarned ? Colors.black : Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getRarityColor(badge.rarity)
                    .withOpacity(isEarned ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge.rarityLabel,
                style: TextStyle(
                  color: isEarned ? _getRarityColor(badge.rarity) : Colors.grey,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '+${badge.xpReward} XP',
              style: TextStyle(
                color: isEarned ? Colors.green.shade700 : Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetails(UserBadge badge, bool isEarned) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isEarned
                    ? _getRarityColor(badge.rarity).withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEarned
                      ? _getRarityColor(badge.rarity)
                      : Colors.grey.shade300,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 48,
                    color: isEarned ? null : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  badge.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isEarned) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle, color: Colors.green),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getRarityColor(badge.rarity).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.rarityLabel,
                style: TextStyle(
                  color: _getRarityColor(badge.rarity),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge.description,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stars, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Text(
                    '+${badge.xpReward} XP Reward',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (isEarned && badge.earnedAt != null)
              Text(
                'Earned on ${_formatDate(badge.earnedAt!)}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            if (!isEarned) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Complete the challenge to unlock this badge!',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEarned ? AppColors.primary : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEarned ? 'Share Badge' : 'Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(BadgeRarity rarity) {
    switch (rarity) {
      case BadgeRarity.common:
        return Colors.grey;
      case BadgeRarity.rare:
        return Colors.blue;
      case BadgeRarity.epic:
        return Colors.purple;
      case BadgeRarity.legendary:
        return Colors.amber;
    }
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
