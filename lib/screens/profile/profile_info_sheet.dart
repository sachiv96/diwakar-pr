import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/user_model.dart';
import '../../widgets/common/custom_avatar.dart';

/// Subscription tier enum for feature gating
enum SubscriptionTier { free, pro, elite }

/// Profile theme configuration
class ProfileTheme {
  final String name;
  final List<Color> gradientColors;
  final SubscriptionTier requiredTier;
  final bool isAnimated;

  const ProfileTheme({
    required this.name,
    required this.gradientColors,
    required this.requiredTier,
    this.isAnimated = false,
  });

  // PRO Themes
  static const sunset = ProfileTheme(
    name: 'Sunset',
    gradientColors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  static const ocean = ProfileTheme(
    name: 'Ocean',
    gradientColors: [Color(0xFF667EEA), Color(0xFF64B5F6)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  static const sakura = ProfileTheme(
    name: 'Sakura',
    gradientColors: [Color(0xFFFFB7C5), Color(0xFFFCE4EC)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  static const forest = ProfileTheme(
    name: 'Forest',
    gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  static const mystic = ProfileTheme(
    name: 'Mystic',
    gradientColors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  static const electric = ProfileTheme(
    name: 'Electric',
    gradientColors: [Color(0xFF00D9FF), Color(0xFF00FFA3)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  static const midnight = ProfileTheme(
    name: 'Midnight',
    gradientColors: [Color(0xFF232526), Color(0xFF414345)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  static const gold = ProfileTheme(
    name: 'Gold',
    gradientColors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    requiredTier: SubscriptionTier.pro,
    isAnimated: true,
  );

  // ELITE Themes
  static const rainbow = ProfileTheme(
    name: 'Rainbow',
    gradientColors: [
      Color(0xFFFF0080),
      Color(0xFFFF8C00),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
      Color(0xFF00BFFF),
      Color(0xFF8B00FF),
    ],
    requiredTier: SubscriptionTier.elite,
    isAnimated: true,
  );

  static const diamond = ProfileTheme(
    name: 'Diamond',
    gradientColors: [Color(0xFFE0E0E0), Color(0xFF64B5F6), Color(0xFFFFFFFF)],
    requiredTier: SubscriptionTier.elite,
    isAnimated: true,
  );

  static const inferno = ProfileTheme(
    name: 'Inferno',
    gradientColors: [Color(0xFFFF0000), Color(0xFFFF6600), Color(0xFFFFCC00)],
    requiredTier: SubscriptionTier.elite,
    isAnimated: true,
  );

  // Free default
  static const defaultTheme = ProfileTheme(
    name: 'Default',
    gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    requiredTier: SubscriptionTier.free,
    isAnimated: false,
  );

  static List<ProfileTheme> get allThemes => [
        defaultTheme,
        sunset,
        ocean,
        sakura,
        forest,
        mystic,
        electric,
        midnight,
        gold,
        rainbow,
        diamond,
        inferno,
      ];

  static List<ProfileTheme> get proThemes =>
      allThemes.where((t) => t.requiredTier == SubscriptionTier.pro).toList();

  static List<ProfileTheme> get eliteThemes =>
      allThemes.where((t) => t.requiredTier == SubscriptionTier.elite).toList();
}

/// Profile Info Sheet - Bottom Sheet Quick View (60% screen height)
/// Triggered when user taps on any avatar in the app
class ProfileInfoSheet extends StatefulWidget {
  final UserModel user;
  final bool isOwnProfile;
  final SubscriptionTier subscriptionTier;
  final ProfileTheme? selectedTheme;

  const ProfileInfoSheet({
    super.key,
    required this.user,
    this.isOwnProfile = false,
    this.subscriptionTier = SubscriptionTier.free,
    this.selectedTheme,
  });

  /// Static method to easily show the profile info sheet from anywhere
  static Future<void> show(
    BuildContext context, {
    required UserModel user,
    bool isOwnProfile = false,
    SubscriptionTier subscriptionTier = SubscriptionTier.free,
    ProfileTheme? selectedTheme,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileInfoSheet(
        user: user,
        isOwnProfile: isOwnProfile,
        subscriptionTier: subscriptionTier,
        selectedTheme: selectedTheme,
      ),
    );
  }

  @override
  State<ProfileInfoSheet> createState() => _ProfileInfoSheetState();
}

class _ProfileInfoSheetState extends State<ProfileInfoSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  ProfileTheme get _theme => widget.selectedTheme ?? ProfileTheme.defaultTheme;

  bool get _isPremium =>
      widget.subscriptionTier == SubscriptionTier.pro ||
      widget.subscriptionTier == SubscriptionTier.elite;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (_theme.isAnimated && _isPremium) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6, // Start at 60%
      minChildSize: 0.5, // Can shrink to 50%
      maxChildSize: 0.95, // Can expand to 95% (almost full screen)
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle - stays fixed
              _buildDragHandle(),

              // Everything else scrolls together and expands sheet
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController, // Connected to draggable sheet
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Cover Section with Gradient and Avatar
                      _buildCoverSection(),

                      // Profile Content
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(
                                height: 52), // Space for overlapping avatar
                            // Name
                            Text(
                              widget.user.name.isNotEmpty
                                  ? widget.user.name
                                  : 'Student',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),

                            // Title/Role with decoration
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getUserTitle(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Location - only show if institution is not empty
                            if (widget.user.institution.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 14,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      widget.user.institution,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 20),

                            _buildStatsGrid(),

                            const SizedBox(height: 20),

                            // View Full Profile Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.profile,
                                    arguments: widget.user.id,
                                  );
                                },
                                icon:
                                    const Icon(Icons.person_outline, size: 18),
                                label: const Text('View Full Profile'),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(color: AppColors.primary),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Action Buttons
                            _buildActionButtons(),

                            SizedBox(
                                height:
                                    MediaQuery.of(context).padding.bottom + 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildCoverSection() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Cover Gradient (100px height - more compact)
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _buildGradient(),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            );
          },
        ),

        // Subscription Badge (if premium)
        if (_isPremium)
          Positioned(
            top: 8,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.subscriptionTier == SubscriptionTier.elite
                    ? const Color(0xFFFFD700)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.subscriptionTier == SubscriptionTier.elite
                        ? Icons.diamond
                        : Icons.star,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.subscriptionTier == SubscriptionTier.elite
                        ? 'ELITE'
                        : 'PRO',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Avatar (88px with border, positioned to overlap)
        Positioned(
          bottom: -44,
          child: _buildAvatar(),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: _theme.gradientColors.first.withOpacity(0.3),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _isPremium && _theme.isAnimated
          ? _buildGlowingAvatar()
          : CustomAvatar(
              imageUrl: widget.user.avatarUrl,
              name: widget.user.name,
              size: 76,
            ),
    );
  }

  Widget _buildGlowingAvatar() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _theme.gradientColors[(_animationController.value *
                                _theme.gradientColors.length)
                            .floor() %
                        _theme.gradientColors.length]
                    .withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CustomAvatar(
            imageUrl: widget.user.avatarUrl,
            name: widget.user.name,
            size: 80,
          ),
        );
      },
    );
  }

  Gradient _buildGradient() {
    if (_theme.isAnimated && _isPremium) {
      // Animated gradient
      final colors = _theme.gradientColors;
      final offset = _animationController.value;
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        stops: List.generate(
          colors.length,
          (i) => ((i / colors.length) + offset) % 1.0,
        )..sort(),
        transform: GradientRotation(offset * 2 * math.pi),
      );
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: _theme.gradientColors,
    );
  }

  Widget _buildStatsGrid() {
    // Stats: XP/Level, Rank, Friends (Row 1)
    //        Quizzes, Courses, Badges (Row 2)
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row 1
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.bolt_rounded,
                  iconColor: const Color(0xFFFFB800),
                  iconBgColor: const Color(0xFFFFF8E1),
                  value: '${widget.user.points}',
                  sublabel: 'Level ${_calculateLevel(widget.user.points)}',
                ),
              ),
              _buildDivider(),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.emoji_events_rounded,
                  iconColor: const Color(0xFFFFD700),
                  iconBgColor: const Color(0xFFFFFDE7),
                  value: widget.user.nationalRank > 0
                      ? '#${widget.user.nationalRank}'
                      : '-',
                  sublabel: 'National',
                ),
              ),
              _buildDivider(),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.people_rounded,
                  iconColor: const Color(0xFF4CAF50),
                  iconBgColor: const Color(0xFFE8F5E9),
                  value: '${widget.user.friends.length}',
                  sublabel: 'Connected',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 1,
              color: Colors.grey[100],
            ),
          ),
          // Row 2
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.quiz_rounded,
                  iconColor: const Color(0xFF2196F3),
                  iconBgColor: const Color(0xFFE3F2FD),
                  value: '${widget.user.completedQuizzes.length}',
                  sublabel: 'Completed',
                ),
              ),
              _buildDivider(),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.auto_stories_rounded,
                  iconColor: const Color(0xFF9C27B0),
                  iconBgColor: const Color(0xFFF3E5F5),
                  value: '${widget.user.completedCourses.length}',
                  sublabel: 'Finished',
                ),
              ),
              _buildDivider(),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.military_tech_rounded,
                  iconColor: const Color(0xFFFF5722),
                  iconBgColor: const Color(0xFFFBE9E7),
                  value: '${widget.user.badges.length}',
                  sublabel: 'Earned',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String sublabel,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sublabel,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 56,
      color: Colors.grey[100],
    );
  }

  Widget _buildActionButtons() {
    if (widget.isOwnProfile) {
      // Own profile - show Edit button
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.editProfile);
          },
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Edit Profile'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    // Other user's profile - show Message and Follow buttons
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to chat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat feature coming soon!')),
              );
            },
            icon: const Icon(Icons.message_outlined, size: 18),
            label: const Text('Message'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Follow user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Following ${widget.user.name}')),
              );
            },
            icon: const Icon(Icons.person_add_outlined, size: 18),
            label: const Text('Follow'),
            style: ElevatedButton.styleFrom(
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

  String _getUserTitle() {
    // Use title from user data if available, otherwise show role
    if (widget.user.title != null && widget.user.title!.isNotEmpty) {
      return widget.user.title!;
    }
    return 'Student';
  }

  int _calculateLevel(int points) {
    // Simple level calculation: Level up every 1000 XP
    return (points / 1000).floor() + 1;
  }
}
