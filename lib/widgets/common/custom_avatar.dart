import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(
                  color: borderColor ?? AppColors.primary,
                  width: 2,
                )
              : null,
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final initial =
        name != null && name!.isNotEmpty ? name![0].toUpperCase() : '?';

    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class TopStudentAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final int rank;
  final int points;
  final double size;
  final VoidCallback? onTap;

  const TopStudentAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    required this.rank,
    required this.points,
    this.size = 80,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rankColors = {
      1: AppColors.gold,
      2: AppColors.silver,
      3: AppColors.bronze,
    };

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomAvatar(
                  imageUrl: imageUrl,
                  name: name,
                  size: size,
                  showBorder: true,
                  borderColor: rankColors[rank] ?? AppColors.primary,
                ),
                Positioned(
                  bottom: -5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: rankColors[rank] ?? AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '#$rank',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size + 16,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '$points pts',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
