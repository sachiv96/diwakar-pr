import 'package:flutter/foundation.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<EventModel> get liveEvents =>
      _events.where((e) => e.status == EventStatus.live).toList();

  List<EventModel> get upcomingEvents =>
      _events.where((e) => e.status == EventStatus.upcoming).toList();

  List<EventModel> get hackathons =>
      _events.where((e) => e.type == EventType.hackathon).toList();

  List<EventModel> get webinars =>
      _events.where((e) => e.type == EventType.webinar).toList();

  EventProvider() {
    _loadDummyEvents();
  }

  void _loadDummyEvents() {
    _isLoading = true;
    notifyListeners();

    _events = [
      EventModel(
        id: '1',
        title: 'HackIndia 2026',
        description:
            'India\'s largest student hackathon! Build innovative solutions for real-world problems. Open to all college students across India. Form teams of 2-4 members and compete for amazing prizes.',
        organizer: 'TechCommunity India',
        organizerLogo: '',
        type: EventType.hackathon,
        status: EventStatus.live,
        startDate: DateTime.now().subtract(const Duration(hours: 6)),
        endDate: DateTime.now().add(const Duration(hours: 42)),
        location: 'IIT Bombay, Mumbai',
        isOnline: false,
        coverImage: '',
        registeredCount: 2456,
        maxParticipants: 3000,
        tags: ['AI/ML', 'Web3', 'FinTech', 'HealthTech'],
        prizePool: '₹10,00,000',
        isFree: true,
        speakers: ['Sundar Pichai', 'Satya Nadella'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      EventModel(
        id: '2',
        title: 'Flutter Forward Extended',
        description:
            'Join us for Flutter Forward Extended - a virtual event where we explore the latest in Flutter development. Learn from Google Developer Experts and build your first Flutter app!',
        organizer: 'GDG Bangalore',
        organizerLogo: '',
        type: EventType.webinar,
        status: EventStatus.live,
        startDate: DateTime.now().subtract(const Duration(minutes: 30)),
        endDate: DateTime.now().add(const Duration(hours: 2)),
        isOnline: true,
        meetingLink: 'https://meet.google.com/abc-defg-hij',
        coverImage: '',
        registeredCount: 856,
        maxParticipants: 1000,
        tags: ['Flutter', 'Dart', 'Mobile Dev'],
        isFree: true,
        speakers: ['Pooja Bhaumik', 'Pawan Kumar'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      EventModel(
        id: '3',
        title: 'System Design Workshop',
        description:
            'A comprehensive 3-hour workshop on System Design fundamentals. Learn how to design scalable systems, understand CAP theorem, and ace your tech interviews.',
        organizer: 'CodeChef',
        organizerLogo: '',
        type: EventType.workshop,
        status: EventStatus.live,
        startDate: DateTime.now().subtract(const Duration(hours: 1)),
        endDate: DateTime.now().add(const Duration(hours: 2)),
        isOnline: true,
        meetingLink: 'https://zoom.us/j/123456789',
        coverImage: '',
        registeredCount: 342,
        maxParticipants: 500,
        tags: ['System Design', 'DSA', 'Interview Prep'],
        isFree: false,
        price: 299,
        speakers: ['Gaurav Sen'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      EventModel(
        id: '4',
        title: 'AWS Cloud Practitioner Bootcamp',
        description:
            'Get certified! A 2-day intensive bootcamp to prepare you for the AWS Cloud Practitioner certification. Includes hands-on labs and practice tests.',
        organizer: 'AWS User Group India',
        organizerLogo: '',
        type: EventType.workshop,
        status: EventStatus.upcoming,
        startDate: DateTime.now().add(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        isOnline: true,
        coverImage: '',
        registeredCount: 189,
        maxParticipants: 200,
        tags: ['AWS', 'Cloud', 'Certification'],
        isFree: false,
        price: 999,
        speakers: ['Abhishek Gupta', 'Sagar Arora'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      EventModel(
        id: '5',
        title: 'Google Summer of Code Info Session',
        description:
            'Learn everything about GSoC 2026! Understand how to apply, select organizations, write winning proposals, and tips from past GSoC students.',
        organizer: 'Google Developer Student Clubs',
        organizerLogo: '',
        type: EventType.webinar,
        status: EventStatus.upcoming,
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 2, hours: 2)),
        isOnline: true,
        coverImage: '',
        registeredCount: 1245,
        maxParticipants: 2000,
        tags: ['GSoC', 'Open Source', 'Career'],
        isFree: true,
        speakers: ['Previous GSoC Students', 'Org Mentors'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      EventModel(
        id: '6',
        title: 'Smart India Hackathon 2026',
        description:
            'The flagship hackathon by Government of India. Solve problem statements from various ministries and win exciting prizes. Only for Indian college students.',
        organizer: 'Ministry of Education, India',
        organizerLogo: '',
        type: EventType.hackathon,
        status: EventStatus.upcoming,
        startDate: DateTime.now().add(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 17)),
        location: 'Multiple Nodal Centers across India',
        isOnline: false,
        coverImage: '',
        registeredCount: 45000,
        maxParticipants: 100000,
        tags: ['Government', 'Innovation', 'Social Impact'],
        prizePool: '₹1 Crore+',
        isFree: true,
        speakers: [],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      EventModel(
        id: '7',
        title: 'React India Conference 2026',
        description:
            'The largest React conference in India! Two days of amazing talks, workshops, and networking with React developers from around the world.',
        organizer: 'React India',
        organizerLogo: '',
        type: EventType.conference,
        status: EventStatus.upcoming,
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 32)),
        location: 'Goa',
        isOnline: false,
        coverImage: '',
        registeredCount: 567,
        maxParticipants: 1500,
        tags: ['React', 'JavaScript', 'Frontend'],
        isFree: false,
        price: 4999,
        speakers: ['Dan Abramov', 'Kent C. Dodds', 'Tanner Linsley'],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      EventModel(
        id: '8',
        title: 'Delhi NCR Tech Meetup',
        description:
            'Monthly meetup for tech enthusiasts in Delhi NCR. This month\'s topic: AI in Production. Network with fellow developers over pizza and drinks!',
        organizer: 'Delhi Tech Community',
        organizerLogo: '',
        type: EventType.meetup,
        status: EventStatus.upcoming,
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 5, hours: 3)),
        location: '91Springboard, Gurgaon',
        isOnline: false,
        coverImage: '',
        registeredCount: 78,
        maxParticipants: 100,
        tags: ['Networking', 'AI', 'Community'],
        isFree: true,
        speakers: ['Local Tech Leaders'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  EventModel? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  List<EventModel> filterByType(EventType type) {
    return _events.where((e) => e.type == type).toList();
  }

  List<EventModel> searchEvents(String query) {
    if (query.isEmpty) return _events;
    final lowerQuery = query.toLowerCase();
    return _events.where((e) {
      return e.title.toLowerCase().contains(lowerQuery) ||
          e.description.toLowerCase().contains(lowerQuery) ||
          e.organizer.toLowerCase().contains(lowerQuery) ||
          e.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
