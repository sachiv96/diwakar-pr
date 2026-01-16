import 'package:cloud_firestore/cloud_firestore.dart';

enum CommunityType {
  studyGroup,
  skillBased,
  college,
  interest,
  mentorship,
  official,
}

enum MemberRole {
  member,
  moderator,
  admin,
  mentor,
}

class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String coverImage;
  final String iconEmoji;
  final CommunityType type;
  final int memberCount;
  final int postCount;
  final bool isPrivate;
  final bool isVerified;
  final List<String> tags;
  final List<String> admins;
  final String? college;
  final bool isJoined;
  final DateTime createdAt;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.iconEmoji,
    required this.type,
    required this.memberCount,
    required this.postCount,
    required this.isPrivate,
    required this.isVerified,
    required this.tags,
    required this.admins,
    this.college,
    this.isJoined = false,
    required this.createdAt,
  });

  String get typeLabel {
    switch (type) {
      case CommunityType.studyGroup:
        return 'Study Group';
      case CommunityType.skillBased:
        return 'Skill Based';
      case CommunityType.college:
        return 'College';
      case CommunityType.interest:
        return 'Interest';
      case CommunityType.mentorship:
        return 'Mentorship';
      case CommunityType.official:
        return 'Official';
    }
  }

  factory CommunityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      coverImage: data['coverImage'] ?? '',
      iconEmoji: data['iconEmoji'] ?? '👥',
      type: CommunityType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => CommunityType.interest,
      ),
      memberCount: data['memberCount'] ?? 0,
      postCount: data['postCount'] ?? 0,
      isPrivate: data['isPrivate'] ?? false,
      isVerified: data['isVerified'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      admins: List<String>.from(data['admins'] ?? []),
      college: data['college'],
      isJoined: data['isJoined'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'coverImage': coverImage,
      'iconEmoji': iconEmoji,
      'type': type.name,
      'memberCount': memberCount,
      'postCount': postCount,
      'isPrivate': isPrivate,
      'isVerified': isVerified,
      'tags': tags,
      'admins': admins,
      'college': college,
      'isJoined': isJoined,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImage,
    String? iconEmoji,
    CommunityType? type,
    int? memberCount,
    int? postCount,
    bool? isPrivate,
    bool? isVerified,
    List<String>? tags,
    List<String>? admins,
    String? college,
    bool? isJoined,
    DateTime? createdAt,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      type: type ?? this.type,
      memberCount: memberCount ?? this.memberCount,
      postCount: postCount ?? this.postCount,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified ?? this.isVerified,
      tags: tags ?? this.tags,
      admins: admins ?? this.admins,
      college: college ?? this.college,
      isJoined: isJoined ?? this.isJoined,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MentorModel {
  final String id;
  final String name;
  final String title;
  final String company;
  final String avatarUrl;
  final String bio;
  final List<String> expertise;
  final double rating;
  final int reviewCount;
  final int sessionsCompleted;
  final int hourlyRate;
  final bool isAvailable;
  final List<String> availableSlots;

  MentorModel({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.avatarUrl,
    required this.bio,
    required this.expertise,
    required this.rating,
    required this.reviewCount,
    required this.sessionsCompleted,
    required this.hourlyRate,
    required this.isAvailable,
    required this.availableSlots,
  });

  factory MentorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MentorModel(
      id: doc.id,
      name: data['name'] ?? '',
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      bio: data['bio'] ?? '',
      expertise: List<String>.from(data['expertise'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      sessionsCompleted: data['sessionsCompleted'] ?? 0,
      hourlyRate: data['hourlyRate'] ?? 0,
      isAvailable: data['isAvailable'] ?? false,
      availableSlots: List<String>.from(data['availableSlots'] ?? []),
    );
  }
}
