import 'package:cloud_firestore/cloud_firestore.dart';

class OpportunityModel {
  final String id;
  final String companyName;
  final String? companyLogo;
  final String position;
  final String description;
  final List<String> requirements;
  final List<String> responsibilities;
  final List<String> skills;
  final String location;
  final String workType; // Remote, On-site, Hybrid
  final String duration;
  final double? stipendMin;
  final double? stipendMax;
  final DateTime applicationDeadline;
  final int applicationsCount;
  final bool isActive;
  final String? applyLink;
  final DateTime createdAt;

  OpportunityModel({
    required this.id,
    required this.companyName,
    this.companyLogo,
    required this.position,
    required this.description,
    required this.requirements,
    this.responsibilities = const [],
    required this.skills,
    required this.location,
    this.workType = 'On-site',
    required this.duration,
    this.stipendMin,
    this.stipendMax,
    required this.applicationDeadline,
    this.applicationsCount = 0,
    this.isActive = true,
    this.applyLink,
    required this.createdAt,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      companyLogo: json['companyLogo'],
      position: json['position'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      location: json['location'] ?? '',
      workType: json['workType'] ?? 'On-site',
      duration: json['duration'] ?? '',
      stipendMin: (json['stipendMin'] as num?)?.toDouble(),
      stipendMax: (json['stipendMax'] as num?)?.toDouble(),
      applicationDeadline:
          (json['applicationDeadline'] as Timestamp?)?.toDate() ??
              DateTime.now(),
      applicationsCount: json['applicationsCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      applyLink: json['applyLink'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'position': position,
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'skills': skills,
      'location': location,
      'workType': workType,
      'duration': duration,
      'stipendMin': stipendMin,
      'stipendMax': stipendMax,
      'applicationDeadline': Timestamp.fromDate(applicationDeadline),
      'applicationsCount': applicationsCount,
      'isActive': isActive,
      'applyLink': applyLink,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get stipendRange {
    if (stipendMin == null && stipendMax == null) return 'Unpaid';
    if (stipendMin != null && stipendMax != null) {
      return '₹${stipendMin!.toInt()} - ₹${stipendMax!.toInt()}/month';
    }
    if (stipendMin != null) return '₹${stipendMin!.toInt()}/month';
    return '₹${stipendMax!.toInt()}/month';
  }

  // Convenience getters for screen compatibility
  String get title => position;
  String get company => companyName;
  String get type => workType;
  bool get isRemote =>
      workType.toLowerCase() == 'remote' || workType.toLowerCase() == 'hybrid';
  double get stipend => stipendMin ?? stipendMax ?? 0;
  DateTime get deadline => applicationDeadline;
  int get openings => 1; // Default to 1 if not specified

  bool get isExpired => applicationDeadline.isBefore(DateTime.now());

  int get daysRemaining =>
      applicationDeadline.difference(DateTime.now()).inDays;
}

class ApplicationModel {
  final String id;
  final String opportunityId;
  final String userId;
  final String status; // pending, reviewed, shortlisted, rejected, accepted
  final String? coverLetter;
  final String? resumeUrl;
  final DateTime appliedAt;
  final DateTime? reviewedAt;

  ApplicationModel({
    required this.id,
    required this.opportunityId,
    required this.userId,
    this.status = 'pending',
    this.coverLetter,
    this.resumeUrl,
    required this.appliedAt,
    this.reviewedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] ?? '',
      opportunityId: json['opportunityId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? 'pending',
      coverLetter: json['coverLetter'],
      resumeUrl: json['resumeUrl'],
      appliedAt: (json['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt: (json['reviewedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'opportunityId': opportunityId,
      'userId': userId,
      'status': status,
      'coverLetter': coverLetter,
      'resumeUrl': resumeUrl,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
    };
  }
}
