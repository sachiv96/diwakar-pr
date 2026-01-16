import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/firestore_service.dart';
import '../services/gemini_service.dart';

class CourseProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiService _geminiService = GeminiService();

  List<CourseModel> _courses = [];
  List<CourseModel> _enrolledCourses = [];
  List<CourseModel> _recommendedCourses = [];
  Map<String, UserCourseProgress> _userProgress = {};
  CourseModel? _currentCourse;
  CourseModel? _selectedCourse;
  UserCourseProgress? _currentProgress;
  bool _isLoading = false;
  String? _error;
  List<String> _recommendations = [];
  bool _useDummyData = true; // Toggle for dummy data

  List<CourseModel> get courses => _courses;
  List<CourseModel> get enrolledCourses => _enrolledCourses;
  List<CourseModel> get recommendedCourses => _recommendedCourses;
  Map<String, UserCourseProgress> get userProgress => _userProgress;
  CourseModel? get currentCourse => _currentCourse;
  CourseModel? get selectedCourse => _selectedCourse;
  UserCourseProgress? get currentProgress => _currentProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get recommendations => _recommendations;

  void listenToCourses() {
    if (_useDummyData) {
      _courses = _getDummyCourses();
      notifyListeners();
      return;
    }
    _firestoreService.getCourses().listen((courses) {
      _courses = courses;
      notifyListeners();
    });
  }

  Future<void> fetchCourse(String courseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_useDummyData) {
        _currentCourse = _getDummyCourses().firstWhere(
          (c) => c.id == courseId,
          orElse: () => _getDummyCourses().first,
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      _currentCourse = await _firestoreService.getCourse(courseId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCourse(CourseModel course) {
    _selectedCourse = course;
    notifyListeners();
  }

  Future<bool> enrollInCourse(String userId, String courseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_useDummyData) {
        // Add to enrolled courses locally for dummy data
        final course = _courses.firstWhere(
          (c) => c.id == courseId,
          orElse: () => _courses.first,
        );
        if (!_enrolledCourses.any((c) => c.id == courseId)) {
          _enrolledCourses.add(course);
        }
        // Add initial progress
        _userProgress[courseId] = UserCourseProgress(
          courseId: courseId,
          userId: userId,
          completedLessons: [],
          progressPercent: 0,
          startedAt: DateTime.now(),
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }

      await _firestoreService.enrollCourse(courseId, userId);

      // Add to enrolled courses locally
      final course = _courses.firstWhere((c) => c.id == courseId);
      if (!_enrolledCourses.any((c) => c.id == courseId)) {
        _enrolledCourses.add(course);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void updateEnrolledCourses(List<String> enrolledCourseIds) {
    _enrolledCourses =
        _courses.where((c) => enrolledCourseIds.contains(c.id)).toList();
    notifyListeners();
  }

  Future<void> fetchUserProgress(String userId) async {
    if (_useDummyData) {
      // Add dummy progress for some courses
      _userProgress = {
        'course_1': UserCourseProgress(
          courseId: 'course_1',
          userId: userId,
          completedLessons: [
            'lesson_1_1',
            'lesson_1_2',
            'lesson_1_3',
            'lesson_2_1'
          ],
          progressPercent: 65,
          startedAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        'course_3': UserCourseProgress(
          courseId: 'course_3',
          userId: userId,
          completedLessons: ['lesson_1_1'],
          progressPercent: 30,
          startedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      };
      notifyListeners();
      return;
    }
    notifyListeners();
  }

  List<CourseModel> _getDummyCourses() {
    return [
      CourseModel(
        id: 'course_1',
        title: 'React Masterclass 2026',
        description:
            'Master React from basics to advanced concepts. Learn hooks, context, Redux, and build real-world projects. This comprehensive course covers everything you need to become a professional React developer.',
        category: 'React',
        instructor: 'Priya Sharma',
        instructorTitle: 'SDE-3 @ Google',
        instructorAvatar: 'https://randomuser.me/api/portraits/women/44.jpg',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800',
        previewVideoUrl:
            'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        rating: 4.9,
        reviewsCount: 2345,
        enrolledCount: 12500,
        price: 1999,
        originalPrice: 4999,
        discountPercent: 60,
        saleEndDate: DateTime.now().add(const Duration(days: 2, hours: 14)),
        isPremium: true,
        duration: '25h 30m',
        level: 'Intermediate',
        difficulty: 'Intermediate',
        skills: ['React', 'JavaScript', 'Redux', 'Hooks'],
        whatYouLearn: [
          '25 hours of HD video content',
          '12 comprehensive modules',
          '50+ practice problems',
          'Certificate of completion',
          'Lifetime access',
          'Source code included',
        ],
        modules: [
          ModuleModel(
            id: 'module_1',
            title: 'Introduction to React',
            description: 'Get started with React fundamentals',
            order: 1,
            lessons: [
              LessonModel(
                id: 'lesson_1_1',
                title: 'What is React?',
                description: 'Introduction to React library',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 15,
                order: 1,
                isPreview: true,
              ),
              LessonModel(
                id: 'lesson_1_2',
                title: 'Setting Up Environment',
                description: 'Install Node.js and create-react-app',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 20,
                order: 2,
              ),
              LessonModel(
                id: 'lesson_1_3',
                title: 'Your First Component',
                description: 'Create your first React component',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 25,
                order: 3,
              ),
              LessonModel(
                id: 'lesson_1_4',
                title: 'Module 1 Quiz',
                description: 'Test your knowledge',
                type: 'quiz',
                duration: 10,
                order: 4,
              ),
            ],
          ),
          ModuleModel(
            id: 'module_2',
            title: 'React Hooks Deep Dive',
            description: 'Master useState, useEffect, and custom hooks',
            order: 2,
            lessons: [
              LessonModel(
                id: 'lesson_2_1',
                title: 'useState Hook',
                description: 'Managing state in functional components',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 30,
                order: 1,
              ),
              LessonModel(
                id: 'lesson_2_2',
                title: 'useEffect Hook',
                description: 'Side effects in React',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 35,
                order: 2,
              ),
              LessonModel(
                id: 'lesson_2_3',
                title: 'Custom Hooks',
                description: 'Build reusable hooks',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 40,
                order: 3,
              ),
            ],
          ),
          ModuleModel(
            id: 'module_3',
            title: 'State Management with Redux',
            description: 'Learn Redux for complex state management',
            order: 3,
            lessons: [
              LessonModel(
                id: 'lesson_3_1',
                title: 'Redux Fundamentals',
                description: 'Actions, reducers, and store',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 45,
                order: 1,
              ),
              LessonModel(
                id: 'lesson_3_2',
                title: 'Redux Toolkit',
                description: 'Modern Redux with RTK',
                type: 'video',
                videoUrl:
                    'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                duration: 40,
                order: 2,
              ),
            ],
          ),
        ],
        reviews: [
          CourseReview(
            id: 'review_1',
            userId: 'user_1',
            userName: 'Rahul Kumar',
            rating: 5,
            comment:
                'Best React course ever! The instructor explains everything so clearly.',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          CourseReview(
            id: 'review_2',
            userId: 'user_2',
            userName: 'Sneha Patel',
            rating: 5,
            comment:
                'Worth every penny. Got my first React job after completing this course!',
            createdAt: DateTime.now().subtract(const Duration(days: 12)),
          ),
          CourseReview(
            id: 'review_3',
            userId: 'user_3',
            userName: 'Amit Singh',
            rating: 4,
            comment:
                'Great content, though some sections could be more detailed.',
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      CourseModel(
        id: 'course_2',
        title: 'System Design Masterclass',
        description:
            'Learn how to design large-scale distributed systems. Covers load balancing, caching, databases, microservices, and more. Perfect preparation for senior engineering interviews.',
        category: 'System Design',
        instructor: 'Vikram Reddy',
        instructorTitle: 'Staff Engineer @ Meta',
        instructorAvatar: 'https://randomuser.me/api/portraits/men/32.jpg',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
        rating: 4.8,
        reviewsCount: 1890,
        enrolledCount: 8500,
        price: 2999,
        originalPrice: 7999,
        discountPercent: 63,
        saleEndDate: DateTime.now().add(const Duration(days: 5)),
        isPremium: true,
        duration: '30h',
        level: 'Advanced',
        difficulty: 'Advanced',
        skills: ['System Design', 'Scalability', 'Distributed Systems'],
        whatYouLearn: [
          '30 hours of video content',
          '15 real-world system designs',
          'Interview preparation guide',
          'Architecture diagrams',
          'Lifetime access',
        ],
        modules: [
          ModuleModel(
            id: 'sd_module_1',
            title: 'Introduction to System Design',
            description: 'Fundamentals of designing systems',
            order: 1,
            lessons: [
              LessonModel(
                id: 'sd_lesson_1_1',
                title: 'What is System Design?',
                description: 'Overview of system design',
                type: 'video',
                duration: 20,
                order: 1,
                isPreview: true,
              ),
              LessonModel(
                id: 'sd_lesson_1_2',
                title: 'Scalability Basics',
                description: 'Horizontal vs vertical scaling',
                type: 'video',
                duration: 25,
                order: 2,
              ),
            ],
          ),
          ModuleModel(
            id: 'sd_module_2',
            title: 'Load Balancing',
            description: 'Distribute traffic effectively',
            order: 2,
            lessons: [
              LessonModel(
                id: 'sd_lesson_2_1',
                title: 'Load Balancer Types',
                description: 'L4 vs L7 load balancers',
                type: 'video',
                duration: 30,
                order: 1,
              ),
            ],
          ),
        ],
        reviews: [
          CourseReview(
            id: 'sd_review_1',
            userId: 'user_4',
            userName: 'Karthik M',
            rating: 5,
            comment: 'Cracked my Google interview after this course!',
            createdAt: DateTime.now().subtract(const Duration(days: 8)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CourseModel(
        id: 'course_3',
        title: 'Python for Data Science',
        description:
            'Complete Python course for data science. Learn NumPy, Pandas, Matplotlib, and machine learning basics. Hands-on projects with real datasets.',
        category: 'Python',
        instructor: 'Dr. Ananya Gupta',
        instructorTitle: 'Data Scientist @ Amazon',
        instructorAvatar: 'https://randomuser.me/api/portraits/women/68.jpg',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=800',
        rating: 4.7,
        reviewsCount: 3200,
        enrolledCount: 25000,
        price: 0,
        isPremium: false,
        duration: '20h',
        level: 'Beginner',
        difficulty: 'Beginner',
        skills: ['Python', 'Data Science', 'NumPy', 'Pandas'],
        modules: [
          ModuleModel(
            id: 'py_module_1',
            title: 'Python Basics',
            description: 'Python fundamentals',
            order: 1,
            lessons: [
              LessonModel(
                id: 'py_lesson_1_1',
                title: 'Variables and Data Types',
                description: 'Basic Python concepts',
                type: 'video',
                duration: 25,
                order: 1,
                isPreview: true,
              ),
              LessonModel(
                id: 'py_lesson_1_2',
                title: 'Control Flow',
                description: 'If statements and loops',
                type: 'video',
                duration: 30,
                order: 2,
              ),
            ],
          ),
        ],
        reviews: [
          CourseReview(
            id: 'py_review_1',
            userId: 'user_5',
            userName: 'Deepa R',
            rating: 5,
            comment: 'Amazing free course! Better than many paid ones.',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      CourseModel(
        id: 'course_4',
        title: 'Flutter App Development',
        description:
            'Build beautiful cross-platform mobile apps with Flutter and Dart. From basics to publishing on App Store and Play Store.',
        category: 'Flutter',
        instructor: 'Rajesh Khanna',
        instructorTitle: 'Mobile Lead @ Flipkart',
        instructorAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1617040619263-41c5a9ca7521?w=800',
        rating: 4.9,
        reviewsCount: 1567,
        enrolledCount: 9800,
        price: 1499,
        originalPrice: 3999,
        discountPercent: 62,
        isPremium: true,
        duration: '35h',
        level: 'Intermediate',
        difficulty: 'Intermediate',
        skills: ['Flutter', 'Dart', 'Mobile Development', 'Firebase'],
        modules: [
          ModuleModel(
            id: 'fl_module_1',
            title: 'Dart Fundamentals',
            description: 'Learn Dart programming',
            order: 1,
            lessons: [
              LessonModel(
                id: 'fl_lesson_1_1',
                title: 'Dart Basics',
                description: 'Variables, functions, classes',
                type: 'video',
                duration: 40,
                order: 1,
                isPreview: true,
              ),
            ],
          ),
          ModuleModel(
            id: 'fl_module_2',
            title: 'Flutter Widgets',
            description: 'UI building blocks',
            order: 2,
            lessons: [
              LessonModel(
                id: 'fl_lesson_2_1',
                title: 'Stateless Widgets',
                description: 'Building static UI',
                type: 'video',
                duration: 35,
                order: 1,
              ),
              LessonModel(
                id: 'fl_lesson_2_2',
                title: 'Stateful Widgets',
                description: 'Managing state',
                type: 'video',
                duration: 45,
                order: 2,
              ),
            ],
          ),
        ],
        reviews: [],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CourseModel(
        id: 'course_5',
        title: 'SQL & Database Design',
        description:
            'Master SQL queries and database design. Learn MySQL, PostgreSQL, indexing, normalization, and query optimization.',
        category: 'SQL',
        instructor: 'Meera Krishnan',
        instructorTitle: 'DBA @ Microsoft',
        instructorAvatar: 'https://randomuser.me/api/portraits/women/22.jpg',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800',
        rating: 4.6,
        reviewsCount: 890,
        enrolledCount: 6200,
        price: 999,
        isPremium: false,
        duration: '15h',
        level: 'Beginner',
        difficulty: 'Beginner',
        skills: ['SQL', 'MySQL', 'PostgreSQL', 'Database'],
        modules: [
          ModuleModel(
            id: 'sql_module_1',
            title: 'SQL Basics',
            description: 'Getting started with SQL',
            order: 1,
            lessons: [
              LessonModel(
                id: 'sql_lesson_1_1',
                title: 'SELECT Statements',
                description: 'Query basics',
                type: 'video',
                duration: 20,
                order: 1,
                isPreview: true,
              ),
            ],
          ),
        ],
        reviews: [],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      CourseModel(
        id: 'course_6',
        title: 'Machine Learning A-Z',
        description:
            'Complete machine learning course. Linear regression, decision trees, neural networks, and deep learning with TensorFlow.',
        category: 'Machine Learning',
        instructor: 'Dr. Arjun Nair',
        instructorTitle: 'ML Researcher @ DeepMind',
        instructorAvatar: 'https://randomuser.me/api/portraits/men/67.jpg',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800',
        rating: 4.8,
        reviewsCount: 2100,
        enrolledCount: 15000,
        price: 3499,
        originalPrice: 8999,
        discountPercent: 61,
        saleEndDate: DateTime.now().add(const Duration(hours: 6)),
        isPremium: true,
        duration: '45h',
        level: 'Advanced',
        difficulty: 'Advanced',
        skills: ['Machine Learning', 'Python', 'TensorFlow', 'Deep Learning'],
        modules: [
          ModuleModel(
            id: 'ml_module_1',
            title: 'ML Fundamentals',
            description: 'Introduction to ML concepts',
            order: 1,
            lessons: [
              LessonModel(
                id: 'ml_lesson_1_1',
                title: 'What is Machine Learning?',
                description: 'ML overview',
                type: 'video',
                duration: 30,
                order: 1,
                isPreview: true,
              ),
            ],
          ),
        ],
        reviews: [
          CourseReview(
            id: 'ml_review_1',
            userId: 'user_6',
            userName: 'Sanjay P',
            rating: 5,
            comment: 'Transformed my career! Now working as ML Engineer.',
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Future<void> fetchRecommendedCourses(
      String userId, List<String> interests) async {
    try {
      _isLoading = true;
      notifyListeners();

      final recs = await _geminiService.getCourseRecommendations(
        completedCourses: _enrolledCourses.map((c) => c.title).toList(),
        interests: interests,
        skillLevel: 'intermediate',
      );

      // Filter courses based on recommendations
      _recommendedCourses = _courses
          .where((c) =>
              recs.any((r) => c.title.toLowerCase().contains(r.toLowerCase())))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRecommendations({
    required List<String> completedCourses,
    required List<String> interests,
    required String skillLevel,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _recommendations = await _geminiService.getCourseRecommendations(
        completedCourses: completedCourses,
        interests: interests,
        skillLevel: skillLevel,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CourseModel> getCoursesByCategory(String category) {
    if (category == 'All') return _courses;
    return _courses.where((c) => c.category == category).toList();
  }

  List<CourseModel> searchCourses(String query) {
    final lowerQuery = query.toLowerCase();
    return _courses.where((c) {
      return c.title.toLowerCase().contains(lowerQuery) ||
          c.description.toLowerCase().contains(lowerQuery) ||
          c.category.toLowerCase().contains(lowerQuery) ||
          c.skills.any((s) => s.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
