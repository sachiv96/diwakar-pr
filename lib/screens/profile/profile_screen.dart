import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_avatar.dart';
import '../../widgets/common/loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user?.id == widget.userId) {
      setState(() {
        _user = authProvider.user;
        _isLoading = false;
      });
    } else {
      await context.read<UserProvider>().fetchUser(widget.userId);
      if (!mounted) return;
      final userProvider = context.read<UserProvider>();
      setState(() {
        _user = userProvider.topStudents.firstWhere(
          (u) => u.id == widget.userId,
          orElse: () => authProvider.user!,
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isOwnProfile = authProvider.user?.id == widget.userId;
    final user = _user;

    if (_isLoading || user == null) {
      return const Scaffold(
        body: LoadingWidget(message: 'Loading profile...'),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (isOwnProfile)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.settings, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                      decoration:
                          BoxDecoration(gradient: AppColors.primaryGradient)),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        CustomAvatar(
                            imageUrl: user.avatarUrl,
                            name: user.name,
                            size: 100),
                        const SizedBox(height: 12),
                        Text(user.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(user.institution,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                        if (user.bio != null && user.bio!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(user.bio!,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              'Total Points',
                              '${user.points}',
                              Icons.stars,
                              AppColors.warning)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(
                              'National Rank',
                              '#${user.nationalRank}',
                              Icons.leaderboard,
                              AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              'Quizzes',
                              '${user.completedQuizzes.length}',
                              Icons.quiz,
                              AppColors.secondary)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(
                              'Courses',
                              '${user.completedCourses.length}',
                              Icons.school,
                              AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (!isOwnProfile) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person_add),
                            label: const Text('Add Friend'),
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.message),
                            label: const Text('Message'),
                            style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (user.skills.isNotEmpty) ...[
                    const Text('Skills',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.skills
                          .map((skill) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(skill,
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text('Rankings',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildRankingCard('National', user.nationalRank),
                  const SizedBox(height: 8),
                  _buildRankingCard('State', user.stateRank),
                  const SizedBox(height: 8),
                  _buildRankingCard('Zone', user.zoneRank),
                  const SizedBox(height: 24),
                  if (isOwnProfile)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                  'Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.error),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && mounted) {
                            await authProvider.signOut();
                            if (mounted)
                              Navigator.pushNamedAndRemoveUntil(
                                  context, AppRoutes.login, (route) => false);
                          }
                        },
                        icon: Icon(Icons.logout, color: AppColors.error),
                        label: Text('Logout',
                            style: TextStyle(color: AppColors.error)),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: AppColors.error)),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style:
                  TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }

  Widget _buildRankingCard(String type, int rank) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text('#$rank',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$type Rank',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text('Out of 10,000+ students',
                    style: TextStyle(
                        color: AppColors.textSecondaryLight, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondaryLight),
        ],
      ),
    );
  }
}
