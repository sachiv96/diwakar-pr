import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../home/home_screen.dart';
import '../quiz/quiz_list_screen.dart';
import '../learn/learn_screen.dart';
import '../rank/rank_screen.dart';
import '../more/more_screen.dart';
import '../profile/profile_info_sheet.dart';
import '../../widgets/common/custom_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuizListScreen(),
    LearnScreen(),
    RankScreen(),
    MoreScreen(),
  ];

  final List<String> _titles = const [
    'Home',
    'Quizzes',
    'Learn',
    'Rankings',
    'More',
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Initialize all data streams
    context.read<PostProvider>().listenToPosts();
    context.read<QuizProvider>().listenToQuizzes();
    context.read<CourseProvider>().listenToCourses();
    context.read<OpportunityProvider>().listenToOpportunities();
  }

  void _showProfileSheet() {
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ProfileInfoSheet(
          user: user,
          isOwnProfile: true, // This is your own profile
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: CustomAppBar(
        avatarUrl: user?.avatarUrl,
        userName: user?.name,
        onAvatarTap: _showProfileSheet,
        onNotificationTap: () {
          Navigator.pushNamed(context, AppRoutes.notifications);
        },
        onMessageTap: () {
          Navigator.pushNamed(context, AppRoutes.messages);
        },
        onSearchTap: () {
          // TODO: Implement search
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_outlined),
              activeIcon: Icon(Icons.quiz),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_outlined),
              activeIcon: Icon(Icons.leaderboard),
              label: 'Rank',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_rounded),
              activeIcon: Icon(Icons.menu_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
