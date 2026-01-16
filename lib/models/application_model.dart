import 'package:cloud_firestore/cloud_firestore.dart';

enum ApplicationStatus {
  applied,
  inReview,
  interview,
  offered,
  rejected,
}

class ApplicationModel {
  final String id;
  final String opportunityId;
  final String userId;
  final String companyName;
  final String companyLogo;
  final String position;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime? interviewDate;
  final DateTime? offerDate;
  final String? notes;

  ApplicationModel({
    required this.id,
    required this.opportunityId,
    required this.userId,
    required this.companyName,
    required this.companyLogo,
    required this.position,
    required this.status,
    required this.appliedAt,
    this.interviewDate,
    this.offerDate,
    this.notes,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json, String id) {
    return ApplicationModel(
      id: id,
      opportunityId: json['opportunityId'] ?? '',
      userId: json['userId'] ?? '',
      companyName: json['companyName'] ?? '',
      companyLogo: json['companyLogo'] ?? '',
      position: json['position'] ?? '',
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApplicationStatus.applied,
      ),
      appliedAt: (json['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      interviewDate: (json['interviewDate'] as Timestamp?)?.toDate(),
      offerDate: (json['offerDate'] as Timestamp?)?.toDate(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opportunityId': opportunityId,
      'userId': userId,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'position': position,
      'status': status.name,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'interviewDate':
          interviewDate != null ? Timestamp.fromDate(interviewDate!) : null,
      'offerDate': offerDate != null ? Timestamp.fromDate(offerDate!) : null,
      'notes': notes,
    };
  }

  ApplicationModel copyWith({
    String? id,
    String? opportunityId,
    String? userId,
    String? companyName,
    String? companyLogo,
    String? position,
    ApplicationStatus? status,
    DateTime? appliedAt,
    DateTime? interviewDate,
    DateTime? offerDate,
    String? notes,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      opportunityId: opportunityId ?? this.opportunityId,
      userId: userId ?? this.userId,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      position: position ?? this.position,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      interviewDate: interviewDate ?? this.interviewDate,
      offerDate: offerDate ?? this.offerDate,
      notes: notes ?? this.notes,
    );
  }

  int get statusIndex {
    switch (status) {
      case ApplicationStatus.applied:
        return 0;
      case ApplicationStatus.inReview:
        return 1;
      case ApplicationStatus.interview:
        return 2;
      case ApplicationStatus.offered:
        return 3;
      case ApplicationStatus.rejected:
        return -1;
    }
  }

  String get statusText {
    switch (status) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.inReview:
        return 'In Review';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offered:
        return 'Offered';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }
}
