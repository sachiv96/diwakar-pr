import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Banner
          _buildQuickStatsBanner(),
          const SizedBox(height: 20),

          Text(
            'Explore',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.work_rounded,
            iconColor: Colors.blue,
            title: 'Opportunities',
            subtitle: '42 new internships this week',
            trailing: _buildCountBadge('12 NEW', Colors.blue),
            onTap: () => Navigator.pushNamed(context, AppRoutes.opportunities),
          ),
          _buildMenuCard(
            context,
            icon: Icons.event_rounded,
            iconColor: Colors.purple,
            title: 'Events',
            subtitle: 'Hackathons & Webinars',
            trailing: _buildCountBadge('3 Live', Colors.red),
            onTap: () => Navigator.pushNamed(context, AppRoutes.events),
          ),
          _buildMenuCard(
            context,
            icon: Icons.groups_rounded,
            iconColor: Colors.teal,
            title: 'Community',
            subtitle: '2.4K members online',
            trailing: _buildOnlineIndicator(),
            onTap: () => Navigator.pushNamed(context, AppRoutes.community),
          ),
          _buildMenuCard(
            context,
            icon: Icons.smart_toy_rounded,
            iconColor: Colors.orange,
            title: 'AI Assistant',
            subtitle: 'Chat, Resume, Mock Interview',
            badge: 'PRO',
            onTap: () => Navigator.pushNamed(context, AppRoutes.aiAssistant),
          ),
          const SizedBox(height: 24),

          // Featured Section
          _buildFeaturedSection(context),
          const SizedBox(height: 24),

          Text(
            'Account',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuCard(
            context,
            icon: Icons.diamond_rounded,
            iconColor: AppColors.primary,
            title: 'Premium',
            subtitle: 'Unlock all features',
            badge: '60% OFF',
            badgeColor: Colors.green,
            onTap: () => Navigator.pushNamed(context, AppRoutes.subscription),
          ),
          _buildMenuCard(
            context,
            icon: Icons.bookmark_rounded,
            iconColor: Colors.amber,
            title: 'My Applications',
            subtitle: '5 applications tracked',
            trailing: _buildApplicationProgress(),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.applicationTracker),
          ),
          _buildMenuCard(
            context,
            icon: Icons.card_giftcard_rounded,
            iconColor: Colors.pink,
            title: 'Rewards',
            subtitle: '150 coins available',
            trailing: _buildCoinsBadge(),
            onTap: () {},
          ),
          _buildMenuCard(
            context,
            icon: Icons.settings_rounded,
            iconColor: Colors.grey,
            title: 'Settings',
            subtitle: 'Preferences & account',
            onTap: () => Navigator.pushNamed(context, AppRoutes.appSettings),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuickStatsBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department,
                  color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              const Text(
                '15 Day Streak!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '1,250 XP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Quizzes', '23', Icons.quiz_rounded),
              _buildStatItem('Courses', '4', Icons.school_rounded),
              _buildStatItem('Rank', '#45', Icons.leaderboard_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade100, Colors.orange.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🎯', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Challenge',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete today\'s quiz for 2x XP!',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      '5h 23m left',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Go',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '2.4K',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationProgress() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMiniDot(Colors.green),
        _buildMiniDot(Colors.orange),
        _buildMiniDot(Colors.blue),
        const SizedBox(width: 8),
        Text(
          '1 Offer',
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildCoinsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '150',
            style: TextStyle(
              color: Colors.amber.shade800,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: badge == 'PRO'
                                    ? AppColors.primaryGradient
                                    : null,
                                color: badge == 'PRO'
                                    ? null
                                    : (badgeColor ?? Colors.amber)
                                        .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: badge == 'PRO'
                                      ? Colors.white
                                      : (badgeColor ?? Colors.amber.shade800),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  trailing,
                  const SizedBox(width: 8),
                ],
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
