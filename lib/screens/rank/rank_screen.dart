import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_avatar.dart';
import '../../widgets/common/loading_widget.dart';
import '../profile/profile_info_sheet.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _selectedTabIndex = _tabController.index);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    context.read<UserProvider>().fetchNationalLeaderboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final currentUser = context.watch<AuthProvider>().user;

    return RefreshIndicator(
      onRefresh: () async {
        switch (_selectedTabIndex) {
          case 0:
            await userProvider.fetchNationalLeaderboard();
            break;
          case 1:
            await userProvider.fetchStateLeaderboard(currentUser?.state ?? '');
            break;
          case 2:
            await userProvider.fetchZoneLeaderboard(currentUser?.zone ?? '');
            break;
        }
      },
      child: CustomScrollView(
        slivers: [
          // Tab bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondaryLight,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                onTap: (index) {
                  switch (index) {
                    case 0:
                      userProvider.fetchNationalLeaderboard();
                      break;
                    case 1:
                      userProvider
                          .fetchStateLeaderboard(currentUser?.state ?? '');
                      break;
                    case 2:
                      userProvider
                          .fetchZoneLeaderboard(currentUser?.zone ?? '');
                      break;
                  }
                },
                tabs: const [
                  Tab(text: 'National'),
                  Tab(text: 'State'),
                  Tab(text: 'Zone'),
                ],
              ),
            ),
          ),

          // Top 3 Podium
          SliverToBoxAdapter(
            child: _buildTopThreePodium(_getLeaderboardForTab(userProvider)),
          ),

          // Your Rank Card
          if (currentUser != null)
            SliverToBoxAdapter(
              child: _buildYourRankCard(currentUser),
            ),

          // Rankings header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rankings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showRewardsInfo(context),
                    icon: const Icon(Icons.emoji_events, size: 18),
                    label: const Text('Rewards'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Leaderboard list
          _buildLeaderboardList(
            _getLeaderboardForTab(userProvider),
            userProvider.isLoading,
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  List<UserModel> _getLeaderboardForTab(UserProvider provider) {
    switch (_selectedTabIndex) {
      case 0:
        return provider.nationalLeaderboard;
      case 1:
        return provider.stateLeaderboard;
      case 2:
        return provider.zoneLeaderboard;
      default:
        return provider.nationalLeaderboard;
    }
  }

  Widget _buildTopThreePodium(List<UserModel> users) {
    if (users.length < 3) {
      return const SizedBox(height: 200);
    }

    final first = users[0];
    final second = users[1];
    final third = users[2];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            '🏆 Top Performers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPodiumItem(
                  user: second,
                  rank: 2,
                  medal: '🥈',
                  color: const Color(0xFFC0C0C0),
                  height: 70),
              const SizedBox(width: 12),
              _buildPodiumItem(
                  user: first,
                  rank: 1,
                  medal: '🥇',
                  color: const Color(0xFFFFD700),
                  height: 90),
              const SizedBox(width: 12),
              _buildPodiumItem(
                  user: third,
                  rank: 3,
                  medal: '🥉',
                  color: const Color(0xFFCD7F32),
                  height: 55),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem({
    required UserModel user,
    required int rank,
    required String medal,
    required Color color,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => _showUserProfile(user),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(medal, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
            ),
            child: CustomAvatar(
                imageUrl: user.avatarUrl,
                name: user.name,
                size: rank == 1 ? 65 : 55),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              user.name.split(' ').first,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text('${user.points} XP',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: 70,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Center(
              child: Text('#$rank',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(UserModel user) {
    final currentUserId = context.read<AuthProvider>().user?.id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileInfoSheet(
        user: user,
        isOwnProfile: user.id == currentUserId, // Check if viewing own profile
      ),
    );
  }

  Widget _buildYourRankCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  user.nationalRank > 0 ? '#${user.nationalRank}' : '--',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              if (user.rankChange != 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      user.rankChange > 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: user.rankChange > 0
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      size: 14,
                    ),
                    Text(
                      '${user.rankChange.abs()}',
                      style: TextStyle(
                        color: user.rankChange > 0
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(width: 16),
          CustomAvatar(imageUrl: user.avatarUrl, name: user.name, size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${user.points} XP',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('+${user.pointsToday}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text('today',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<UserModel> users, bool isLoading) {
    if (isLoading) {
      return const SliverFillRemaining(
          child: LoadingWidget(message: 'Loading leaderboard...'));
    }

    if (users.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyStateWidget(
            icon: Icons.leaderboard,
            title: 'No Rankings Yet',
            subtitle: 'Be the first to claim the top spot!'),
      );
    }

    final restOfUsers = users.length > 3 ? users.sublist(3) : <UserModel>[];

    if (restOfUsers.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(
                child: Text('More rankings coming soon!',
                    style: TextStyle(color: Colors.grey)))),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final user = restOfUsers[index];
          final rank = index + 4;
          return _buildRankCard(user, rank);
        },
        childCount: restOfUsers.length,
      ),
    );
  }

  Widget _buildRankCard(UserModel user, int rank) {
    return GestureDetector(
      onTap: () => _showUserProfile(user),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text('#$rank',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryLight,
                          fontSize: 14))),
            ),
            const SizedBox(width: 12),
            CustomAvatar(imageUrl: user.avatarUrl, name: user.name, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(user.institution,
                      style: TextStyle(
                          color: AppColors.textSecondaryLight, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (user.rankChange != 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: user.rankChange > 0
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        user.rankChange > 0
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 12,
                        color: user.rankChange > 0 ? Colors.green : Colors.red),
                    Text('${user.rankChange.abs()}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: user.rankChange > 0
                                ? Colors.green
                                : Colors.red)),
                  ],
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${user.points}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary)),
                Text('XP',
                    style: TextStyle(
                        color: AppColors.textSecondaryLight, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRewardsInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RewardsInfoSheet(),
    );
  }
}

// Rewards Info Bottom Sheet
class RewardsInfoSheet extends StatelessWidget {
  const RewardsInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Text('Leaderboard Rewards',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Climb the ranks and unlock amazing rewards!',
                      style: TextStyle(
                          color: AppColors.textSecondaryLight, fontSize: 14)),
                  const SizedBox(height: 24),
                  _buildRewardTier(
                    rank: 'Top 10',
                    rewards: [
                      _RewardItem(
                          Icons.workspace_premium,
                          'Premium Badge',
                          'Exclusive Gold badge on your profile',
                          const Color(0xFFFFD700)),
                      _RewardItem(Icons.star, '1000 Bonus XP',
                          'Added to your monthly score', AppColors.primary),
                      _RewardItem(
                          Icons.school,
                          'Free Premium Course',
                          'Choose any course worth up to ₹4,999',
                          AppColors.secondary),
                    ],
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                  ),
                  const SizedBox(height: 16),
                  _buildRewardTier(
                    rank: 'Top 50',
                    rewards: [
                      _RewardItem(
                          Icons.verified,
                          'Silver Badge',
                          'Special Silver badge for top performers',
                          const Color(0xFFC0C0C0)),
                      _RewardItem(Icons.bolt, '500 Bonus XP',
                          'Monthly bonus points', AppColors.primary),
                    ],
                    gradient: const LinearGradient(
                        colors: [Color(0xFFC0C0C0), Color(0xFF9CA3AF)]),
                  ),
                  const SizedBox(height: 16),
                  _buildRewardTier(
                    rank: 'Top 100',
                    rewards: [
                      _RewardItem(
                          Icons.emoji_events,
                          'Bronze Badge',
                          'Recognition badge for excellence',
                          const Color(0xFFCD7F32)),
                      _RewardItem(Icons.discount, '30% Course Discount',
                          'On any premium course', AppColors.info),
                    ],
                    gradient: const LinearGradient(
                        colors: [Color(0xFFCD7F32), Color(0xFFA0522D)]),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.lightbulb, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('How to Earn XP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimaryLight))
                        ]),
                        const SizedBox(height: 12),
                        _buildXPMethod('Complete quizzes', '+50-150 XP'),
                        _buildXPMethod('Finish course modules', '+30 XP'),
                        _buildXPMethod('Daily login streak', '+10 XP/day'),
                        _buildXPMethod('Top 10% quiz score', '+50 XP bonus'),
                        _buildXPMethod('Course completion', '+100 XP'),
                        _buildXPMethod('Help others (Q&A)', '+20 XP'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.warning),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(
                                'Rankings reset monthly. Rewards are distributed at the end of each month.',
                                style: TextStyle(
                                    color: AppColors.textSecondaryLight,
                                    fontSize: 13))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRewardTier(
      {required String rank,
      required List<_RewardItem> rewards,
      required Gradient gradient}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                gradient: gradient,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15))),
            child: Row(children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(rank,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18))
            ]),
          ),
          ...rewards.map((reward) => Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: reward.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            Icon(reward.icon, color: reward.color, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reward.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(reward.description,
                              style: TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontSize: 12))
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildXPMethod(String method, String xp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 16),
            const SizedBox(width: 8),
            Text(method, style: const TextStyle(fontSize: 13))
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
            child: Text(xp,
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _RewardItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  _RewardItem(this.icon, this.title, this.description, this.color);
}
