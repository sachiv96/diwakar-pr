import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/post_provider.dart';
import '../../widgets/common/custom_avatar.dart';
import '../../widgets/cards/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _feedTabController;

  @override
  void initState() {
    super.initState();
    _feedTabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTopStudents();
    });
  }

  @override
  void dispose() {
    _feedTabController.dispose();
    super.dispose();
  }

  Future<void> _loadTopStudents() async {
    if (!mounted) return;
    await context.read<UserProvider>().fetchTopStudents(forceRefresh: false);
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    await context.read<UserProvider>().fetchTopStudents(forceRefresh: true);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return '☀️';
    } else if (hour >= 12 && hour < 17) {
      return '🌤️';
    } else {
      return '🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final postProvider = context.watch<PostProvider>();
    final currentUser = authProvider.user;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await _refreshData();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Greeting Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreeting()}, ${currentUser?.name.split(' ').first ?? 'User'}! ${_getGreetingEmoji()}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ready to learn something new?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.1,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Actions Section
              SliverToBoxAdapter(
                child: _buildQuickActions(context),
              ),

              // Streak Progress Section
              SliverToBoxAdapter(
                child: _buildStreakProgress(currentUser),
              ),

              // Top Performers Section
              SliverToBoxAdapter(
                child: _buildTopPerformers(userProvider, currentUser),
              ),

              // Feed Tabs
              SliverToBoxAdapter(
                child: _buildFeedTabs(),
              ),

              // Posts List
              _buildPostsList(postProvider, currentUser),

              // Bottom padding for FAB and nav bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
        // FAB
        Positioned(
          bottom: 80,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createPost);
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickActionItem(
                icon: Icons.quiz,
                label: 'Daily\nQuiz',
                color: AppColors.primary,
                onTap: () {
                  // Navigate to Quiz tab
                  // Will be handled by parent MainScreen
                },
              ),
              _buildQuickActionItem(
                icon: Icons.play_circle_filled,
                label: 'Resume\nCourse',
                color: AppColors.secondary,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.learn);
                },
              ),
              _buildQuickActionItem(
                icon: Icons.work,
                label: 'New\nJobs',
                color: AppColors.warning,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.opportunities);
                },
              ),
              _buildQuickActionItem(
                icon: Icons.smart_toy,
                label: 'Ask\nAI',
                color: AppColors.success,
                isPro: true,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('AI Assistant coming soon! 🤖'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isPro = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              if (isPro)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakProgress(dynamic currentUser) {
    // TODO: Add streak field to UserModel when implementing streak tracking
    final streakDays =
        5; // Placeholder value until streak tracking is implemented
    final targetDays = 30;
    final progress = (streakDays / targetDays).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withOpacity(0.08),
            AppColors.warning.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Your Streak: $streakDays days',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Text(
                '$streakDays/$targetDays',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.warning.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers(UserProvider userProvider, dynamic currentUser) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏆 Top Students',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Top 3 row
                SizedBox(
                  height: 130,
                  child: userProvider.isLoadingTopStudents
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : userProvider.topStudents.isEmpty
                          ? Center(
                              child: Text(
                                'No top students yet',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (userProvider.topStudents.length > 1)
                                  _buildTopStudentItem(
                                    userProvider.topStudents[1],
                                    2,
                                    '🥈',
                                  ),
                                if (userProvider.topStudents.isNotEmpty)
                                  _buildTopStudentItem(
                                    userProvider.topStudents[0],
                                    1,
                                    '🥇',
                                    isFirst: true,
                                  ),
                                if (userProvider.topStudents.length > 2)
                                  _buildTopStudentItem(
                                    userProvider.topStudents[2],
                                    3,
                                    '🥉',
                                  ),
                              ],
                            ),
                ),
                const SizedBox(height: 12),
                // Current user rank
                if (currentUser != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Rank: #${currentUser.nationalRank > 0 ? currentUser.nationalRank : '-'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const Text(
                          '+3 today ↑',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStudentItem(
    dynamic student,
    int rank,
    String medal, {
    bool isFirst = false,
  }) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(medal, style: TextStyle(fontSize: isFirst ? 24 : 18)),
          const SizedBox(height: 4),
          CustomAvatar(
            imageUrl: student.avatarUrl,
            name: student.name,
            size: isFirst ? 50 : 40,
          ),
          const SizedBox(height: 4),
          Text(
            student.name.split(' ').first,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isFirst ? FontWeight.w600 : FontWeight.w500,
              color: Colors.grey.shade800,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          Text(
            '${student.points} pts',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTabs() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feed',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _feedTabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondaryLight,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.all(4),
              tabs: const [
                Tab(text: 'For You'),
                Tab(text: 'Following'),
                Tab(text: 'Trending'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(PostProvider postProvider, dynamic currentUser) {
    if (postProvider.posts.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 56,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Be the first to share something!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final post = postProvider.posts[index];
            return PostCard(
              post: post,
              currentUserId: currentUser?.id ?? '',
              onLike: () {
                postProvider.toggleLike(post.id, currentUser?.id ?? '');
              },
              onComment: () {
                // Navigate to post detail
                Navigator.pushNamed(
                  context,
                  AppRoutes.postDetail,
                  arguments: post.id,
                );
              },
              onShare: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share feature coming soon!')),
                );
              },
              onProfileTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.profile,
                  arguments: post.authorId,
                );
              },
              onMoreTap: () {
                _showPostOptions(
                  context,
                  post,
                  currentUser?.id ?? '',
                  postProvider,
                );
              },
            );
          },
          childCount: postProvider.posts.length,
        ),
      ),
    );
  }

  void _showPostOptions(
    BuildContext context,
    dynamic post,
    String currentUserId,
    PostProvider postProvider,
  ) {
    final isOwnPost = post.authorId == currentUserId;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (isOwnPost) ...[
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit Post'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to edit post screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Edit feature coming soon!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete Post',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDeletePost(context, post.id, postProvider);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.bookmark_outline),
                  title: const Text('Save Post'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post saved!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('Follow User'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Following user!')),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.flag_outlined, color: Colors.orange),
                  title: const Text('Report Post',
                      style: TextStyle(color: Colors.orange)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post reported!')),
                    );
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Copy Link'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard!')),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeletePost(
    BuildContext context,
    String postId,
    PostProvider postProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
            'Are you sure you want to delete this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await postProvider.deletePost(postId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Post deleted successfully!'
                          : 'Failed to delete post',
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
