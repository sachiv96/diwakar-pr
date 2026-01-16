import 'package:flutter/foundation.dart';
import '../models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  ExtendedUserProfile? _currentProfile;
  bool _isLoading = false;

  ExtendedUserProfile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;

  // Dummy badges
  final List<UserBadge> _allBadges = [
    UserBadge(
      id: 'b1',
      name: 'First Steps',
      description: 'Complete your first quiz',
      emoji: '🎯',
      type: BadgeType.quiz,
      rarity: BadgeRarity.common,
      earnedAt: DateTime.now().subtract(const Duration(days: 30)),
      xpReward: 50,
    ),
    UserBadge(
      id: 'b2',
      name: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      emoji: '🔥',
      type: BadgeType.streak,
      rarity: BadgeRarity.rare,
      earnedAt: DateTime.now().subtract(const Duration(days: 20)),
      xpReward: 200,
    ),
    UserBadge(
      id: 'b3',
      name: 'Quiz Master',
      description: 'Score 100% on 5 quizzes',
      emoji: '🏆',
      type: BadgeType.quiz,
      rarity: BadgeRarity.epic,
      earnedAt: DateTime.now().subtract(const Duration(days: 10)),
      xpReward: 500,
    ),
    UserBadge(
      id: 'b4',
      name: 'Course Completer',
      description: 'Finish your first course',
      emoji: '📚',
      type: BadgeType.course,
      rarity: BadgeRarity.common,
      earnedAt: DateTime.now().subtract(const Duration(days: 25)),
      xpReward: 100,
    ),
    UserBadge(
      id: 'b5',
      name: 'Top 100',
      description: 'Reach top 100 national rank',
      emoji: '🥇',
      type: BadgeType.rank,
      rarity: BadgeRarity.legendary,
      earnedAt: DateTime.now().subtract(const Duration(days: 5)),
      xpReward: 1000,
    ),
    UserBadge(
      id: 'b6',
      name: 'Social Butterfly',
      description: 'Join 5 communities',
      emoji: '🦋',
      type: BadgeType.social,
      rarity: BadgeRarity.rare,
      earnedAt: DateTime.now().subtract(const Duration(days: 15)),
      xpReward: 150,
    ),
    UserBadge(
      id: 'b7',
      name: 'Early Bird',
      description: 'Complete 10 activities before 8 AM',
      emoji: '🌅',
      type: BadgeType.special,
      rarity: BadgeRarity.rare,
      earnedAt: DateTime.now().subtract(const Duration(days: 8)),
      xpReward: 200,
    ),
    UserBadge(
      id: 'b8',
      name: 'Month Master',
      description: 'Maintain a 30-day streak',
      emoji: '⚡',
      type: BadgeType.streak,
      rarity: BadgeRarity.epic,
      earnedAt: DateTime.now().subtract(const Duration(days: 2)),
      xpReward: 750,
    ),
  ];

  // Dummy activities
  final List<UserActivity> _recentActivities = [
    UserActivity(
      id: 'a1',
      title: 'Completed DSA Basics Quiz',
      description: 'Scored 95% and earned 150 XP',
      type: 'quiz',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      xpEarned: 150,
    ),
    UserActivity(
      id: 'a2',
      title: 'Earned "Week Warrior" Badge',
      description: 'Maintained 7-day learning streak',
      type: 'achievement',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      xpEarned: 200,
    ),
    UserActivity(
      id: 'a3',
      title: 'Completed Flutter Basics Course',
      description: 'Finished all 24 lessons',
      type: 'course',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      xpEarned: 500,
    ),
    UserActivity(
      id: 'a4',
      title: 'Ranked up to #45 National',
      description: 'Moved up 12 positions',
      type: 'rank',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      xpEarned: 100,
    ),
    UserActivity(
      id: 'a5',
      title: 'Created a post',
      description: 'Shared tips on interview prep',
      type: 'post',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      xpEarned: 25,
    ),
    UserActivity(
      id: 'a6',
      title: '15-day streak! 🔥',
      description: 'Keep going strong!',
      type: 'streak',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      xpEarned: 150,
    ),
  ];

  ExtendedUserProfile getDummyProfile() {
    return ExtendedUserProfile(
      id: 'user1',
      name: 'Diwakar Kumar',
      email: 'diwakar@example.com',
      avatarUrl: null,
      bio:
          'Full Stack Developer | DSA Enthusiast | Building cool stuff with Flutter & React',
      institution: 'IIT Delhi',
      degree: 'B.Tech Computer Science',
      graduationYear: '2026',
      location: 'Delhi, India',
      skills: [
        'Flutter',
        'React',
        'Node.js',
        'Python',
        'DSA',
        'System Design',
        'Firebase',
        'AWS'
      ],
      interests: [
        'Mobile Development',
        'AI/ML',
        'Open Source',
        'Competitive Programming'
      ],
      socialLinks: [
        SocialLink(
            platform: 'GitHub',
            url: 'https://github.com/diwakar',
            username: 'diwakar'),
        SocialLink(
            platform: 'LinkedIn',
            url: 'https://linkedin.com/in/diwakar',
            username: 'diwakar'),
        SocialLink(
            platform: 'LeetCode',
            url: 'https://leetcode.com/diwakar',
            username: 'diwakar'),
        SocialLink(
            platform: 'Twitter',
            url: 'https://twitter.com/diwakar',
            username: '@diwakar'),
      ],
      stats: UserStats(
        totalXP: 12580,
        currentStreak: 15,
        longestStreak: 32,
        quizzesCompleted: 47,
        coursesCompleted: 8,
        lessonsWatched: 156,
        postsCreated: 23,
        communitiesJoined: 6,
        friendsCount: 89,
        totalStudyMinutes: 4560,
        averageQuizScore: 87.5,
      ),
      badges: _allBadges.take(6).toList(),
      recentActivity: _recentActivities,
      nationalRank: 45,
      stateRank: 12,
      zoneRank: 3,
      currentGoal: 'Crack FAANG Interview',
      isVerified: true,
      isPro: true,
      joinedAt: DateTime(2024, 6, 15),
    );
  }

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentProfile = getDummyProfile();
    _isLoading = false;
    notifyListeners();
  }

  List<UserBadge> get allBadges => _allBadges;

  List<UserBadge> getBadgesByType(BadgeType type) {
    return _allBadges.where((b) => b.type == type).toList();
  }

  List<UserBadge> getBadgesByRarity(BadgeRarity rarity) {
    return _allBadges.where((b) => b.rarity == rarity).toList();
  }

  Future<void> updateProfile(ExtendedUserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentProfile = updatedProfile;
    _isLoading = false;
    notifyListeners();
  }

  void updateProfileFields({
    String? name,
    String? bio,
    String? institution,
    String? degree,
    String? graduationYear,
    String? location,
    List<String>? skills,
    List<String>? interests,
    String? currentGoal,
  }) {
    if (_currentProfile == null) return;

    _currentProfile = ExtendedUserProfile(
      id: _currentProfile!.id,
      name: name ?? _currentProfile!.name,
      email: _currentProfile!.email,
      avatarUrl: _currentProfile!.avatarUrl,
      bio: bio ?? _currentProfile!.bio,
      institution: institution ?? _currentProfile!.institution,
      degree: degree ?? _currentProfile!.degree,
      graduationYear: graduationYear ?? _currentProfile!.graduationYear,
      location: location ?? _currentProfile!.location,
      skills: skills ?? _currentProfile!.skills,
      interests: interests ?? _currentProfile!.interests,
      socialLinks: _currentProfile!.socialLinks,
      stats: _currentProfile!.stats,
      badges: _currentProfile!.badges,
      recentActivity: _currentProfile!.recentActivity,
      nationalRank: _currentProfile!.nationalRank,
      stateRank: _currentProfile!.stateRank,
      zoneRank: _currentProfile!.zoneRank,
      currentGoal: currentGoal ?? _currentProfile!.currentGoal,
      isVerified: _currentProfile!.isVerified,
      isPro: _currentProfile!.isPro,
      joinedAt: _currentProfile!.joinedAt,
    );
    notifyListeners();
  }
}
