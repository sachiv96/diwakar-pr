import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    // Welcome Screen 1 - Learning Feature
    OnboardingData(
      icon: Icons.play_circle_filled,
      secondaryIcon: Icons.laptop_mac,
      title: 'Learn from Industry Experts',
      description:
          'Access courses from top professionals and level up your skills.',
      color: AppColors.primary,
      backgroundColor: const Color(0xFFE8E3FF),
    ),
    // Welcome Screen 2 - Quiz & Ranking Feature
    OnboardingData(
      icon: Icons.emoji_events,
      secondaryIcon: Icons.leaderboard,
      title: 'Compete & Climb the Ranks',
      description:
          'Take quizzes, earn XP, and compete with students across India.',
      color: AppColors.warning,
      backgroundColor: const Color(0xFFFFF3E0),
    ),
    // Welcome Screen 3 - Opportunities Feature
    OnboardingData(
      icon: Icons.work,
      secondaryIcon: Icons.description,
      title: 'Land Your Dream Internship',
      description:
          'Discover internships, apply directly, and track your applications.',
      color: AppColors.secondary,
      backgroundColor: const Color(0xFFE0F7FA),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Goal Selection after completing onboarding
      Navigator.pushReplacementNamed(context, AppRoutes.goalSelection);
    }
  }

  void _skip() {
    // Skip goes directly to Goal Selection
    Navigator.pushReplacementNamed(context, AppRoutes.goalSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button - only show if not on last page
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: _currentPage < _pages.length - 1
                    ? TextButton(
                        onPressed: _skip,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : const SizedBox(height: 48),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Indicators (○ ● ○ pattern)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildIndicator(index),
              ),
            ),
            const SizedBox(height: 40),

            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: CustomButton(
                text:
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _nextPage,
                width: double.infinity,
                icon: _currentPage < _pages.length - 1
                    ? Icons.arrow_forward
                    : null,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Container
          Container(
            width: double.infinity,
            height: 280,
            margin: const EdgeInsets.only(bottom: 48),
            decoration: BoxDecoration(
              color: data.backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background decorative circles
                Positioned(
                  top: 20,
                  right: 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Main illustration
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Secondary icon (laptop/leaderboard/document)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: data.color.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        data.secondaryIcon,
                        size: 64,
                        color: data.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Primary icon badge
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: data.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: data.color.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        data.icon,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondaryLight,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final IconData secondaryIcon;
  final String title;
  final String description;
  final Color color;
  final Color backgroundColor;

  OnboardingData({
    required this.icon,
    required this.secondaryIcon,
    required this.title,
    required this.description,
    required this.color,
    required this.backgroundColor,
  });
}
