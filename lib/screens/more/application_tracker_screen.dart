import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/application_model.dart';

class ApplicationTrackerScreen extends StatefulWidget {
  const ApplicationTrackerScreen({super.key});

  @override
  State<ApplicationTrackerScreen> createState() =>
      _ApplicationTrackerScreenState();
}

class _ApplicationTrackerScreenState extends State<ApplicationTrackerScreen> {
  // Dummy data for now
  final List<ApplicationModel> _applications = [
    ApplicationModel(
      id: '1',
      opportunityId: 'opp1',
      userId: 'user1',
      companyName: 'Google',
      companyLogo: '',
      position: 'SWE Intern',
      status: ApplicationStatus.applied,
      appliedAt: DateTime(2026, 1, 10),
    ),
    ApplicationModel(
      id: '2',
      opportunityId: 'opp2',
      userId: 'user1',
      companyName: 'Flipkart',
      companyLogo: '',
      position: 'Product Intern',
      status: ApplicationStatus.interview,
      appliedAt: DateTime(2026, 1, 5),
      interviewDate: DateTime(2026, 1, 20),
    ),
    ApplicationModel(
      id: '3',
      opportunityId: 'opp3',
      userId: 'user1',
      companyName: 'Amazon',
      companyLogo: '',
      position: 'SDE Intern',
      status: ApplicationStatus.offered,
      appliedAt: DateTime(2025, 12, 20),
      offerDate: DateTime(2026, 1, 12),
    ),
    ApplicationModel(
      id: '4',
      opportunityId: 'opp4',
      userId: 'user1',
      companyName: 'Microsoft',
      companyLogo: '',
      position: 'Software Engineer Intern',
      status: ApplicationStatus.inReview,
      appliedAt: DateTime(2026, 1, 8),
    ),
    ApplicationModel(
      id: '5',
      opportunityId: 'opp5',
      userId: 'user1',
      companyName: 'Meta',
      companyLogo: '',
      position: 'Production Engineering Intern',
      status: ApplicationStatus.rejected,
      appliedAt: DateTime(2025, 12, 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appliedCount = _applications
        .where((a) => a.status == ApplicationStatus.applied)
        .length;
    final inReviewCount = _applications
        .where((a) =>
            a.status == ApplicationStatus.inReview ||
            a.status == ApplicationStatus.interview)
        .length;
    final offeredCount = _applications
        .where((a) => a.status == ApplicationStatus.offered)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Stats
            Text(
              '📊 Overview',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    count: appliedCount,
                    label: 'Applied',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    count: inReviewCount,
                    label: 'In Progress',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    count: offeredCount,
                    label: 'Offered',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Applications List
            Text(
              'Applications',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            if (_applications.isEmpty)
              _buildEmptyState()
            else
              ..._applications.map((app) => _buildApplicationCard(app)),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationModel application) {
    final statusColor = _getStatusColor(application.status);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    application.companyName[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.companyName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      application.position,
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Tracker
          _buildProgressTracker(application),
          const SizedBox(height: 12),

          // Status message
          _buildStatusMessage(application, dateFormat),
        ],
      ),
    );
  }

  Widget _buildProgressTracker(ApplicationModel application) {
    final stages = ['Applied', 'Review', 'Interview', 'Offer'];
    final currentIndex = application.status == ApplicationStatus.rejected
        ? -1
        : application.statusIndex;

    return Row(
      children: List.generate(stages.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          final stageIndex = index ~/ 2;
          final isActive = currentIndex > stageIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isActive ? AppColors.primary : Colors.grey.shade300,
            ),
          );
        } else {
          // Circle
          final stageIndex = index ~/ 2;
          final isActive = currentIndex >= stageIndex;
          final isCurrent = currentIndex == stageIndex;

          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primary : Colors.grey.shade300,
              border: isCurrent
                  ? Border.all(color: AppColors.primary, width: 3)
                  : null,
            ),
            child: isActive
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          );
        }
      }),
    );
  }

  Widget _buildStatusMessage(
      ApplicationModel application, DateFormat dateFormat) {
    String message;
    Color bgColor;
    IconData icon;

    switch (application.status) {
      case ApplicationStatus.applied:
        message = 'Applied: ${dateFormat.format(application.appliedAt)}';
        bgColor = Colors.blue.withOpacity(0.1);
        icon = Icons.send;
        break;
      case ApplicationStatus.inReview:
        message =
            'Under review since ${dateFormat.format(application.appliedAt)}';
        bgColor = Colors.orange.withOpacity(0.1);
        icon = Icons.hourglass_top;
        break;
      case ApplicationStatus.interview:
        message = application.interviewDate != null
            ? 'Interview: ${dateFormat.format(application.interviewDate!)}'
            : 'Interview scheduled';
        bgColor = Colors.purple.withOpacity(0.1);
        icon = Icons.videocam;
        break;
      case ApplicationStatus.offered:
        message = '🎉 Offer received!';
        bgColor = Colors.green.withOpacity(0.1);
        icon = Icons.celebration;
        break;
      case ApplicationStatus.rejected:
        message = 'Application not selected';
        bgColor = Colors.red.withOpacity(0.1);
        icon = Icons.close;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _getStatusColor(application.status)),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getStatusColor(application.status),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return Colors.blue;
      case ApplicationStatus.inReview:
        return Colors.orange;
      case ApplicationStatus.interview:
        return Colors.purple;
      case ApplicationStatus.offered:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.work_off_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Applications Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start applying to opportunities to track them here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
