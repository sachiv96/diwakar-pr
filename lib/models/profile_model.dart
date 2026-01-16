import 'package:cloud_firestore/cloud_firestore.dart';

enum BadgeType {
  streak,
  quiz,
  course,
  rank,
  social,
  special,
}

enum BadgeRarity {
  common,
  rare,
  epic,
  legendary,
}

class UserBadge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final BadgeType type;
  final BadgeRarity rarity;
  final DateTime? earnedAt;
  final int xpReward;

  UserBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.type,
    required this.rarity,
    this.earnedAt,
    required this.xpReward,
  });

  String get rarityLabel {
    switch (rarity) {
      case BadgeRarity.common:
        return 'Common';
      case BadgeRarity.rare:
        return 'Rare';
      case BadgeRarity.epic:
        return 'Epic';
      case BadgeRarity.legendary:
        return 'Legendary';
    }
  }

  factory UserBadge.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserBadge(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      emoji: data['emoji'] ?? '🏆',
      type: BadgeType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => BadgeType.special,
      ),
      rarity: BadgeRarity.values.firstWhere(
        (e) => e.name == data['rarity'],
        orElse: () => BadgeRarity.common,
      ),
      earnedAt: (data['earnedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      xpReward: data['xpReward'] ?? 0,
    );
  }
}

class UserActivity {
  final String id;
  final String title;
  final String description;
  final String type; // quiz, course, achievement, post, etc.
  final String? relatedId;
  final DateTime timestamp;
  final int? xpEarned;

  UserActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.relatedId,
    required this.timestamp,
    this.xpEarned,
  });

  String get typeEmoji {
    switch (type) {
      case 'quiz':
        return '📝';
      case 'course':
        return '📚';
      case 'achievement':
        return '🏆';
      case 'post':
        return '✍️';
      case 'rank':
        return '🏅';
      case 'streak':
        return '🔥';
      default:
        return '⭐';
    }
  }
}

class UserStats {
  final int totalXP;
  final int currentStreak;
  final int longestStreak;
  final int quizzesCompleted;
  final int coursesCompleted;
  final int lessonsWatched;
  final int postsCreated;
  final int communitiesJoined;
  final int friendsCount;
  final int totalStudyMinutes;
  final double averageQuizScore;

  UserStats({
    required this.totalXP,
    required this.currentStreak,
    required this.longestStreak,
    required this.quizzesCompleted,
    required this.coursesCompleted,
    required this.lessonsWatched,
    required this.postsCreated,
    required this.communitiesJoined,
    required this.friendsCount,
    required this.totalStudyMinutes,
    required this.averageQuizScore,
  });

  String get studyTimeFormatted {
    final hours = totalStudyMinutes ~/ 60;
    final minutes = totalStudyMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class SocialLink {
  final String platform;
  final String url;
  final String? username;

  SocialLink({
    required this.platform,
    required this.url,
    this.username,
  });

  String get icon {
    switch (platform.toLowerCase()) {
      case 'github':
        return '🐙';
      case 'linkedin':
        return '💼';
      case 'twitter':
        return '🐦';
      case 'leetcode':
        return '💻';
      case 'portfolio':
        return '🌐';
      default:
        return '🔗';
    }
  }
}

class ExtendedUserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String institution;
  final String? degree;
  final String? graduationYear;
  final String? location;
  final List<String> skills;
  final List<String> interests;
  final List<SocialLink> socialLinks;
  final UserStats stats;
  final List<UserBadge> badges;
  final List<UserActivity> recentActivity;
  final int nationalRank;
  final int stateRank;
  final int zoneRank;
  final String? currentGoal;
  final bool isVerified;
  final bool isPro;
  final DateTime joinedAt;

  ExtendedUserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    required this.institution,
    this.degree,
    this.graduationYear,
    this.location,
    required this.skills,
    required this.interests,
    required this.socialLinks,
    required this.stats,
    required this.badges,
    required this.recentActivity,
    required this.nationalRank,
    required this.stateRank,
    required this.zoneRank,
    this.currentGoal,
    this.isVerified = false,
    this.isPro = false,
    required this.joinedAt,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  int get level {
    if (stats.totalXP < 1000) return 1;
    if (stats.totalXP < 3000) return 2;
    if (stats.totalXP < 6000) return 3;
    if (stats.totalXP < 10000) return 4;
    if (stats.totalXP < 15000) return 5;
    if (stats.totalXP < 25000) return 6;
    if (stats.totalXP < 40000) return 7;
    if (stats.totalXP < 60000) return 8;
    if (stats.totalXP < 85000) return 9;
    return 10;
  }

  String get levelTitle {
    switch (level) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Learner';
      case 3:
        return 'Explorer';
      case 4:
        return 'Achiever';
      case 5:
        return 'Scholar';
      case 6:
        return 'Expert';
      case 7:
        return 'Master';
      case 8:
        return 'Champion';
      case 9:
        return 'Legend';
      case 10:
        return 'Grandmaster';
      default:
        return 'Beginner';
    }
  }

  double get levelProgress {
    final levelThresholds = [
      0,
      1000,
      3000,
      6000,
      10000,
      15000,
      25000,
      40000,
      60000,
      85000,
      100000
    ];
    final currentLevelXP = levelThresholds[level - 1];
    final nextLevelXP = levelThresholds[level];
    return (stats.totalXP - currentLevelXP) / (nextLevelXP - currentLevelXP);
  }

  ExtendedUserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
    String? institution,
    String? degree,
    int? graduationYear,
    String? location,
    List<String>? skills,
    List<String>? interests,
    List<SocialLink>? socialLinks,
    UserStats? stats,
    List<UserBadge>? badges,
    List<UserActivity>? recentActivity,
    int? nationalRank,
    int? stateRank,
    int? zoneRank,
    String? currentGoal,
    bool? isVerified,
    bool? isPro,
    DateTime? joinedAt,
  }) {
    return ExtendedUserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      graduationYear: graduationYear?.toString() ?? this.graduationYear,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      socialLinks: socialLinks ?? this.socialLinks,
      stats: stats ?? this.stats,
      badges: badges ?? this.badges,
      recentActivity: recentActivity ?? this.recentActivity,
      nationalRank: nationalRank ?? this.nationalRank,
      stateRank: stateRank ?? this.stateRank,
      zoneRank: zoneRank ?? this.zoneRank,
      currentGoal: currentGoal ?? this.currentGoal,
      isVerified: isVerified ?? this.isVerified,
      isPro: isPro ?? this.isPro,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
