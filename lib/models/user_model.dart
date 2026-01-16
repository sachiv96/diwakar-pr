import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? coverUrl;
  final String? title;
  final String? bio;
  final String? location;
  final String institution;
  final String? website;
  final String? linkedin;
  final int points;
  final int nationalRank;
  final int stateRank;
  final int zoneRank;
  final int rankChange; // +3 or -2 from yesterday
  final int pointsToday; // XP earned today
  final int streak; // Current streak days
  final String state;
  final String zone;
  final List<String> friends;
  final List<String> completedQuizzes;
  final List<String> enrolledCourses;
  final List<String> completedCourses;
  final List<String> interests;
  final List<String> skills;
  final List<String> badges; // Achievement badges
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.coverUrl,
    this.title,
    this.bio,
    this.location,
    required this.institution,
    this.website,
    this.linkedin,
    this.points = 0,
    this.nationalRank = 0,
    this.stateRank = 0,
    this.zoneRank = 0,
    this.rankChange = 0,
    this.pointsToday = 0,
    this.streak = 0,
    this.state = '',
    this.zone = '',
    this.friends = const [],
    this.completedQuizzes = const [],
    this.enrolledCourses = const [],
    this.completedCourses = const [],
    this.interests = const [],
    this.skills = const [],
    this.badges = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      title: json['title'],
      bio: json['bio'],
      location: json['location'],
      institution: json['institution'] ?? '',
      website: json['website'],
      linkedin: json['linkedin'],
      points: json['points'] ?? 0,
      nationalRank: json['nationalRank'] ?? 0,
      stateRank: json['stateRank'] ?? 0,
      zoneRank: json['zoneRank'] ?? 0,
      rankChange: json['rankChange'] ?? 0,
      pointsToday: json['pointsToday'] ?? 0,
      streak: json['streak'] ?? 0,
      state: json['state'] ?? '',
      zone: json['zone'] ?? '',
      friends: List<String>.from(json['friends'] ?? []),
      completedQuizzes: List<String>.from(json['completedQuizzes'] ?? []),
      enrolledCourses: List<String>.from(json['enrolledCourses'] ?? []),
      completedCourses: List<String>.from(json['completedCourses'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      badges: List<String>.from(json['badges'] ?? []),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
      'title': title,
      'bio': bio,
      'location': location,
      'institution': institution,
      'website': website,
      'linkedin': linkedin,
      'points': points,
      'nationalRank': nationalRank,
      'stateRank': stateRank,
      'zoneRank': zoneRank,
      'rankChange': rankChange,
      'pointsToday': pointsToday,
      'streak': streak,
      'state': state,
      'zone': zone,
      'friends': friends,
      'completedQuizzes': completedQuizzes,
      'enrolledCourses': enrolledCourses,
      'completedCourses': completedCourses,
      'interests': interests,
      'skills': skills,
      'badges': badges,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? coverUrl,
    String? title,
    String? bio,
    String? location,
    String? institution,
    String? website,
    String? linkedin,
    int? points,
    int? nationalRank,
    int? stateRank,
    int? zoneRank,
    int? rankChange,
    int? pointsToday,
    int? streak,
    String? state,
    String? zone,
    List<String>? friends,
    List<String>? completedQuizzes,
    List<String>? enrolledCourses,
    List<String>? completedCourses,
    List<String>? interests,
    List<String>? skills,
    List<String>? badges,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      institution: institution ?? this.institution,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      points: points ?? this.points,
      nationalRank: nationalRank ?? this.nationalRank,
      stateRank: stateRank ?? this.stateRank,
      zoneRank: zoneRank ?? this.zoneRank,
      rankChange: rankChange ?? this.rankChange,
      pointsToday: pointsToday ?? this.pointsToday,
      streak: streak ?? this.streak,
      state: state ?? this.state,
      zone: zone ?? this.zone,
      friends: friends ?? this.friends,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      completedCourses: completedCourses ?? this.completedCourses,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get rankTitle {
    if (points >= 5000) return 'Legend';
    if (points >= 2500) return 'Master';
    if (points >= 1000) return 'Expert';
    if (points >= 500) return 'Scholar';
    if (points >= 100) return 'Learner';
    return 'Beginner';
  }
}
