import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  // Toggle for dummy data
  final bool _useDummyData = true;

  List<UserModel> _topStudents = [];
  List<UserModel> _leaderboard = [];
  List<UserModel> _nationalLeaderboard = [];
  List<UserModel> _stateLeaderboard = [];
  List<UserModel> _zoneLeaderboard = [];
  UserModel? _viewedUser;
  bool _isLoading = false;
  bool _isLoadingTopStudents = false;
  bool _topStudentsFetched = false;
  String? _error;

  List<UserModel> get topStudents => _topStudents;
  List<UserModel> get leaderboard => _leaderboard;
  List<UserModel> get nationalLeaderboard => _nationalLeaderboard;
  List<UserModel> get stateLeaderboard => _stateLeaderboard;
  List<UserModel> get zoneLeaderboard => _zoneLeaderboard;
  UserModel? get viewedUser => _viewedUser;
  bool get isLoading => _isLoading;
  bool get isLoadingTopStudents => _isLoadingTopStudents;
  String? get error => _error;

  Future<void> fetchTopStudents(
      {int limit = 3, bool forceRefresh = false}) async {
    // Skip if already fetched and not forcing refresh
    if (_topStudentsFetched && !forceRefresh) return;
    // Skip if already loading
    if (_isLoadingTopStudents) return;

    try {
      _isLoadingTopStudents = true;
      notifyListeners();

      if (_useDummyData) {
        await Future.delayed(const Duration(milliseconds: 300));
        _topStudents = _getDummyLeaderboard().take(limit).toList();
      } else {
        _topStudents = await _firestoreService.getTopStudents(limit: limit);
      }
      _topStudentsFetched = true;
      _isLoadingTopStudents = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingTopStudents = false;
      notifyListeners();
    }
  }

  Future<void> fetchLeaderboard({
    required String scope,
    String? value,
    int limit = 50,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_useDummyData) {
        await Future.delayed(const Duration(milliseconds: 300));
        _leaderboard = _getDummyLeaderboard();
      } else {
        _leaderboard = await _firestoreService.getLeaderboard(
          scope: scope,
          value: value,
          limit: limit,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNationalLeaderboard({int limit = 50}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_useDummyData) {
        await Future.delayed(const Duration(milliseconds: 300));
        _nationalLeaderboard = _getDummyLeaderboard();
      } else {
        _nationalLeaderboard = await _firestoreService.getLeaderboard(
          scope: 'national',
          limit: limit,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStateLeaderboard(String state, {int limit = 50}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_useDummyData) {
        await Future.delayed(const Duration(milliseconds: 300));
        _stateLeaderboard = _getDummyLeaderboard()
            .where((u) => u.state == state || state.isEmpty)
            .toList();
      } else {
        _stateLeaderboard = await _firestoreService.getLeaderboard(
          scope: 'state',
          value: state,
          limit: limit,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchZoneLeaderboard(String zone, {int limit = 50}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_useDummyData) {
        await Future.delayed(const Duration(milliseconds: 300));
        _zoneLeaderboard = _getDummyLeaderboard()
            .where((u) => u.zone == zone || zone.isEmpty)
            .toList();
      } else {
        _zoneLeaderboard = await _firestoreService.getLeaderboard(
          scope: 'zone',
          value: zone,
          limit: limit,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUser(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _viewedUser = await _firestoreService.getUser(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(UserModel user) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestoreService.updateUser(user);
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

  Future<String?> uploadProfileImage(File file, String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final url = await _storageService.uploadProfileImage(file, userId);
      _isLoading = false;
      notifyListeners();
      return url;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<String?> uploadCoverImage(File file, String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final url = await _storageService.uploadCoverImage(file, userId);
      _isLoading = false;
      notifyListeners();
      return url;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Dummy leaderboard data
  List<UserModel> _getDummyLeaderboard() {
    final now = DateTime.now();
    return [
      UserModel(
        id: 'user_1',
        name: 'Arjun Mehta',
        email: 'arjun@email.com',
        avatarUrl: null,
        title: 'Full Stack Developer',
        institution: 'IIT Bombay',
        points: 4850,
        nationalRank: 1,
        stateRank: 1,
        zoneRank: 1,
        rankChange: 0,
        pointsToday: 250,
        streak: 45,
        state: 'Maharashtra',
        zone: 'West',
        badges: ['Quiz Master', 'Top Contributor', 'Course Completer'],
        skills: ['React', 'Node.js', 'Python', 'System Design'],
        createdAt: now.subtract(const Duration(days: 180)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_2',
        name: 'Priya Sharma',
        email: 'priya@email.com',
        avatarUrl: null,
        title: 'Data Scientist',
        institution: 'IIT Delhi',
        points: 4620,
        nationalRank: 2,
        stateRank: 1,
        zoneRank: 1,
        rankChange: 2,
        pointsToday: 180,
        streak: 38,
        state: 'Delhi',
        zone: 'North',
        badges: ['Data Wizard', 'Quiz Champion'],
        skills: ['Python', 'ML', 'TensorFlow', 'SQL'],
        createdAt: now.subtract(const Duration(days: 150)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_3',
        name: 'Rahul Verma',
        email: 'rahul@email.com',
        avatarUrl: null,
        title: 'Software Engineer',
        institution: 'NIT Trichy',
        points: 4380,
        nationalRank: 3,
        stateRank: 1,
        zoneRank: 1,
        rankChange: -1,
        pointsToday: 120,
        streak: 22,
        state: 'Tamil Nadu',
        zone: 'South',
        badges: ['Code Ninja', 'Rising Star'],
        skills: ['Java', 'Spring Boot', 'AWS'],
        createdAt: now.subtract(const Duration(days: 120)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_4',
        name: 'Sneha Patel',
        email: 'sneha@email.com',
        avatarUrl: null,
        title: 'Frontend Developer',
        institution: 'BITS Pilani',
        points: 4150,
        nationalRank: 4,
        stateRank: 2,
        zoneRank: 2,
        rankChange: 3,
        pointsToday: 200,
        streak: 30,
        state: 'Gujarat',
        zone: 'West',
        badges: ['UI Expert', 'Consistent Learner'],
        skills: ['React', 'Vue.js', 'CSS', 'Figma'],
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_5',
        name: 'Vikram Singh',
        email: 'vikram@email.com',
        avatarUrl: null,
        title: 'ML Engineer',
        institution: 'IIT Madras',
        points: 3920,
        nationalRank: 5,
        stateRank: 2,
        zoneRank: 2,
        rankChange: 1,
        pointsToday: 150,
        streak: 18,
        state: 'Tamil Nadu',
        zone: 'South',
        badges: ['AI Pioneer'],
        skills: ['Python', 'PyTorch', 'Deep Learning'],
        createdAt: now.subtract(const Duration(days: 100)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_6',
        name: 'Aisha Khan',
        email: 'aisha@email.com',
        avatarUrl: null,
        title: 'Backend Developer',
        institution: 'IIIT Hyderabad',
        points: 3750,
        nationalRank: 6,
        stateRank: 1,
        zoneRank: 3,
        rankChange: 2,
        pointsToday: 175,
        streak: 25,
        state: 'Telangana',
        zone: 'South',
        badges: ['Backend Pro', 'Problem Solver'],
        skills: ['Go', 'Rust', 'PostgreSQL', 'Docker'],
        createdAt: now.subtract(const Duration(days: 85)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_7',
        name: 'Rohan Das',
        email: 'rohan@email.com',
        avatarUrl: null,
        title: 'DevOps Engineer',
        institution: 'NIT Warangal',
        points: 3580,
        nationalRank: 7,
        stateRank: 2,
        zoneRank: 4,
        rankChange: -2,
        pointsToday: 90,
        streak: 12,
        state: 'Telangana',
        zone: 'South',
        badges: ['Cloud Expert'],
        skills: ['Kubernetes', 'AWS', 'Terraform', 'CI/CD'],
        createdAt: now.subtract(const Duration(days: 75)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_8',
        name: 'Neha Gupta',
        email: 'neha@email.com',
        avatarUrl: null,
        title: 'Product Manager',
        institution: 'IIM Bangalore',
        points: 3420,
        nationalRank: 8,
        stateRank: 1,
        zoneRank: 5,
        rankChange: 4,
        pointsToday: 220,
        streak: 35,
        state: 'Karnataka',
        zone: 'South',
        badges: ['Strategy Master', 'Team Player'],
        skills: ['Product Strategy', 'Analytics', 'Agile'],
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_9',
        name: 'Amit Kumar',
        email: 'amit@email.com',
        avatarUrl: null,
        title: 'Mobile Developer',
        institution: 'VIT Vellore',
        points: 3280,
        nationalRank: 9,
        stateRank: 3,
        zoneRank: 6,
        rankChange: 0,
        pointsToday: 100,
        streak: 15,
        state: 'Tamil Nadu',
        zone: 'South',
        badges: ['App Builder'],
        skills: ['Flutter', 'Kotlin', 'Swift', 'Firebase'],
        createdAt: now.subtract(const Duration(days: 70)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_10',
        name: 'Kavya Nair',
        email: 'kavya@email.com',
        avatarUrl: null,
        title: 'Security Engineer',
        institution: 'IIIT Bangalore',
        points: 3150,
        nationalRank: 10,
        stateRank: 2,
        zoneRank: 7,
        rankChange: 5,
        pointsToday: 280,
        streak: 28,
        state: 'Karnataka',
        zone: 'South',
        badges: ['Security Pro', 'Bug Hunter'],
        skills: ['Cybersecurity', 'Pen Testing', 'Network Security'],
        createdAt: now.subtract(const Duration(days: 55)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_11',
        name: 'Siddharth Joshi',
        email: 'sid@email.com',
        avatarUrl: null,
        title: 'Blockchain Developer',
        institution: 'NSUT Delhi',
        points: 2980,
        nationalRank: 11,
        stateRank: 2,
        zoneRank: 2,
        rankChange: -3,
        pointsToday: 50,
        streak: 8,
        state: 'Delhi',
        zone: 'North',
        badges: ['Web3 Pioneer'],
        skills: ['Solidity', 'Ethereum', 'Smart Contracts'],
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
      UserModel(
        id: 'user_12',
        name: 'Meera Reddy',
        email: 'meera@email.com',
        avatarUrl: null,
        title: 'QA Engineer',
        institution: 'SRM University',
        points: 2850,
        nationalRank: 12,
        stateRank: 4,
        zoneRank: 8,
        rankChange: 1,
        pointsToday: 130,
        streak: 20,
        state: 'Tamil Nadu',
        zone: 'South',
        badges: ['Quality Champion'],
        skills: ['Selenium', 'Testing', 'Automation'],
        createdAt: now.subtract(const Duration(days: 50)),
        updatedAt: now,
      ),
    ];
  }
}
