import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageRole {
  user,
  assistant,
  system,
}

enum AIFeatureType {
  chat,
  resumeBuilder,
  mockInterview,
  codeReview,
  careerAdvice,
}

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isLoading = false,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      content: data['content'] ?? '',
      role: MessageRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => MessageRole.user,
      ),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'role': role.name,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class ChatSession {
  final String id;
  final String title;
  final AIFeatureType type;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.type,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  String get typeLabel {
    switch (type) {
      case AIFeatureType.chat:
        return 'General Chat';
      case AIFeatureType.resumeBuilder:
        return 'Resume Builder';
      case AIFeatureType.mockInterview:
        return 'Mock Interview';
      case AIFeatureType.codeReview:
        return 'Code Review';
      case AIFeatureType.careerAdvice:
        return 'Career Advice';
    }
  }

  String get typeEmoji {
    switch (type) {
      case AIFeatureType.chat:
        return '💬';
      case AIFeatureType.resumeBuilder:
        return '📄';
      case AIFeatureType.mockInterview:
        return '🎤';
      case AIFeatureType.codeReview:
        return '💻';
      case AIFeatureType.careerAdvice:
        return '🎯';
    }
  }
}

class AIFeature {
  final AIFeatureType type;
  final String title;
  final String description;
  final String emoji;
  final bool isPro;
  final List<String> suggestions;

  AIFeature({
    required this.type,
    required this.title,
    required this.description,
    required this.emoji,
    this.isPro = false,
    required this.suggestions,
  });
}

class MockInterviewQuestion {
  final String id;
  final String question;
  final String category;
  final String difficulty;
  final String? hint;
  final String? sampleAnswer;

  MockInterviewQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty,
    this.hint,
    this.sampleAnswer,
  });
}
