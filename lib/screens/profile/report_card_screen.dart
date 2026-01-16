import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Subject Grade Model
class SubjectGrade {
  final String subject;
  final String grade;
  final double percentage;
  final int totalMarks;
  final int obtainedMarks;
  final String teacherRemarks;
  final bool isPassed;

  const SubjectGrade({
    required this.subject,
    required this.grade,
    required this.percentage,
    required this.totalMarks,
    required this.obtainedMarks,
    this.teacherRemarks = '',
    this.isPassed = true,
  });
}

/// Term Performance Model
class TermPerformance {
  final String termName;
  final List<SubjectGrade> grades;
  final double overallPercentage;
  final String overallGrade;
  final int rank;
  final String principalRemarks;

  const TermPerformance({
    required this.termName,
    required this.grades,
    required this.overallPercentage,
    required this.overallGrade,
    required this.rank,
    this.principalRemarks = '',
  });
}

/// Report Card Screen - Academic Transcript View
class ReportCardScreen extends StatefulWidget {
  const ReportCardScreen({super.key});

  @override
  State<ReportCardScreen> createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends State<ReportCardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTermIndex = 0;

  // Mock data
  final List<TermPerformance> _terms = [
    TermPerformance(
      termName: 'Term 1 (2024-25)',
      overallPercentage: 85.6,
      overallGrade: 'A',
      rank: 5,
      principalRemarks:
          'Excellent performance! Shows great potential in Science subjects. Keep up the good work.',
      grades: [
        SubjectGrade(
          subject: 'Mathematics',
          grade: 'A+',
          percentage: 92.0,
          totalMarks: 100,
          obtainedMarks: 92,
          teacherRemarks: 'Outstanding problem-solving skills',
        ),
        SubjectGrade(
          subject: 'Science',
          grade: 'A',
          percentage: 88.0,
          totalMarks: 100,
          obtainedMarks: 88,
          teacherRemarks: 'Shows keen interest in experiments',
        ),
        SubjectGrade(
          subject: 'English',
          grade: 'A',
          percentage: 85.0,
          totalMarks: 100,
          obtainedMarks: 85,
          teacherRemarks: 'Good vocabulary and writing skills',
        ),
        SubjectGrade(
          subject: 'Hindi',
          grade: 'B+',
          percentage: 78.0,
          totalMarks: 100,
          obtainedMarks: 78,
          teacherRemarks: 'Needs to work on grammar',
        ),
        SubjectGrade(
          subject: 'Social Studies',
          grade: 'A',
          percentage: 86.0,
          totalMarks: 100,
          obtainedMarks: 86,
          teacherRemarks: 'Excellent in History topics',
        ),
        SubjectGrade(
          subject: 'Computer Science',
          grade: 'A+',
          percentage: 95.0,
          totalMarks: 100,
          obtainedMarks: 95,
          teacherRemarks: 'Exceptional programming abilities',
        ),
      ],
    ),
    TermPerformance(
      termName: 'Term 2 (2023-24)',
      overallPercentage: 82.3,
      overallGrade: 'A',
      rank: 8,
      principalRemarks: 'Good progress shown throughout the term.',
      grades: [
        SubjectGrade(
          subject: 'Mathematics',
          grade: 'A',
          percentage: 88.0,
          totalMarks: 100,
          obtainedMarks: 88,
          teacherRemarks: 'Consistent performance',
        ),
        SubjectGrade(
          subject: 'Science',
          grade: 'A',
          percentage: 85.0,
          totalMarks: 100,
          obtainedMarks: 85,
          teacherRemarks: 'Good practical knowledge',
        ),
        SubjectGrade(
          subject: 'English',
          grade: 'A',
          percentage: 82.0,
          totalMarks: 100,
          obtainedMarks: 82,
          teacherRemarks: 'Good reading comprehension',
        ),
        SubjectGrade(
          subject: 'Hindi',
          grade: 'B',
          percentage: 72.0,
          totalMarks: 100,
          obtainedMarks: 72,
          teacherRemarks: 'Needs improvement in writing',
        ),
        SubjectGrade(
          subject: 'Social Studies',
          grade: 'A',
          percentage: 84.0,
          totalMarks: 100,
          obtainedMarks: 84,
          teacherRemarks: 'Good understanding of Geography',
        ),
        SubjectGrade(
          subject: 'Computer Science',
          grade: 'A+',
          percentage: 93.0,
          totalMarks: 100,
          obtainedMarks: 93,
          teacherRemarks: 'Excellent coding skills',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _terms.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTermIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TermPerformance get _currentTerm => _terms[_selectedTermIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Report Card'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareReportCard(),
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () => _downloadReportCard(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Term Selector
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: _terms.map((t) => Tab(text: t.termName)).toList(),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Overall Performance Card
                  _buildOverallPerformanceCard(),

                  const SizedBox(height: 16),

                  // Grade Distribution Chart
                  _buildGradeDistribution(),

                  const SizedBox(height: 16),

                  // Subject-wise Grades
                  _buildSubjectGrades(),

                  const SizedBox(height: 16),

                  // Principal Remarks
                  _buildPrincipalRemarks(),

                  const SizedBox(height: 16),

                  // Performance Trend
                  _buildPerformanceTrend(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getGradeColor(_currentTerm.overallGrade),
            _getGradeColor(_currentTerm.overallGrade).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getGradeColor(_currentTerm.overallGrade).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Overall Grade Badge
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _currentTerm.overallGrade,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Performance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_currentTerm.overallPercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Class Rank: #${_currentTerm.rank}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat(
                  'Subjects', '${_currentTerm.grades.length}', Icons.book),
              _buildQuickStat(
                'Passed',
                '${_currentTerm.grades.where((g) => g.isPassed).length}',
                Icons.check_circle,
              ),
              _buildQuickStat(
                'Best',
                _currentTerm.grades
                    .reduce((a, b) => a.percentage > b.percentage ? a : b)
                    .subject
                    .split(' ')
                    .first,
                Icons.star,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeDistribution() {
    final gradeCount = <String, int>{};
    for (var grade in _currentTerm.grades) {
      gradeCount[grade.grade] = (gradeCount[grade.grade] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grade Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['A+', 'A', 'B+', 'B', 'C'].map((grade) {
              final count = gradeCount[grade] ?? 0;
              return Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? _getGradeColor(grade).withOpacity(0.1)
                          : Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: count > 0
                            ? _getGradeColor(grade)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: count > 0
                              ? _getGradeColor(grade)
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    grade,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectGrades() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Subject-wise Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ..._currentTerm.grades.map((grade) {
            return _buildSubjectGradeRow(grade);
          }),
        ],
      ),
    );
  }

  Widget _buildSubjectGradeRow(SubjectGrade grade) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showSubjectDetails(grade),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            children: [
              // Subject Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getSubjectColor(grade.subject).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSubjectIcon(grade.subject),
                  color: _getSubjectColor(grade.subject),
                ),
              ),
              const SizedBox(width: 16),

              // Subject Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grade.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${grade.obtainedMarks}/${grade.totalMarks}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${grade.percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: _getGradeColor(grade.grade),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Grade Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getGradeColor(grade.grade).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    grade.grade,
                    style: TextStyle(
                      color: _getGradeColor(grade.grade),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrincipalRemarks() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.format_quote,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Principal\'s Remarks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              _currentTerm.principalRemarks,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTrend() {
    if (_terms.length < 2) return const SizedBox.shrink();

    final trend = _terms[0].overallPercentage - _terms[1].overallPercentage;
    final isImproved = trend >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isImproved ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isImproved ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isImproved ? Colors.green[100] : Colors.red[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isImproved ? Icons.trending_up : Icons.trending_down,
              color: isImproved ? Colors.green[700] : Colors.red[700],
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isImproved ? 'Performance Improved! 🎉' : 'Needs Improvement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isImproved ? Colors.green[700] : Colors.red[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isImproved
                      ? 'You scored ${trend.abs().toStringAsFixed(1)}% higher than last term'
                      : 'Your score dropped by ${trend.abs().toStringAsFixed(1)}% from last term',
                  style: TextStyle(
                    color: isImproved ? Colors.green[600] : Colors.red[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSubjectDetails(SubjectGrade grade) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Subject Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getSubjectColor(grade.subject).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getSubjectIcon(grade.subject),
                    color: _getSubjectColor(grade.subject),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        grade.subject,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _currentTerm.termName,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getGradeColor(grade.grade).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      grade.grade,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getGradeColor(grade.grade),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Score Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreItem(
                      'Marks', '${grade.obtainedMarks}/${grade.totalMarks}'),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  _buildScoreItem(
                      'Percentage', '${grade.percentage.toStringAsFixed(1)}%'),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  _buildScoreItem(
                      'Status', grade.isPassed ? 'Passed' : 'Failed'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Teacher Remarks
            if (grade.teacherRemarks.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Teacher\'s Remarks',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      grade.teacherRemarks,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return const Color(0xFF4CAF50);
      case 'A':
        return const Color(0xFF8BC34A);
      case 'B+':
        return const Color(0xFFFFC107);
      case 'B':
        return const Color(0xFFFF9800);
      case 'C':
        return const Color(0xFFFF5722);
      default:
        return Colors.grey;
    }
  }

  Color _getSubjectColor(String subject) {
    final colors = {
      'Mathematics': const Color(0xFF2196F3),
      'Science': const Color(0xFF4CAF50),
      'English': const Color(0xFF9C27B0),
      'Hindi': const Color(0xFFFF5722),
      'Social Studies': const Color(0xFFFF9800),
      'Computer Science': const Color(0xFF00BCD4),
    };
    return colors[subject] ?? AppColors.primary;
  }

  IconData _getSubjectIcon(String subject) {
    final icons = {
      'Mathematics': Icons.calculate,
      'Science': Icons.science,
      'English': Icons.menu_book,
      'Hindi': Icons.translate,
      'Social Studies': Icons.public,
      'Computer Science': Icons.computer,
    };
    return icons[subject] ?? Icons.school;
  }

  void _shareReportCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _downloadReportCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download feature coming soon!')),
    );
  }
}
