import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/course_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/course_model.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Free', 'Premium', 'New'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    final userId = context.read<AuthProvider>().user?.id ?? '';
    context.read<CourseProvider>().listenToCourses();
    context.read<CourseProvider>().fetchUserProgress(userId);
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        slivers: [
          // Continue Learning Section
          if (_getInProgressCourses(courseProvider).isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Continue Learning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _getInProgressCourses(courseProvider).length,
                  itemBuilder: (context, index) {
                    final course = _getInProgressCourses(courseProvider)[index];
                    final progress = courseProvider.userProgress[course.id];
                    return _buildContinueLearningCard(course, progress);
                  },
                ),
              ),
            ),
          ],

          // Your Skills Section
          if (user?.interests != null && user!.interests.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  children: [
                    const Icon(Icons.stars, size: 20, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Skills',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: user.interests.length,
                  itemBuilder: (context, index) {
                    return _buildSkillBadge(
                      user.interests[index],
                      _getSkillProgress(courseProvider, user.interests[index]),
                    );
                  },
                ),
              ),
            ),
          ],

          // Explore Courses Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.explore, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Explore Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(filter),
                          if (filter == 'Premium') ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.diamond, size: 14),
                          ],
                          if (filter == 'New') ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      backgroundColor: AppColors.backgroundLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                    ),
                  );
                },
              ),
            ),
          ),

          // Courses List
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildFilteredCoursesList(courseProvider),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  List<CourseModel> _getInProgressCourses(CourseProvider provider) {
    final enrolledCourseIds = provider.userProgress.keys.toList();
    return provider.courses.where((c) {
      final progress = provider.userProgress[c.id];
      return enrolledCourseIds.contains(c.id) &&
          progress != null &&
          progress.progressPercentage > 0 &&
          progress.progressPercentage < 100;
    }).toList();
  }

  int _getSkillProgress(CourseProvider provider, String skill) {
    // Calculate progress based on completed courses in this category
    final skillCourses = provider.courses.where(
      (c) =>
          c.category.toLowerCase() == skill.toLowerCase() ||
          c.skills.any((s) => s.toLowerCase() == skill.toLowerCase()),
    );
    if (skillCourses.isEmpty) return 0;

    int totalProgress = 0;
    int enrolledCount = 0;
    for (final course in skillCourses) {
      final progress = provider.userProgress[course.id];
      if (progress != null) {
        totalProgress += progress.progressPercentage;
        enrolledCount++;
      }
    }
    return enrolledCount > 0 ? (totalProgress / enrolledCount).round() : 0;
  }

  Widget _buildContinueLearningCard(
      CourseModel course, UserCourseProgress? progress) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.courseDetail,
          arguments: course.id,
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(course.category),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (progress?.progressPercentage ?? 0) / 100,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${progress?.progressPercentage ?? 0}% Complete',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getCurrentModuleName(course, progress),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                          size: 14, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentModuleName(
      CourseModel course, UserCourseProgress? progress) {
    if (course.modules.isEmpty) return 'Getting started';
    final completedCount = progress?.completedLessons.length ?? 0;
    int lessonCount = 0;
    for (final module in course.modules) {
      lessonCount += module.lessons.length;
      if (lessonCount > completedCount) {
        return 'Module ${module.order}: ${module.title}';
      }
    }
    return 'Module ${course.modules.length}: ${course.modules.last.title}';
  }

  Widget _buildSkillBadge(String skill, int progress) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(skill),
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            skill.length > 8 ? '${skill.substring(0, 8)}...' : skill,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$progress%',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'react':
      case 'javascript':
      case 'web':
        return Icons.web;
      case 'python':
        return Icons.code;
      case 'sql':
      case 'database':
        return Icons.storage;
      case 'flutter':
      case 'mobile':
        return Icons.phone_android;
      case 'machine learning':
      case 'ai':
        return Icons.psychology;
      case 'data science':
        return Icons.analytics;
      case 'system design':
        return Icons.architecture;
      default:
        return Icons.school;
    }
  }

  Widget _buildFilteredCoursesList(CourseProvider provider) {
    List<CourseModel> filteredCourses;

    switch (_selectedFilter) {
      case 'Free':
        filteredCourses = provider.courses.where((c) => c.price == 0).toList();
        break;
      case 'Premium':
        filteredCourses = provider.courses.where((c) => c.isPremium).toList();
        break;
      case 'New':
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        filteredCourses = provider.courses
            .where((c) => c.createdAt.isAfter(thirtyDaysAgo))
            .toList();
        break;
      default:
        filteredCourses = provider.courses;
    }

    if (filteredCourses.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppColors.textSecondaryLight,
                ),
                const SizedBox(height: 16),
                Text(
                  'No $_selectedFilter courses found',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              _buildCourseCard(filteredCourses[index], provider),
          childCount: filteredCourses.length,
        ),
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course, CourseProvider provider) {
    final progress = provider.userProgress[course.id];
    final isEnrolled = progress != null;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.courseDetail,
          arguments: course.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: course.thumbnailUrl != null
                      ? Image.network(
                          course.thumbnailUrl!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 140,
                            color: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              _getCategoryIcon(course.category),
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : Container(
                          height: 140,
                          color: AppColors.primary.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(course.category),
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                ),
                // Premium badge
                if (course.isPremium)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.diamond, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'PREMIUM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Enrolled badge
                if (isEnrolled)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'ENROLLED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Course info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Stats row
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.people,
                          size: 16, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(course.enrolledCount),
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.schedule,
                          size: 16, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (course.price > 0) ...[
                        Row(
                          children: [
                            Text(
                              '₹${course.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (course.isPremium) ...[
                              const SizedBox(width: 8),
                              Text(
                                '₹${(course.price * 2.5).toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FREE',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isEnrolled ? 'Continue' : 'View',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward,
                                size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
