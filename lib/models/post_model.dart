import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String? authorTitle;
  final String content;
  final List<String> mediaUrls;
  final List<String> likes;
  final int commentsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    this.authorTitle,
    required this.content,
    this.mediaUrls = const [],
    this.likes = const [],
    this.commentsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorAvatar: json['authorAvatar'],
      authorTitle: json['authorTitle'],
      content: json['content'] ?? '',
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      likes: List<String>.from(json['likes'] ?? []),
      commentsCount: json['commentsCount'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'authorTitle': authorTitle,
      'content': content,
      'mediaUrls': mediaUrls,
      'likes': likes,
      'commentsCount': commentsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  PostModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? authorTitle,
    String? content,
    List<String>? mediaUrls,
    List<String>? likes,
    int? commentsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      authorTitle: authorTitle ?? this.authorTitle,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isLikedBy(String userId) => likes.contains(userId);
  int get likesCount => likes.length;
}

class CommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      postId: json['postId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorAvatar: json['authorAvatar'],
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
