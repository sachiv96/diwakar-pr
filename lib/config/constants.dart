class AppConstants {
  // App Info
  static const String appName = 'StudyHub';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Learn, Connect, Grow';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String quizzesCollection = 'quizzes';
  static const String coursesCollection = 'courses';
  static const String opportunitiesCollection = 'opportunities';
  static const String leaderboardCollection = 'leaderboard';
  static const String notificationsCollection = 'notifications';
  static const String messagesCollection = 'messages';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String coverImagesPath = 'cover_images';
  static const String postImagesPath = 'post_images';
  static const String courseAssetsPath = 'course_assets';

  // Shared Preferences Keys
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
  static const String notificationsEnabledKey = 'notifications_enabled';

  // Pagination
  static const int postsPerPage = 10;
  static const int usersPerPage = 20;
  static const int quizzesPerPage = 10;
  static const int coursesPerPage = 10;
  static const int opportunitiesPerPage = 10;

  // Quiz Settings
  static const int defaultQuizDuration = 30; // minutes
  static const int questionTimeLimit = 60; // seconds

  // Points System
  static const int pointsPerQuizCorrectAnswer = 10;
  static const int pointsPerQuizCompletion = 50;
  static const int pointsPerCourseCompletion = 100;
  static const int pointsPerPost = 5;
  static const int pointsPerConnection = 10;

  // Ranks
  static const Map<String, int> rankThresholds = {
    'Beginner': 0,
    'Learner': 100,
    'Scholar': 500,
    'Expert': 1000,
    'Master': 2500,
    'Legend': 5000,
  };

  // API URLs
  static const String geminiApiBaseUrl =
      'https://generativelanguage.googleapis.com';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 20.0;
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 80.0;
  static const double avatarSizeXLarge = 120.0;
}

class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String logoLight = 'assets/images/logo_light.png';
  static const String logoDark = 'assets/images/logo_dark.png';
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String defaultCover = 'assets/images/default_cover.png';

  // Icons
  static const String homeIcon = 'assets/icons/home.svg';
  static const String quizIcon = 'assets/icons/quiz.svg';
  static const String learnIcon = 'assets/icons/learn.svg';
  static const String rankIcon = 'assets/icons/rank.svg';
  static const String opportunityIcon = 'assets/icons/opportunity.svg';

  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String emptyAnimation = 'assets/animations/empty.json';
  static const String confettiAnimation = 'assets/animations/confetti.json';
}
