import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum NotificationType { quiz, course, achievement, opportunity, social }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New Quiz Available',
      message: 'A new Flutter quiz has been added. Test your skills now!',
      type: NotificationType.quiz,
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Course Update',
      message: 'New lessons have been added to "Advanced Flutter Development"',
      type: NotificationType.course,
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Rank Improved!',
      message:
          'Congratulations! You moved up 5 positions in the national ranking.',
      type: NotificationType.achievement,
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'New Internship',
      message:
          'Google is hiring Flutter developers. Check out the opportunity!',
      type: NotificationType.opportunity,
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n.isRead = true;
                }
              });
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64, color: AppColors.textSecondaryLight),
                  const SizedBox(height: 16),
                  const Text('No notifications',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('You\'re all caught up!',
                      style: TextStyle(color: AppColors.textSecondaryLight)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationTile(notification);
              },
            ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
      },
      child: InkWell(
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.transparent
                : AppColors.primary.withOpacity(0.05),
            border:
                Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      _getNotificationColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notification.message,
                        style: TextStyle(
                            color: AppColors.textSecondaryLight, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(_formatTime(notification.time),
                        style: TextStyle(
                            color: AppColors.textSecondaryLight, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.quiz:
        return Icons.quiz;
      case NotificationType.course:
        return Icons.school;
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.opportunity:
        return Icons.work;
      case NotificationType.social:
        return Icons.person_add;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.quiz:
        return AppColors.primary;
      case NotificationType.course:
        return AppColors.secondary;
      case NotificationType.achievement:
        return AppColors.warning;
      case NotificationType.opportunity:
        return AppColors.accent;
      case NotificationType.social:
        return Colors.blue;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
