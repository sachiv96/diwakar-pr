import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool _isBookmarked = false;
  Timer? _saleTimer;
  Duration _saleTimeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourse();
    });
  }

  @override
  void dispose() {
    _saleTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCourse() async {
    if (!mounted) return;
    await context.read<CourseProvider>().fetchCourse(widget.courseId);
    _startSaleTimer();
  }

  void _startSaleTimer() {
    final course = context.read<CourseProvider>().currentCourse;
    if (course?.isOnSale == true && course?.saleEndDate != null) {
      _updateSaleTime(course!.saleEndDate!);
      _saleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateSaleTime(course.saleEndDate!);
      });
    }
  }

  void _updateSaleTime(DateTime endDate) {
    final now = DateTime.now();
    if (endDate.isAfter(now)) {
      setState(() {
        _saleTimeRemaining = endDate.difference(now);
      });
    } else {
      _saleTimer?.cancel();
      setState(() {
        _saleTimeRemaining = Duration.zero;
      });
    }
  }

  String _formatSaleTime() {
    final days = _saleTimeRemaining.inDays;
    final hours = _saleTimeRemaining.inHours % 24;
    final minutes = _saleTimeRemaining.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m ${_saleTimeRemaining.inSeconds % 60}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final course = courseProvider.currentCourse;
    final userId = context.read<AuthProvider>().user?.id ?? '';
    final progress = courseProvider.userProgress[widget.courseId];
    final isEnrolled = progress != null;

    if (courseProvider.isLoading || course == null) {
      return const Scaffold(
        body: LoadingWidget(message: 'Loading course...'),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with video preview
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isBookmarked
                          ? 'Course bookmarked!'
                          : 'Bookmark removed'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Thumbnail or video preview
                  course.thumbnailUrl != null
                      ? Image.network(
                          course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildPlaceholder(course),
                        )
                      : _buildPlaceholder(course),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Play button for preview
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Play preview video
                        if (course.previewVideoUrl != null) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.videoPlayer,
                            arguments: {
                              'courseId': course.id,
                              'lessonId': 'preview',
                              'videoUrl': course.previewVideoUrl,
                              'title': 'Course Preview',
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  // Course title at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            course.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course title
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating and enrollment
                  Row(
                    children: [
                      const Icon(Icons.star, size: 20, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${course.rating.toStringAsFixed(1)} (${_formatCount(course.reviewsCount)})',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.people,
                          size: 20, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(course.enrolledCount),
                        style: TextStyle(color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Instructor info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary,
                        backgroundImage: course.instructorAvatar != null
                            ? NetworkImage(course.instructorAvatar!)
                            : null,
                        child: course.instructorAvatar == null
                            ? Text(
                                course.instructor[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'By: ${course.instructor}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          if (course.instructorTitle != null)
                            Text(
                              course.instructorTitle!,
                              style: TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Price card with sale countdown
                  if (!isEnrolled && course.price > 0) ...[
                    _buildPriceCard(course),
                    const SizedBox(height: 16),
                  ],

                  // Action buttons (for non-enrolled users)
                  if (!isEnrolled) ...[
                    CustomButton(
                      text: course.price > 0
                          ? 'Buy Now - ₹${course.price.toStringAsFixed(0)}'
                          : 'Enroll Now - Free',
                      onPressed: () =>
                          _handleEnroll(course, userId, courseProvider),
                      width: double.infinity,
                      icon:
                          course.price > 0 ? Icons.shopping_cart : Icons.school,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart!')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.primary),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Progress card (for enrolled users)
                  if (isEnrolled) ...[
                    _buildProgressCard(progress),
                    const SizedBox(height: 24),
                  ],

                  // What's Included section
                  _buildSectionTitle('What\'s Included'),
                  const SizedBox(height: 12),
                  _buildWhatsIncluded(course),
                  const SizedBox(height: 24),

                  // Course Content section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Course Content'),
                      Text(
                        '${course.modules.length} modules • ${course.totalLessons} lessons',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...course.modules.asMap().entries.map((entry) {
                    final index = entry.key;
                    final module = entry.value;
                    return _buildModuleCard(
                      index + 1,
                      module,
                      isEnrolled,
                      progress,
                      course.id,
                    );
                  }),
                  const SizedBox(height: 24),

                  // Reviews section
                  if (course.reviews.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Reviews'),
                        TextButton(
                          onPressed: () {
                            // Show all reviews
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...course.reviews.take(3).map(_buildReviewCard),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          isEnrolled ? _buildContinueBar(progress, course) : null,
    );
  }

  Widget _buildPlaceholder(CourseModel course) {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Icon(
          Icons.school,
          size: 64,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildPriceCard(CourseModel course) {
    final hasDiscount =
        course.discountPercent != null && course.discountPercent! > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '₹${course.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasDiscount) ...[
                const SizedBox(width: 12),
                Text(
                  '₹${course.displayOriginalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondaryLight,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${course.discountPercent ?? 60}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (course.isOnSale && _saleTimeRemaining.inSeconds > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Sale ends in ${_formatSaleTime()}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressCard(UserCourseProgress progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: progress.isCompleted
                      ? AppColors.success
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${progress.progressPercentage}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.progressPercentage / 100,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress.isCompleted ? AppColors.success : AppColors.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${progress.completedLessons.length} lessons completed',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWhatsIncluded(CourseModel course) {
    final defaultIncludes = [
      '${course.duration} of video content',
      '${course.modules.length} modules',
      '${course.totalLessons} lessons',
      'Certificate of completion',
      'Lifetime access',
    ];

    final includes =
        course.whatYouLearn.isNotEmpty ? course.whatYouLearn : defaultIncludes;

    return Column(
      children: includes
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: AppColors.success, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildModuleCard(
    int index,
    ModuleModel module,
    bool isEnrolled,
    UserCourseProgress? progress,
    String courseId,
  ) {
    final completedLessonsInModule = progress?.completedLessons
            .where((l) => module.lessons.any((ml) => ml.id == l))
            .length ??
        0;
    final isModuleCompleted =
        completedLessonsInModule == module.lessons.length &&
            module.lessons.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isModuleCompleted
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isModuleCompleted
                  ? Icon(Icons.check, color: AppColors.success, size: 20)
                  : Text(
                      '$index',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.folder, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Module $index: ${module.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${module.lessons.length} lessons • ${module.duration} min',
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 12,
              ),
            ),
          ),
          children: module.lessons.map((lesson) {
            final lessonCompleted =
                progress?.completedLessons.contains(lesson.id) ?? false;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Icon(
                lesson.type == 'video'
                    ? Icons.play_circle_outline
                    : lesson.type == 'quiz'
                        ? Icons.quiz_outlined
                        : Icons.article_outlined,
                color: lessonCompleted
                    ? AppColors.success
                    : AppColors.textSecondaryLight,
              ),
              title: Text(
                lesson.title,
                style: TextStyle(
                  fontSize: 14,
                  color: lessonCompleted
                      ? AppColors.textSecondaryLight
                      : AppColors.textPrimaryLight,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (lesson.isPreview && !isEnrolled)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (lessonCompleted)
                    Icon(Icons.check_circle, color: AppColors.success, size: 20)
                  else
                    Text(
                      '${lesson.duration} min',
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              onTap: (isEnrolled || lesson.isPreview)
                  ? () {
                      if (lesson.type == 'video' && lesson.videoUrl != null) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.videoPlayer,
                          arguments: {
                            'courseId': courseId,
                            'lessonId': lesson.id,
                            'videoUrl': lesson.videoUrl,
                            'title': lesson.title,
                            'moduleTitle': module.title,
                          },
                        );
                      }
                    }
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReviewCard(CourseReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: review.userAvatar != null
                    ? NetworkImage(review.userAvatar!)
                    : null,
                child: review.userAvatar == null
                    ? Text(
                        review.userName[0].toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"${review.comment}"',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueBar(UserCourseProgress progress, CourseModel course) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CustomButton(
        text: progress.isCompleted ? 'Course Completed ✓' : 'Continue Learning',
        onPressed: progress.isCompleted
            ? null
            : () {
                // Find next lesson and navigate
                _navigateToNextLesson(course, progress);
              },
        width: double.infinity,
        backgroundColor: progress.isCompleted ? AppColors.success : null,
      ),
    );
  }

  void _navigateToNextLesson(CourseModel course, UserCourseProgress progress) {
    for (final module in course.modules) {
      for (final lesson in module.lessons) {
        if (!progress.completedLessons.contains(lesson.id)) {
          if (lesson.type == 'video' && lesson.videoUrl != null) {
            Navigator.pushNamed(
              context,
              AppRoutes.videoPlayer,
              arguments: {
                'courseId': course.id,
                'lessonId': lesson.id,
                'videoUrl': lesson.videoUrl,
                'title': lesson.title,
                'moduleTitle': module.title,
              },
            );
          }
          return;
        }
      }
    }
  }

  Future<void> _handleEnroll(
    CourseModel course,
    String userId,
    CourseProvider courseProvider,
  ) async {
    final success = await courseProvider.enrollInCourse(userId, course.id);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully enrolled! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
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
