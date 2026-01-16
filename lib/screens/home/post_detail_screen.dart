import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../widgets/common/custom_avatar.dart';
import '../../models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();
  bool _isLoading = false;
  PostModel? _post;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadPost() async {
    setState(() => _isLoading = true);
    final postProvider = context.read<PostProvider>();
    // Find post from existing posts or load from server
    try {
      _post = postProvider.posts.firstWhere(
        (p) => p.id == widget.postId,
      );
    } catch (e) {
      if (postProvider.posts.isNotEmpty) {
        _post = postProvider.posts.first;
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    // TODO: Implement actual comment posting
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment posted!')),
    );
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final postProvider = context.watch<PostProvider>();

    if (_isLoading || _post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show post options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Post content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.profile,
                              arguments: _post!.authorId,
                            );
                          },
                          child: CustomAvatar(
                            imageUrl: _post!.authorAvatar,
                            name: _post!.authorName,
                            size: 48,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _post!.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (_post!.authorTitle != null)
                                Text(
                                  _post!.authorTitle!,
                                  style: TextStyle(
                                    color: AppColors.textSecondaryLight,
                                    fontSize: 13,
                                  ),
                                ),
                              Text(
                                _getTimeAgo(_post!.createdAt),
                                style: TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Post content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _post!.content,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),

                  // Post images
                  if (_post!.mediaUrls.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: _post!.mediaUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(_post!.mediaUrls[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // Engagement stats
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildEngagementButton(
                          icon: _post!.likes.contains(user?.id)
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          count: _post!.likes.length,
                          color: _post!.likes.contains(user?.id)
                              ? AppColors.primary
                              : null,
                          onTap: () {
                            postProvider.toggleLike(_post!.id, user?.id ?? '');
                          },
                        ),
                        const SizedBox(width: 24),
                        _buildEngagementButton(
                          icon: Icons.chat_bubble_outline,
                          count: _post!.commentsCount,
                          onTap: () {
                            // Focus comment field
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                        const SizedBox(width: 24),
                        _buildEngagementButton(
                          icon: Icons.share_outlined,
                          count: 0, // shares not tracked yet
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Share coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Comments section header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Comments (${_post!.commentsCount})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Sample comments - TODO: Load from server
                  _buildCommentItem(
                    name: 'Sarah M.',
                    avatar: null,
                    content:
                        'Congrats! Which module was the most helpful for you?',
                    time: '2h ago',
                    likes: 12,
                  ),
                  _buildCommentItem(
                    name: 'John Doe',
                    avatar: _post!.authorAvatar,
                    content: 'The hooks section was amazing!',
                    time: '1h ago',
                    likes: 5,
                    isReply: true,
                  ),
                  _buildCommentItem(
                    name: 'Rahul K.',
                    avatar: null,
                    content: 'Great progress! Keep it up 🔥',
                    time: '45m ago',
                    likes: 3,
                  ),

                  const SizedBox(height: 80), // Space for comment input
                ],
              ),
            ),
          ),

          // Comment input
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                CustomAvatar(
                  imageUrl: user?.avatarUrl,
                  name: user?.name,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(color: AppColors.textSecondaryLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: Icon(
                    Icons.send,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementButton({
    required IconData icon,
    required int count,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: color ?? AppColors.textSecondaryLight),
          const SizedBox(width: 6),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 14,
              color: color ?? AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem({
    required String name,
    String? avatar,
    required String content,
    required String time,
    required int likes,
    bool isReply = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 56 : 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAvatar(
            imageUrl: avatar,
            name: name,
            size: isReply ? 32 : 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 14,
                            color: AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$likes',
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
