import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String instructor;
  final String? instructorAvatar;
  final String? instructorTitle; // e.g., "SDE-3 @ Google"
  final String? thumbnailUrl;
  final String? previewVideoUrl;
  final double rating;
  final int reviewsCount;
  final int enrolledCount;
  final double price;
  final double? originalPrice; // For showing discount
  final int? discountPercent;
  final DateTime? saleEndDate; // For sale countdown
  final bool isPremium;
  final String duration; // duration as string like "10h 30m"
  final List<ModuleModel> modules;
  final List<String> skills;
  final List<String> whatYouLearn; // What's included points
  final List<CourseReview> reviews;
  final String level;
  final String difficulty;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.instructor,
    this.instructorAvatar,
    this.instructorTitle,
    this.thumbnailUrl,
    this.previewVideoUrl,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.enrolledCount = 0,
    this.price = 0.0,
    this.originalPrice,
    this.discountPercent,
    this.saleEndDate,
    this.isPremium = false,
    this.duration = '0h',
    required this.modules,
    this.skills = const [],
    this.whatYouLearn = const [],
    this.reviews = const [],
    this.level = 'Beginner',
    this.difficulty = 'Beginner',
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOnSale =>
      saleEndDate != null && saleEndDate!.isAfter(DateTime.now());

  double get effectivePrice =>
      isOnSale && originalPrice != null ? price : price;

  double get displayOriginalPrice => originalPrice ?? (price * 2.5);

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      instructor: json['instructor'] ?? '',
      instructorAvatar: json['instructorAvatar'],
      instructorTitle: json['instructorTitle'],
      thumbnailUrl: json['thumbnailUrl'],
      previewVideoUrl: json['previewVideoUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      enrolledCount: json['enrolledCount'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      discountPercent: json['discountPercent'],
      saleEndDate: (json['saleEndDate'] as Timestamp?)?.toDate(),
      isPremium: json['isPremium'] ?? false,
      duration: json['duration']?.toString() ?? '0h',
      modules: (json['modules'] as List<dynamic>?)
              ?.map((m) => ModuleModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      skills: List<String>.from(json['skills'] ?? []),
      whatYouLearn: List<String>.from(json['whatYouLearn'] ?? []),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((r) => CourseReview.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      level: json['level'] ?? 'Beginner',
      difficulty: json['difficulty'] ?? json['level'] ?? 'Beginner',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'instructor': instructor,
      'instructorAvatar': instructorAvatar,
      'instructorTitle': instructorTitle,
      'thumbnailUrl': thumbnailUrl,
      'previewVideoUrl': previewVideoUrl,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'enrolledCount': enrolledCount,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercent': discountPercent,
      'saleEndDate':
          saleEndDate != null ? Timestamp.fromDate(saleEndDate!) : null,
      'isPremium': isPremium,
      'duration': duration,
      'modules': modules.map((m) => m.toJson()).toList(),
      'skills': skills,
      'whatYouLearn': whatYouLearn,
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'level': level,
      'difficulty': difficulty,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  int get totalLessons =>
      modules.fold(0, (sum, module) => sum + module.lessons.length);
}

class CourseReview {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  CourseReview({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory CourseReview.fromJson(Map<String, dynamic> json) {
    return CourseReview(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Anonymous',
      userAvatar: json['userAvatar'],
      rating: (json['rating'] ?? 5.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ModuleModel {
  final String id;
  final String title;
  final String description;
  final int order;
  final List<LessonModel> lessons;
  final bool isLocked;

  ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.lessons,
    this.isLocked = false,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((l) => LessonModel.fromJson(l as Map<String, dynamic>))
              .toList() ??
          [],
      isLocked: json['isLocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'isLocked': isLocked,
    };
  }

  int get duration => lessons.fold(0, (sum, lesson) => sum + lesson.duration);
}

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String type; // video, article, quiz
  final String? videoUrl;
  final String? articleContent;
  final int duration; // in minutes
  final int order;
  final bool isPreview;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.videoUrl,
    this.articleContent,
    this.duration = 0,
    required this.order,
    this.isPreview = false,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'video',
      videoUrl: json['videoUrl'],
      articleContent: json['articleContent'],
      duration: json['duration'] ?? 0,
      order: json['order'] ?? 0,
      isPreview: json['isPreview'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'videoUrl': videoUrl,
      'articleContent': articleContent,
      'duration': duration,
      'order': order,
      'isPreview': isPreview,
    };
  }
}

class UserCourseProgress {
  final String courseId;
  final String userId;
  final List<String> completedLessons;
  final int progressPercent;
  final DateTime startedAt;
  final DateTime? completedAt;

  UserCourseProgress({
    required this.courseId,
    required this.userId,
    required this.completedLessons,
    required this.progressPercent,
    required this.startedAt,
    this.completedAt,
  });

  int get progressPercentage => progressPercent;
  bool get isCompleted => progressPercent >= 100 || completedAt != null;

  factory UserCourseProgress.fromJson(Map<String, dynamic> json) {
    return UserCourseProgress(
      courseId: json['courseId'] ?? '',
      userId: json['userId'] ?? '',
      completedLessons: List<String>.from(json['completedLessons'] ?? []),
      progressPercent: json['progressPercent'] ?? 0,
      startedAt: (json['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'userId': userId,
      'completedLessons': completedLessons,
      'progressPercent': progressPercent,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }
}
