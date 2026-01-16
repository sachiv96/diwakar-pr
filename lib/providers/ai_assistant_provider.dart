import 'package:flutter/foundation.dart';
import '../models/ai_assistant_model.dart';

class AIAssistantProvider with ChangeNotifier {
  final List<AIFeature> _features = [
    AIFeature(
      type: AIFeatureType.chat,
      title: 'General Chat',
      description: 'Ask anything about studies, career, or tech',
      emoji: '💬',
      isPro: false,
      suggestions: [
        'Explain recursion in simple terms',
        'How to prepare for Google interview?',
        'What is the difference between SQL and NoSQL?',
        'Best resources to learn Flutter',
      ],
    ),
    AIFeature(
      type: AIFeatureType.resumeBuilder,
      title: 'Resume Builder',
      description: 'Create ATS-friendly resumes with AI assistance',
      emoji: '📄',
      isPro: true,
      suggestions: [
        'Review my resume',
        'Improve my project descriptions',
        'Suggest skills to add',
        'Make it more impactful',
      ],
    ),
    AIFeature(
      type: AIFeatureType.mockInterview,
      title: 'Mock Interview',
      description: 'Practice interviews with AI interviewer',
      emoji: '🎤',
      isPro: true,
      suggestions: [
        'Start DSA interview',
        'Practice system design',
        'Behavioral questions',
        'HR round preparation',
      ],
    ),
    AIFeature(
      type: AIFeatureType.codeReview,
      title: 'Code Review',
      description: 'Get instant feedback on your code',
      emoji: '💻',
      isPro: false,
      suggestions: [
        'Review my Python code',
        'Optimize this function',
        'Find bugs in my code',
        'Suggest better approach',
      ],
    ),
    AIFeature(
      type: AIFeatureType.careerAdvice,
      title: 'Career Advice',
      description: 'Get personalized career guidance',
      emoji: '🎯',
      isPro: false,
      suggestions: [
        'Should I do MS or get a job?',
        'How to switch to product management?',
        'Best companies for freshers',
        'How to negotiate salary?',
      ],
    ),
  ];

  final List<ChatSession> _chatSessions = [
    ChatSession(
      id: 'session1',
      title: 'DSA Preparation Tips',
      type: AIFeatureType.chat,
      messages: [
        ChatMessage(
          id: 'm1',
          content: 'How should I start preparing for DSA?',
          role: MessageRole.user,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ChatMessage(
          id: 'm2',
          content:
              'Great question! Here\'s a structured approach to DSA preparation:\n\n1. **Start with basics**: Arrays, Strings, and basic math\n2. **Move to data structures**: Linked Lists, Stacks, Queues, Trees\n3. **Learn algorithms**: Sorting, Searching, Recursion\n4. **Practice patterns**: Two pointers, Sliding window, etc.\n\nI recommend solving 2-3 problems daily on LeetCode starting with Easy level.',
          role: MessageRole.assistant,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ChatSession(
      id: 'session2',
      title: 'Flutter State Management',
      type: AIFeatureType.chat,
      messages: [
        ChatMessage(
          id: 'm3',
          content: 'What\'s the best state management for Flutter?',
          role: MessageRole.user,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ChatMessage(
          id: 'm4',
          content:
              'The "best" state management depends on your project needs:\n\n**For beginners:**\n- Provider (simple, official recommendation)\n- setState (for local state)\n\n**For medium projects:**\n- Riverpod (improved Provider)\n- BLoC (great for complex apps)\n\n**For large apps:**\n- BLoC with clean architecture\n- GetX (all-in-one solution)\n\nI recommend starting with Provider for learning!',
          role: MessageRole.assistant,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  ChatSession? _currentSession;
  bool _isTyping = false;

  List<AIFeature> get features => _features;
  List<ChatSession> get chatSessions => _chatSessions;
  ChatSession? get currentSession => _currentSession;
  bool get isTyping => _isTyping;

  List<ChatSession> get recentSessions {
    final sorted = List<ChatSession>.from(_chatSessions)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.take(5).toList();
  }

  AIFeature getFeature(AIFeatureType type) {
    return _features.firstWhere((f) => f.type == type);
  }

  void startNewSession(AIFeatureType type) {
    _currentSession = ChatSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: 'New ${_features.firstWhere((f) => f.type == type).title}',
      type: type,
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void loadSession(String sessionId) {
    _currentSession = _chatSessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => _chatSessions.first,
    );
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    if (_currentSession == null || content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    _currentSession!.messages.add(userMessage);
    _isTyping = true;
    notifyListeners();

    // Simulate AI response delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock AI response
    final aiResponse = _generateMockResponse(content, _currentSession!.type);
    final assistantMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
      content: aiResponse,
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
    );
    _currentSession!.messages.add(assistantMessage);
    _isTyping = false;

    // Update session title if it's the first message
    if (_currentSession!.messages.length == 2) {
      final words = content.split(' ').take(4).join(' ');
      _currentSession = ChatSession(
        id: _currentSession!.id,
        title: words.length > 30 ? '${words.substring(0, 30)}...' : words,
        type: _currentSession!.type,
        messages: _currentSession!.messages,
        createdAt: _currentSession!.createdAt,
        updatedAt: DateTime.now(),
      );
    }

    notifyListeners();
  }

  String _generateMockResponse(String query, AIFeatureType type) {
    final lowerQuery = query.toLowerCase();

    if (type == AIFeatureType.mockInterview) {
      return _getMockInterviewResponse(lowerQuery);
    } else if (type == AIFeatureType.resumeBuilder) {
      return _getResumeBuilderResponse(lowerQuery);
    } else if (type == AIFeatureType.codeReview) {
      return _getCodeReviewResponse(lowerQuery);
    } else if (type == AIFeatureType.careerAdvice) {
      return _getCareerAdviceResponse(lowerQuery);
    }

    // General chat responses
    if (lowerQuery.contains('dsa') || lowerQuery.contains('algorithm')) {
      return '''Here are some tips for DSA preparation:

1. **Master the fundamentals** - Arrays, Strings, and basic data structures
2. **Practice daily** - Solve at least 2-3 problems on LeetCode/CodeStudio
3. **Learn patterns** - Two pointers, Sliding window, Binary search, etc.
4. **Revise regularly** - Keep notes and revisit solved problems

Would you like me to suggest a specific topic to start with? 📚''';
    } else if (lowerQuery.contains('interview') ||
        lowerQuery.contains('prepare')) {
      return '''Great! Here's a structured interview preparation plan:

**Technical Round:**
- DSA: 100-150 LeetCode problems (mix of Easy/Medium)
- System Design: Learn basics (for 2+ years experience)
- CS Fundamentals: OS, DBMS, Networks

**HR/Behavioral:**
- Prepare STAR format answers
- Research the company
- Practice common questions

**Timeline:** 3-4 months of consistent preparation

Need help with any specific area? 🎯''';
    } else if (lowerQuery.contains('flutter') || lowerQuery.contains('dart')) {
      return '''Flutter is an excellent choice! Here's how to master it:

**Beginner (1-2 months):**
- Dart basics
- Flutter widgets
- Layouts & navigation

**Intermediate (2-3 months):**
- State management (Provider/Riverpod)
- API integration
- Local storage

**Advanced:**
- Custom animations
- Platform channels
- Performance optimization

Would you like resources for any specific topic? 💙''';
    }

    return '''That's a great question! Let me help you with that.

Based on what you're asking about, I'd recommend:

1. **Start with fundamentals** - Build a strong foundation
2. **Practice consistently** - Daily practice beats cramming
3. **Build projects** - Apply what you learn
4. **Join communities** - Learn from others

Is there anything specific you'd like me to elaborate on? 🚀''';
  }

  String _getMockInterviewResponse(String query) {
    if (query.contains('start') || query.contains('begin')) {
      return '''Great! Let's start your mock interview. 🎤

**Interview Type:** Technical (DSA)
**Difficulty:** Medium
**Duration:** 45 minutes

---

**Question 1:**

Given an array of integers, find two numbers that add up to a specific target.

**Example:**
```
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1] (because nums[0] + nums[1] = 9)
```

Take your time to think through the approach. When ready, share your solution!

*Hint: Think about what data structure can help you find complements efficiently.*''';
    }
    return '''I can help you practice for interviews! Here are the available modes:

1. **DSA Interview** - Data structures & algorithms
2. **System Design** - Architecture & scalability
3. **Behavioral** - STAR format questions
4. **HR Round** - Salary negotiation, career goals

Type "start [type]" to begin a mock interview session!''';
  }

  String _getResumeBuilderResponse(String query) {
    return '''I'd be happy to help with your resume! 📄

Here's what I can do:
- **Review your resume** - Get detailed feedback
- **Improve bullet points** - Make them impactful
- **ATS optimization** - Ensure it passes filters
- **Tailor for roles** - Customize for specific jobs

To get started, you can:
1. Paste your current resume text
2. Tell me about your experience
3. Share the job you're targeting

What would you like to work on? ✨''';
  }

  String _getCodeReviewResponse(String query) {
    return '''I'll help review your code! 💻

Share your code and I'll provide:
- **Bug detection** - Find potential issues
- **Optimization tips** - Improve performance
- **Best practices** - Follow coding standards
- **Clean code suggestions** - Better readability

Just paste your code here and mention:
1. Programming language
2. What the code is supposed to do
3. Any specific concerns

Ready to review! 🔍''';
  }

  String _getCareerAdviceResponse(String query) {
    if (query.contains('fresher') || query.contains('first job')) {
      return '''Here's advice for freshers entering the job market:

**Building Your Profile:**
- Strong DSA skills (most important for freshers)
- 2-3 good projects on GitHub
- Active competitive programming profile

**Where to Apply:**
- Service companies: TCS, Infosys, Wipro (good for starting)
- Product startups: Great learning, equity
- Product companies: Google, Microsoft (requires strong prep)

**Expected Packages (2024):**
- Service: ₹3-6 LPA
- Startups: ₹6-15 LPA
- Big Tech: ₹15-45 LPA

Would you like specific advice for your situation? 🎯''';
    }
    return '''I can help guide your career! Here's what I can advise on:

1. **Choosing a path** - Development, Data Science, PM, etc.
2. **Upskilling** - What to learn for your goals
3. **Job search** - Where and how to apply
4. **Negotiation** - Salary and offers
5. **Growth** - Long-term career planning

What aspect would you like to explore? 🚀''';
  }

  void clearCurrentSession() {
    _currentSession = null;
    notifyListeners();
  }
}
