import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';
import '../common/custom_avatar.dart';
import '../../models/post_model.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final String currentUserId;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMoreTap;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onProfileTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = post.isLikedBy(currentUserId);
    final timeAgo = _getTimeAgo(post.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomAvatar(
                  imageUrl: post.authorAvatar,
                  name: post.authorName,
                  size: 48,
                  onTap: onProfileTap,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (post.authorTitle != null)
                        Text(
                          post.authorTitle!,
                          style: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onMoreTap,
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              post.content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),

            // Media
            if (post.mediaUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: post.mediaUrls.length == 1
                    ? CachedNetworkImage(
                        imageUrl: post.mediaUrls.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: AppColors.backgroundLight,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : _buildImageGrid(),
              ),
            ],

            const SizedBox(height: 12),

            // Stats
            Row(
              children: [
                if (post.likesCount > 0) ...[
                  Icon(
                    Icons.thumb_up,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.likesCount}',
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                ],
                const Spacer(),
                if (post.commentsCount > 0)
                  Text(
                    '${post.commentsCount} comments',
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),

            const Divider(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: _buildActionButton(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    'Like',
                    isLiked ? AppColors.primary : AppColors.textSecondaryLight,
                    onLike,
                  ),
                ),
                Flexible(
                  child: _buildActionButton(
                    Icons.comment_outlined,
                    'Comment',
                    AppColors.textSecondaryLight,
                    onComment,
                  ),
                ),
                Flexible(
                  child: _buildActionButton(
                    Icons.share_outlined,
                    'Share',
                    AppColors.textSecondaryLight,
                    onShare,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: post.mediaUrls[0],
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          if (post.mediaUrls.length > 1) ...[
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: post.mediaUrls[1],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  if (post.mediaUrls.length > 2) ...[
                    const SizedBox(height: 4),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: post.mediaUrls[2],
                            fit: BoxFit.cover,
                          ),
                          if (post.mediaUrls.length > 3)
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                child: Text(
                                  '+${post.mediaUrls.length - 3}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
