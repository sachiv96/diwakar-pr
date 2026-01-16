import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/goal_selection_screen.dart';
import '../screens/onboarding/interest_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/create_post_screen.dart';
import '../screens/home/post_detail_screen.dart';
import '../screens/quiz/quiz_list_screen.dart';
import '../screens/quiz/quiz_detail_screen.dart';
import '../screens/quiz/quiz_attempt_screen.dart';
import '../screens/quiz/quiz_result_screen.dart';
import '../screens/learn/learn_screen.dart';
import '../screens/learn/course_detail_screen.dart';
import '../screens/learn/video_player_screen.dart';
import '../screens/rank/rank_screen.dart';
import '../screens/opportunity/opportunity_screen.dart';
import '../screens/opportunity/opportunity_detail_screen.dart';
import '../screens/more/more_screen.dart';
import '../screens/more/application_tracker_screen.dart';
import '../screens/more/subscription_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/events/event_detail_screen.dart';
import '../screens/community/community_screen.dart';
import '../screens/community/community_detail_screen.dart';
import '../screens/ai_assistant/ai_assistant_screen.dart';
import '../screens/ai_assistant/ai_chat_screen.dart';
import '../models/ai_assistant_model.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/enhanced_profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/achievements_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/profile/theme_customization_screen.dart';
import '../screens/profile/goals_screen.dart';
import '../screens/profile/analytics_dashboard_screen.dart';
import '../screens/profile/friends_list_screen.dart';
import '../screens/profile/report_card_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/messages/messages_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String goalSelection = '/goal-selection';
  static const String interestSelection = '/interest-selection';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String home = '/home';
  static const String createPost = '/create-post';
  static const String postDetail = '/post-detail';
  static const String quizList = '/quiz-list';
  static const String quizDetail = '/quiz-detail';
  static const String quizAttempt = '/quiz-attempt';
  static const String quizResult = '/quiz-result';
  static const String learn = '/learn';
  static const String courseDetail = '/course-detail';
  static const String videoPlayer = '/video-player';
  static const String rank = '/rank';
  static const String opportunities = '/opportunities';
  static const String opportunityDetail = '/opportunity-detail';
  static const String more = '/more';
  static const String applicationTracker = '/application-tracker';
  static const String subscription = '/subscription';
  static const String events = '/events';
  static const String eventDetail = '/event-detail';
  static const String community = '/community';
  static const String communityDetail = '/community-detail';
  static const String aiAssistant = '/ai-assistant';
  static const String aiChat = '/ai-chat';
  static const String appSettings = '/settings';
  static const String profile = '/profile';
  static const String enhancedProfile = '/enhanced-profile';
  static const String editProfile = '/edit-profile';
  static const String achievements = '/achievements';
  static const String themeCustomization = '/theme-customization';
  static const String goals = '/goals';
  static const String analytics = '/analytics';
  static const String friends = '/friends';
  static const String reportCard = '/report-card';
  static const String notifications = '/notifications';
  static const String messages = '/messages';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen());
      case onboarding:
        return _buildRoute(const OnboardingScreen());
      case goalSelection:
        return _buildRoute(const GoalSelectionScreen());
      case interestSelection:
        return _buildRoute(const InterestSelectionScreen());
      case login:
        return _buildRoute(const LoginScreen());
      case signup:
        return _buildRoute(const SignupScreen());
      case main:
        return _buildRoute(const MainScreen());
      case home:
        return _buildRoute(const HomeScreen());
      case createPost:
        return _buildRoute(const CreatePostScreen());
      case postDetail:
        final postId = settings.arguments as String;
        return _buildRoute(PostDetailScreen(postId: postId));
      case quizList:
        return _buildRoute(const QuizListScreen());
      case quizDetail:
        final quizId = settings.arguments as String;
        return _buildRoute(QuizDetailScreen(quizId: quizId));
      case quizAttempt:
        final quizId = settings.arguments as String;
        return _buildRoute(QuizAttemptScreen(quizId: quizId));
      case quizResult:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(QuizResultScreen(
          quizId: args['quizId'],
          score: args['score'],
          totalQuestions: args['totalQuestions'],
          timeTaken: args['timeTaken'],
        ));
      case learn:
        return _buildRoute(const LearnScreen());
      case courseDetail:
        final courseId = settings.arguments as String;
        return _buildRoute(CourseDetailScreen(courseId: courseId));
      case videoPlayer:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(VideoPlayerScreen(
          courseId: args['courseId'] ?? '',
          lessonId: args['lessonId'] ?? '',
          videoUrl: args['videoUrl'],
          title: args['title'] ?? 'Video',
          moduleTitle: args['moduleTitle'],
        ));
      case rank:
        return _buildRoute(const RankScreen());
      case opportunities:
        return _buildRoute(const OpportunityScreen());
      case opportunityDetail:
        final opportunityId = settings.arguments as String;
        return _buildRoute(
            OpportunityDetailScreen(opportunityId: opportunityId));
      case more:
        return _buildRoute(const MoreScreen());
      case applicationTracker:
        return _buildRoute(const ApplicationTrackerScreen());
      case subscription:
        return _buildRoute(const SubscriptionScreen());
      case events:
        return _buildRoute(const EventsScreen());
      case eventDetail:
        final eventId = settings.arguments as String;
        return _buildRoute(EventDetailScreen(eventId: eventId));
      case community:
        return _buildRoute(const CommunityScreen());
      case communityDetail:
        final communityId = settings.arguments as String;
        return _buildRoute(CommunityDetailScreen(communityId: communityId));
      case aiAssistant:
        return _buildRoute(const AIAssistantScreen());
      case aiChat:
        final featureType = settings.arguments as AIFeatureType;
        return _buildRoute(AIChatScreen(featureType: featureType));
      case appSettings:
        return _buildRoute(const SettingsScreen());
      case profile:
        final userId = settings.arguments as String? ?? '';
        return _buildRoute(EnhancedProfileScreen(userId: userId));
      case enhancedProfile:
        final userId = settings.arguments as String? ?? '';
        return _buildRoute(EnhancedProfileScreen(userId: userId));
      case editProfile:
        return _buildRoute(const EditProfileScreen());
      case achievements:
        return _buildRoute(const AchievementsScreen());
      case themeCustomization:
        return _buildRoute(const ThemeCustomizationScreen());
      case goals:
        return _buildRoute(const GoalsScreen());
      case analytics:
        return _buildRoute(const AnalyticsDashboardScreen());
      case friends:
        return _buildRoute(const FriendsListScreen());
      case reportCard:
        return _buildRoute(const ReportCardScreen());
      case notifications:
        return _buildRoute(const NotificationsScreen());
      case messages:
        return _buildRoute(const MessagesScreen());
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
