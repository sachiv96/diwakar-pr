import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';
import '../services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class OpportunityProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  List<OpportunityModel> _opportunities = [];
  List<ApplicationModel> _userApplications = [];
  OpportunityModel? _currentOpportunity;
  bool _isLoading = false;
  String? _error;

  // Filters
  String? _locationFilter;
  String? _workTypeFilter;
  List<String> _skillsFilter = [];

  List<OpportunityModel> get opportunities => _getFilteredOpportunities();
  List<ApplicationModel> get userApplications => _userApplications;
  List<ApplicationModel> get applications => _userApplications;
  OpportunityModel? get currentOpportunity => _currentOpportunity;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get locationFilter => _locationFilter;
  String? get workTypeFilter => _workTypeFilter;
  List<String> get skillsFilter => _skillsFilter;

  void listenToOpportunities() {
    _firestoreService.getOpportunities().listen((opportunities) {
      _opportunities = opportunities;
      notifyListeners();
    });
  }

  List<OpportunityModel> _getFilteredOpportunities() {
    var filtered = _opportunities;

    if (_locationFilter != null && _locationFilter!.isNotEmpty) {
      filtered = filtered
          .where((o) =>
              o.location.toLowerCase().contains(_locationFilter!.toLowerCase()))
          .toList();
    }

    if (_workTypeFilter != null && _workTypeFilter!.isNotEmpty) {
      filtered = filtered.where((o) => o.workType == _workTypeFilter).toList();
    }

    if (_skillsFilter.isNotEmpty) {
      filtered = filtered
          .where((o) => o.skills.any((s) => _skillsFilter.contains(s)))
          .toList();
    }

    return filtered;
  }

  void setLocationFilter(String? location) {
    _locationFilter = location;
    notifyListeners();
  }

  void setWorkTypeFilter(String? workType) {
    _workTypeFilter = workType;
    notifyListeners();
  }

  void setSkillsFilter(List<String> skills) {
    _skillsFilter = skills;
    notifyListeners();
  }

  void clearFilters() {
    _locationFilter = null;
    _workTypeFilter = null;
    _skillsFilter = [];
    notifyListeners();
  }

  Future<void> fetchOpportunity(String opportunityId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentOpportunity =
          await _firestoreService.getOpportunity(opportunityId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserApplications(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userApplications = await _firestoreService.getUserApplications(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> applyForOpportunity({
    required String opportunityId,
    required String userId,
    String? coverLetter,
    String? resumeUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final application = ApplicationModel(
        id: _uuid.v4(),
        opportunityId: opportunityId,
        userId: userId,
        coverLetter: coverLetter,
        resumeUrl: resumeUrl,
        appliedAt: DateTime.now(),
      );

      await _firestoreService.applyForOpportunity(application);
      _userApplications.add(application);

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

  bool hasApplied(String opportunityId) {
    return _userApplications.any((a) => a.opportunityId == opportunityId);
  }

  Future<bool> applyToOpportunity({
    required String userId,
    required String opportunityId,
    String? coverLetter,
    String? resumeUrl,
  }) async {
    return applyForOpportunity(
      opportunityId: opportunityId,
      userId: userId,
      coverLetter: coverLetter,
      resumeUrl: resumeUrl,
    );
  }

  ApplicationModel? getApplication(String opportunityId) {
    try {
      return _userApplications
          .firstWhere((a) => a.opportunityId == opportunityId);
    } catch (e) {
      return null;
    }
  }

  List<OpportunityModel> searchOpportunities(String query) {
    final lowerQuery = query.toLowerCase();
    return _opportunities.where((o) {
      return o.position.toLowerCase().contains(lowerQuery) ||
          o.companyName.toLowerCase().contains(lowerQuery) ||
          o.description.toLowerCase().contains(lowerQuery) ||
          o.skills.any((s) => s.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
