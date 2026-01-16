import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';

class EnhancedProfileScreen extends StatefulWidget {
  final String userId;

  const EnhancedProfileScreen({super.key, required this.userId});

  @override
  State<EnhancedProfileScreen> createState() => _EnhancedProfileScreenState();
}

class _EnhancedProfileScreenState extends State<EnhancedProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile(widget.userId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isOwnProfile = authProvider.user?.id == widget.userId;

    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..loadProfile(widget.userId),
      child: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading || provider.currentProfile == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text('Loading profile...'),
                  ],
                ),
              ),
            );
          }

          final profile = provider.currentProfile!;

          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverAppBar(context, profile, isOwnProfile),
                  SliverToBoxAdapter(
                    child: _buildProfileHeader(context, profile, isOwnProfile),
                  ),
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
                          Tab(text: 'Overview'),
                          Tab(text: 'Activity'),
                          Tab(text: 'Badges'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(context, profile, isOwnProfile),
                  _buildActivityTab(context, profile),
                  _buildBadgesTab(context, profile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, ExtendedUserProfile profile, bool isOwnProfile) {
    return SliverAppBar(
      expandedHeight: 200,
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
      actions: [
        if (isOwnProfile) ...[
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.settings, color: Colors.white, size: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.appSettings);
            },
          ),
        ] else ...[
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            ),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: Stack(
            children: [
              // Pattern overlay
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: CustomPaint(painter: _PatternPainter()),
                ),
              ),
              // Profile info
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Avatar with level ring
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _getLevelColor(profile.level),
                              width: 4,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: profile.avatarUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    profile.avatarUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  profile.initials,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        // Level badge
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getLevelColor(profile.level),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Lv ${profile.level}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Name with verification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified,
                              color: Colors.white, size: 20),
                        ],
                        if (profile.isPro) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.levelTitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, ExtendedUserProfile profile, bool isOwnProfile) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // XP Progress Bar
          _buildXPProgressBar(profile),
          const SizedBox(height: 20),

          // Quick Stats
          Row(
            children: [
              _buildQuickStat('${profile.stats.totalXP}', 'XP', Icons.stars),
              _buildQuickStat(
                  '#${profile.nationalRank}', 'Rank', Icons.leaderboard),
              _buildQuickStat('${profile.stats.currentStreak}', 'Streak',
                  Icons.local_fire_department),
              _buildQuickStat(
                  '${profile.badges.length}', 'Badges', Icons.military_tech),
            ],
          ),
          const SizedBox(height: 16),

          // Bio
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                profile.bio!,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action Buttons
          if (!isOwnProfile)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Add Friend'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildXPProgressBar(ExtendedUserProfile profile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level ${profile.level} - ${profile.levelTitle}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${(profile.levelProgress * 100).toInt()}%',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: profile.levelProgress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(_getLevelColor(profile.level)),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(
      BuildContext context, ExtendedUserProfile profile, bool isOwnProfile) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current Goal
        if (profile.currentGoal != null) ...[
          _buildSectionCard(
            title: 'Current Goal',
            icon: Icons.flag,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    Colors.transparent
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      profile.currentGoal!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Stats Grid
        _buildSectionCard(
          title: 'Statistics',
          icon: Icons.bar_chart,
          child: Column(
            children: [
              Row(
                children: [
                  _buildStatItem('Quizzes', '${profile.stats.quizzesCompleted}',
                      Icons.quiz),
                  _buildStatItem('Courses', '${profile.stats.coursesCompleted}',
                      Icons.school),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatItem('Study Time', profile.stats.studyTimeFormatted,
                      Icons.timer),
                  _buildStatItem(
                      'Avg Score',
                      '${profile.stats.averageQuizScore.toStringAsFixed(1)}%',
                      Icons.trending_up),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatItem('Communities',
                      '${profile.stats.communitiesJoined}', Icons.groups),
                  _buildStatItem(
                      'Friends', '${profile.stats.friendsCount}', Icons.people),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Skills
        if (profile.skills.isNotEmpty) ...[
          _buildSectionCard(
            title: 'Skills',
            icon: Icons.psychology,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.skills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Rankings
        _buildSectionCard(
          title: 'Rankings',
          icon: Icons.leaderboard,
          child: Column(
            children: [
              _buildRankItem(
                  'National', profile.nationalRank, '10,000+', Colors.amber),
              const SizedBox(height: 10),
              _buildRankItem('State', profile.stateRank, '2,500+', Colors.blue),
              const SizedBox(height: 10),
              _buildRankItem('Zone', profile.zoneRank, '500+', Colors.green),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Social Links
        if (profile.socialLinks.isNotEmpty) ...[
          _buildSectionCard(
            title: 'Connect',
            icon: Icons.link,
            child: Column(
              children: profile.socialLinks.map((link) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child:
                          Text(link.icon, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  title: Text(link.platform),
                  subtitle: Text(link.username ?? link.url,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () {},
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Education
        _buildSectionCard(
          title: 'Education',
          icon: Icons.school,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.institution,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (profile.degree != null) ...[
                const SizedBox(height: 4),
                Text(profile.degree!,
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
              if (profile.graduationYear != null) ...[
                const SizedBox(height: 4),
                Text('Expected ${profile.graduationYear}',
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick Actions for own profile
        if (isOwnProfile) ...[
          _buildSectionCard(
            title: 'Quick Actions',
            icon: Icons.apps,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildQuickActionButton(
                      context,
                      'Goals',
                      Icons.flag,
                      const Color(0xFF4CAF50),
                      () => Navigator.pushNamed(context, AppRoutes.goals),
                    ),
                    const SizedBox(width: 12),
                    _buildQuickActionButton(
                      context,
                      'Analytics',
                      Icons.analytics,
                      const Color(0xFF2196F3),
                      () => Navigator.pushNamed(context, AppRoutes.analytics),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuickActionButton(
                      context,
                      'Friends',
                      Icons.people,
                      const Color(0xFF9C27B0),
                      () => Navigator.pushNamed(context, AppRoutes.friends),
                    ),
                    const SizedBox(width: 12),
                    _buildQuickActionButton(
                      context,
                      'Report Card',
                      Icons.assignment,
                      const Color(0xFFFF9800),
                      () => Navigator.pushNamed(context, AppRoutes.reportCard),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuickActionButton(
                      context,
                      'Themes',
                      Icons.palette,
                      const Color(0xFFE91E63),
                      () => Navigator.pushNamed(
                          context, AppRoutes.themeCustomization),
                    ),
                    const SizedBox(width: 12),
                    _buildQuickActionButton(
                      context,
                      'Achievements',
                      Icons.emoji_events,
                      const Color(0xFFFFB300),
                      () =>
                          Navigator.pushNamed(context, AppRoutes.achievements),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Logout for own profile
        if (isOwnProfile) ...[
          Container(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: Icon(Icons.logout, color: AppColors.error),
              label: Text('Logout', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }

  Widget _buildActivityTab(BuildContext context, ExtendedUserProfile profile) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: profile.recentActivity.length,
      itemBuilder: (context, index) {
        final activity = profile.recentActivity[index];
        return _buildActivityItem(activity);
      },
    );
  }

  Widget _buildActivityItem(UserActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(activity.typeEmoji,
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _formatTimeAgo(activity.timestamp),
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    if (activity.xpEarned != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${activity.xpEarned} XP',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab(BuildContext context, ExtendedUserProfile profile) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Earned Badges
        Text(
          'Earned Badges (${profile.badges.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: profile.badges.length,
          itemBuilder: (context, index) {
            return _buildBadgeCard(profile.badges[index], true);
          },
        ),
        const SizedBox(height: 24),

        // View All Badges Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.achievements);
            },
            icon: const Icon(Icons.military_tech),
            label: const Text('View All Badges'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard(UserBadge badge, bool earned) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: earned ? _getRarityColor(badge.rarity) : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: earned
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
          Text(
            badge.emoji,
            style: TextStyle(
              fontSize: 32,
              color: earned ? null : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: earned ? Colors.black : Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getRarityColor(badge.rarity).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge.rarityLabel,
              style: TextStyle(
                color: _getRarityColor(badge.rarity),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankItem(String type, int rank, String total, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type Rank',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Out of $total students',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Color _getLevelColor(int level) {
    if (level <= 2) return Colors.grey;
    if (level <= 4) return Colors.green;
    if (level <= 6) return Colors.blue;
    if (level <= 8) return Colors.purple;
    return Colors.amber;
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

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.flag, color: Colors.red.shade600),
              title:
                  Text('Report', style: TextStyle(color: Colors.red.shade600)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().signOut();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
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

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    for (var i = 0; i < size.width; i += 20) {
      for (var j = 0; j < size.height; j += 20) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
