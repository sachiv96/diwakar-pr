import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_avatar.dart';

class Conversation {
  final String id;
  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime time;
  final int unreadCount;
  final bool isOnline;
  final bool isGroup;

  Conversation({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    this.isGroup = false,
  });
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<Conversation> _conversations = [
    Conversation(
      id: '1',
      name: 'Sarah Johnson',
      avatarUrl: null,
      lastMessage: 'Hey! Did you complete the Flutter quiz?',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      isOnline: true,
    ),
    Conversation(
      id: '2',
      name: 'Mike Chen',
      avatarUrl: null,
      lastMessage: 'Thanks for the help with the project!',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      isOnline: true,
    ),
    Conversation(
      id: '3',
      name: 'Emma Wilson',
      avatarUrl: null,
      lastMessage: 'See you at the study group tomorrow',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 0,
      isOnline: false,
    ),
    Conversation(
      id: '4',
      name: 'Study Group - Flutter',
      avatarUrl: null,
      lastMessage: 'Alex: Great session today everyone!',
      time: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 5,
      isOnline: false,
      isGroup: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: _conversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64, color: AppColors.textSecondaryLight),
                  const SizedBox(height: 16),
                  const Text('No messages yet',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Start a conversation with your peers!',
                      style: TextStyle(color: AppColors.textSecondaryLight)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return _buildConversationTile(conversation);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                conversation.isGroup
                    ? Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.group, color: AppColors.primary),
                      )
                    : CustomAvatar(
                        imageUrl: conversation.avatarUrl,
                        name: conversation.name,
                        size: 56),
                if (conversation.isOnline && !conversation.isGroup)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
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
                          conversation.name,
                          style: TextStyle(
                              fontWeight: conversation.unreadCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(conversation.time),
                        style: TextStyle(
                          color: conversation.unreadCount > 0
                              ? AppColors.primary
                              : AppColors.textSecondaryLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: TextStyle(
                            color: conversation.unreadCount > 0
                                ? AppColors.textPrimaryLight
                                : AppColors.textSecondaryLight,
                            fontSize: 14,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text('${conversation.unreadCount}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${time.day}/${time.month}';
  }
}
