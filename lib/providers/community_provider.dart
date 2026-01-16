import 'package:flutter/foundation.dart';
import '../models/community_model.dart';

class CommunityProvider with ChangeNotifier {
  final List<CommunityModel> _communities = [
    CommunityModel(
      id: 'c1',
      name: 'Flutter Developers India',
      description:
          'A community of Flutter developers from India. Share projects, get help, discuss new features, and connect with fellow devs building amazing mobile apps.',
      coverImage: '',
      iconEmoji: '💙',
      type: CommunityType.skillBased,
      memberCount: 12580,
      postCount: 3420,
      isPrivate: false,
      isVerified: true,
      tags: ['Flutter', 'Dart', 'Mobile Dev', 'UI/UX'],
      admins: ['admin1'],
      isJoined: true,
      createdAt: DateTime(2024, 1, 15),
    ),
    CommunityModel(
      id: 'c2',
      name: 'DSA Warriors',
      description:
          'Master Data Structures and Algorithms together! Daily problems, solutions discussions, interview prep, and competitive programming tips.',
      coverImage: '',
      iconEmoji: '⚔️',
      type: CommunityType.studyGroup,
      memberCount: 28450,
      postCount: 8920,
      isPrivate: false,
      isVerified: true,
      tags: ['DSA', 'LeetCode', 'Competitive Programming', 'Interview Prep'],
      admins: ['admin2'],
      isJoined: true,
      createdAt: DateTime(2023, 6, 20),
    ),
    CommunityModel(
      id: 'c3',
      name: 'IIT Delhi Tech Club',
      description:
          'Official tech community of IIT Delhi. Hackathons, workshops, tech talks, and networking opportunities for IIT-D students.',
      coverImage: '',
      iconEmoji: '🏛️',
      type: CommunityType.college,
      memberCount: 5680,
      postCount: 1250,
      isPrivate: true,
      isVerified: true,
      tags: ['IIT Delhi', 'Tech Club', 'Hackathons', 'Workshops'],
      admins: ['admin3'],
      college: 'IIT Delhi',
      isJoined: false,
      createdAt: DateTime(2022, 8, 1),
    ),
    CommunityModel(
      id: 'c4',
      name: 'AI/ML Enthusiasts',
      description:
          'Explore the world of Artificial Intelligence and Machine Learning. Research papers, project showcases, career guidance, and more.',
      coverImage: '',
      iconEmoji: '🤖',
      type: CommunityType.skillBased,
      memberCount: 19320,
      postCount: 4560,
      isPrivate: false,
      isVerified: true,
      tags: [
        'AI',
        'Machine Learning',
        'Deep Learning',
        'NLP',
        'Computer Vision'
      ],
      admins: ['admin4'],
      isJoined: false,
      createdAt: DateTime(2023, 3, 10),
    ),
    CommunityModel(
      id: 'c5',
      name: 'Startup Founders Circle',
      description:
          'Connect with student entrepreneurs, share your startup journey, get feedback, find co-founders, and learn from successful founders.',
      coverImage: '',
      iconEmoji: '🚀',
      type: CommunityType.interest,
      memberCount: 8920,
      postCount: 2340,
      isPrivate: false,
      isVerified: false,
      tags: ['Startups', 'Entrepreneurship', 'Business', 'Networking'],
      admins: ['admin5'],
      isJoined: false,
      createdAt: DateTime(2024, 2, 28),
    ),
    CommunityModel(
      id: 'c6',
      name: 'Google Developer Group',
      description:
          'Official GDG community. Learn about Google technologies, attend events, participate in codelabs, and connect with Google experts.',
      coverImage: '',
      iconEmoji: '🔵',
      type: CommunityType.official,
      memberCount: 34560,
      postCount: 7890,
      isPrivate: false,
      isVerified: true,
      tags: ['Google', 'Android', 'Cloud', 'Firebase', 'GDG'],
      admins: ['admin6'],
      isJoined: true,
      createdAt: DateTime(2021, 5, 15),
    ),
    CommunityModel(
      id: 'c7',
      name: 'Web Development Hub',
      description:
          'Everything web dev! Frontend, backend, full-stack. React, Vue, Node, Django - discuss, share resources, and grow together.',
      coverImage: '',
      iconEmoji: '🌐',
      type: CommunityType.skillBased,
      memberCount: 22140,
      postCount: 6780,
      isPrivate: false,
      isVerified: true,
      tags: ['Web Dev', 'React', 'Node.js', 'Frontend', 'Backend'],
      admins: ['admin7'],
      isJoined: false,
      createdAt: DateTime(2023, 1, 5),
    ),
    CommunityModel(
      id: 'c8',
      name: 'Career Mentorship Hub',
      description:
          'Get mentored by industry professionals. Resume reviews, mock interviews, career guidance, and 1:1 mentorship sessions.',
      coverImage: '',
      iconEmoji: '🎯',
      type: CommunityType.mentorship,
      memberCount: 15670,
      postCount: 3210,
      isPrivate: false,
      isVerified: true,
      tags: ['Mentorship', 'Career', 'Interview Prep', 'Resume'],
      admins: ['admin8'],
      isJoined: true,
      createdAt: DateTime(2023, 9, 12),
    ),
  ];

  final List<MentorModel> _mentors = [
    MentorModel(
      id: 'm1',
      name: 'Priya Sharma',
      title: 'Senior Software Engineer',
      company: 'Google',
      avatarUrl: '',
      bio:
          '8+ years in tech. Ex-Microsoft. Passionate about helping students crack FAANG interviews and build amazing products.',
      expertise: ['System Design', 'DSA', 'Interview Prep', 'Career Guidance'],
      rating: 4.9,
      reviewCount: 156,
      sessionsCompleted: 320,
      hourlyRate: 1500,
      isAvailable: true,
      availableSlots: ['Mon 6PM', 'Wed 7PM', 'Sat 10AM'],
    ),
    MentorModel(
      id: 'm2',
      name: 'Rahul Verma',
      title: 'Engineering Manager',
      company: 'Amazon',
      avatarUrl: '',
      bio:
          'Leading teams at Amazon for 5 years. Expert in system design, leadership, and scaling products to millions.',
      expertise: ['System Design', 'Leadership', 'Backend', 'AWS'],
      rating: 4.8,
      reviewCount: 98,
      sessionsCompleted: 180,
      hourlyRate: 2000,
      isAvailable: true,
      availableSlots: ['Tue 8PM', 'Thu 8PM', 'Sun 11AM'],
    ),
    MentorModel(
      id: 'm3',
      name: 'Ananya Gupta',
      title: 'ML Engineer',
      company: 'Meta',
      avatarUrl: '',
      bio:
          'PhD in ML from IIT Bombay. Working on cutting-edge AI at Meta. Love teaching and helping students break into AI/ML.',
      expertise: ['Machine Learning', 'Deep Learning', 'Python', 'Research'],
      rating: 4.95,
      reviewCount: 72,
      sessionsCompleted: 145,
      hourlyRate: 1800,
      isAvailable: false,
      availableSlots: [],
    ),
    MentorModel(
      id: 'm4',
      name: 'Vikram Singh',
      title: 'Staff Engineer',
      company: 'Flipkart',
      avatarUrl: '',
      bio:
          '10+ years building scalable systems. Expert in distributed systems, microservices, and high-performance computing.',
      expertise: ['Distributed Systems', 'Microservices', 'Java', 'Kotlin'],
      rating: 4.7,
      reviewCount: 134,
      sessionsCompleted: 256,
      hourlyRate: 1200,
      isAvailable: true,
      availableSlots: ['Mon 7PM', 'Fri 6PM', 'Sat 3PM'],
    ),
    MentorModel(
      id: 'm5',
      name: 'Sneha Patel',
      title: 'Product Manager',
      company: 'Razorpay',
      avatarUrl: '',
      bio:
          'Transitioned from engineering to PM. Helping aspiring PMs crack interviews and build product thinking skills.',
      expertise: ['Product Management', 'Strategy', 'Analytics', 'Roadmapping'],
      rating: 4.85,
      reviewCount: 89,
      sessionsCompleted: 167,
      hourlyRate: 1600,
      isAvailable: true,
      availableSlots: ['Wed 6PM', 'Sat 11AM', 'Sun 4PM'],
    ),
  ];

  List<CommunityModel> get communities => _communities;
  List<MentorModel> get mentors => _mentors;

  List<CommunityModel> get joinedCommunities =>
      _communities.where((c) => c.isJoined).toList();

  List<CommunityModel> get suggestedCommunities =>
      _communities.where((c) => !c.isJoined).toList();

  List<CommunityModel> get verifiedCommunities =>
      _communities.where((c) => c.isVerified).toList();

  List<MentorModel> get availableMentors =>
      _mentors.where((m) => m.isAvailable).toList();

  List<MentorModel> get topMentors {
    final sorted = List<MentorModel>.from(_mentors)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }

  CommunityModel? getCommunityById(String id) {
    try {
      return _communities.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  MentorModel? getMentorById(String id) {
    try {
      return _mentors.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  List<CommunityModel> filterByType(CommunityType type) {
    return _communities.where((c) => c.type == type).toList();
  }

  List<CommunityModel> searchCommunities(String query) {
    final lowerQuery = query.toLowerCase();
    return _communities.where((c) {
      return c.name.toLowerCase().contains(lowerQuery) ||
          c.description.toLowerCase().contains(lowerQuery) ||
          c.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  List<MentorModel> searchMentors(String query) {
    final lowerQuery = query.toLowerCase();
    return _mentors.where((m) {
      return m.name.toLowerCase().contains(lowerQuery) ||
          m.title.toLowerCase().contains(lowerQuery) ||
          m.company.toLowerCase().contains(lowerQuery) ||
          m.expertise.any((e) => e.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  void toggleJoinCommunity(String id) {
    final index = _communities.indexWhere((c) => c.id == id);
    if (index != -1) {
      final community = _communities[index];
      _communities[index] = community.copyWith(
        isJoined: !community.isJoined,
        memberCount: community.isJoined
            ? community.memberCount - 1
            : community.memberCount + 1,
      );
      notifyListeners();
    }
  }
}
