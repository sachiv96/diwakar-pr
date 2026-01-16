import 'package:cloud_firestore/cloud_firestore.dart';

enum EventType {
  hackathon,
  webinar,
  workshop,
  meetup,
  competition,
  conference,
}

enum EventStatus {
  upcoming,
  live,
  completed,
  cancelled,
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final String organizer;
  final String organizerLogo;
  final EventType type;
  final EventStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final bool isOnline;
  final String? meetingLink;
  final String coverImage;
  final int registeredCount;
  final int maxParticipants;
  final List<String> tags;
  final String? prizePool;
  final bool isFree;
  final double? price;
  final List<String> speakers;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizer,
    required this.organizerLogo,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.location,
    required this.isOnline,
    this.meetingLink,
    required this.coverImage,
    required this.registeredCount,
    required this.maxParticipants,
    required this.tags,
    this.prizePool,
    required this.isFree,
    this.price,
    required this.speakers,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String id) {
    return EventModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      organizer: json['organizer'] ?? '',
      organizerLogo: json['organizerLogo'] ?? '',
      type: EventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EventType.webinar,
      ),
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.upcoming,
      ),
      startDate: (json['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (json['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: json['location'],
      isOnline: json['isOnline'] ?? true,
      meetingLink: json['meetingLink'],
      coverImage: json['coverImage'] ?? '',
      registeredCount: json['registeredCount'] ?? 0,
      maxParticipants: json['maxParticipants'] ?? 100,
      tags: List<String>.from(json['tags'] ?? []),
      prizePool: json['prizePool'],
      isFree: json['isFree'] ?? true,
      price: (json['price'] as num?)?.toDouble(),
      speakers: List<String>.from(json['speakers'] ?? []),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'organizer': organizer,
      'organizerLogo': organizerLogo,
      'type': type.name,
      'status': status.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'isOnline': isOnline,
      'meetingLink': meetingLink,
      'coverImage': coverImage,
      'registeredCount': registeredCount,
      'maxParticipants': maxParticipants,
      'tags': tags,
      'prizePool': prizePool,
      'isFree': isFree,
      'price': price,
      'speakers': speakers,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get typeLabel {
    switch (type) {
      case EventType.hackathon:
        return 'Hackathon';
      case EventType.webinar:
        return 'Webinar';
      case EventType.workshop:
        return 'Workshop';
      case EventType.meetup:
        return 'Meetup';
      case EventType.competition:
        return 'Competition';
      case EventType.conference:
        return 'Conference';
    }
  }

  String get typeEmoji {
    switch (type) {
      case EventType.hackathon:
        return '💻';
      case EventType.webinar:
        return '🎥';
      case EventType.workshop:
        return '🛠️';
      case EventType.meetup:
        return '🤝';
      case EventType.competition:
        return '🏆';
      case EventType.conference:
        return '🎤';
    }
  }

  bool get isLive => status == EventStatus.live;
  bool get isUpcoming => status == EventStatus.upcoming;
  bool get isFull => registeredCount >= maxParticipants;
}
