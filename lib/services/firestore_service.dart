import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/constants.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/quiz_model.dart';
import '../models/course_model.dart';
import '../models/opportunity_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER OPERATIONS ====================

  // Get user by ID
  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .update(user.toJson());
  }

  // Get top students
  Future<List<UserModel>> getTopStudents({int limit = 3}) async {
    final query = await _firestore
        .collection(AppConstants.usersCollection)
        .orderBy('points', descending: true)
        .limit(limit)
        .get();
    return query.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  // Get leaderboard by scope
  Future<List<UserModel>> getLeaderboard({
    required String scope, // 'national', 'state', 'zone'
    String? value, // state name or zone name
    int limit = 50,
  }) async {
    Query query = _firestore.collection(AppConstants.usersCollection);

    if (scope == 'state' && value != null) {
      query = query.where('state', isEqualTo: value);
    } else if (scope == 'zone' && value != null) {
      query = query.where('zone', isEqualTo: value);
    }

    final result =
        await query.orderBy('points', descending: true).limit(limit).get();

    return result.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ==================== POST OPERATIONS ====================

  // Create post
  Future<void> createPost(PostModel post) async {
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(post.id)
        .set(post.toJson());
  }

  // Get posts feed
  Stream<List<PostModel>> getPostsFeed() {
    return _firestore
        .collection(AppConstants.postsCollection)
        .orderBy('createdAt', descending: true)
        .limit(AppConstants.postsPerPage)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromJson(doc.data()))
            .toList());
  }

  // Like/Unlike post
  Future<void> toggleLike(String postId, String oderId) async {
    final postRef =
        _firestore.collection(AppConstants.postsCollection).doc(postId);
    final post = await postRef.get();

    if (post.exists) {
      final likes = List<String>.from(post.data()!['likes'] ?? []);
      if (likes.contains(oderId)) {
        likes.remove(oderId);
      } else {
        likes.add(oderId);
      }
      await postRef.update({'likes': likes});
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(postId)
        .delete();
  }

  // ==================== QUIZ OPERATIONS ====================

  // Get available quizzes
  Stream<List<QuizModel>> getAvailableQuizzes() {
    return _firestore
        .collection(AppConstants.quizzesCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('scheduledDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QuizModel.fromJson(doc.data()))
            .toList());
  }

  // Get quiz by ID
  Future<QuizModel?> getQuiz(String quizId) async {
    final doc = await _firestore
        .collection(AppConstants.quizzesCollection)
        .doc(quizId)
        .get();
    if (doc.exists) {
      return QuizModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Save quiz attempt
  Future<void> saveQuizAttempt(QuizAttemptModel attempt) async {
    await _firestore
        .collection(AppConstants.quizzesCollection)
        .doc(attempt.quizId)
        .collection('attempts')
        .doc(attempt.id)
        .set(attempt.toJson());

    // Update user's completed quizzes
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(attempt.userId)
        .update({
      'completedQuizzes': FieldValue.arrayUnion([attempt.quizId]),
      'points': FieldValue.increment(attempt.score),
    });

    // Update quiz participants count
    await _firestore
        .collection(AppConstants.quizzesCollection)
        .doc(attempt.quizId)
        .update({
      'participantsCount': FieldValue.increment(1),
    });
  }

  // ==================== COURSE OPERATIONS ====================

  // Get all courses
  Stream<List<CourseModel>> getCourses() {
    return _firestore
        .collection(AppConstants.coursesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromJson(doc.data()))
            .toList());
  }

  // Get course by ID
  Future<CourseModel?> getCourse(String courseId) async {
    final doc = await _firestore
        .collection(AppConstants.coursesCollection)
        .doc(courseId)
        .get();
    if (doc.exists) {
      return CourseModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Enroll in course
  Future<void> enrollCourse(String courseId, String oderId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(oderId)
        .update({
      'enrolledCourses': FieldValue.arrayUnion([courseId]),
    });

    await _firestore
        .collection(AppConstants.coursesCollection)
        .doc(courseId)
        .update({
      'enrolledCount': FieldValue.increment(1),
    });
  }

  // ==================== OPPORTUNITY OPERATIONS ====================

  // Get opportunities
  Stream<List<OpportunityModel>> getOpportunities() {
    return _firestore
        .collection(AppConstants.opportunitiesCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OpportunityModel.fromJson(doc.data()))
            .toList());
  }

  // Get opportunity by ID
  Future<OpportunityModel?> getOpportunity(String opportunityId) async {
    final doc = await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .doc(opportunityId)
        .get();
    if (doc.exists) {
      return OpportunityModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Apply for opportunity
  Future<void> applyForOpportunity(ApplicationModel application) async {
    await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .doc(application.opportunityId)
        .collection('applications')
        .doc(application.id)
        .set(application.toJson());

    await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .doc(application.opportunityId)
        .update({
      'applicationsCount': FieldValue.increment(1),
    });
  }

  // Get user applications
  Future<List<ApplicationModel>> getUserApplications(String oderId) async {
    final List<ApplicationModel> applications = [];

    final opportunities =
        await _firestore.collection(AppConstants.opportunitiesCollection).get();

    for (var opp in opportunities.docs) {
      final appDocs = await opp.reference
          .collection('applications')
          .where('userId', isEqualTo: oderId)
          .get();

      applications.addAll(
        appDocs.docs.map((doc) => ApplicationModel.fromJson(doc.data())),
      );
    }

    return applications;
  }
}
