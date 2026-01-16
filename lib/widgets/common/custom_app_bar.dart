import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'custom_avatar.dart';
import 'custom_text_field.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? avatarUrl;
  final String? userName;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onSearchTap;
  final bool showSearch;

  const CustomAppBar({
    super.key,
    this.avatarUrl,
    this.userName,
    this.onAvatarTap,
    this.onNotificationTap,
    this.onMessageTap,
    this.onSearchTap,
    this.showSearch = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            CustomAvatar(
              imageUrl: avatarUrl,
              name: userName,
              size: 44,
              onTap: onAvatarTap,
            ),
            const SizedBox(width: 12),
            if (showSearch)
              Expanded(
                child: SearchTextField(
                  hintText: 'Search...',
                  onTap: onSearchTap,
                  readOnly: true,
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: 8),
            _buildIconButton(
              Icons.notifications_outlined,
              onNotificationTap,
              hasNotification: true,
            ),
            const SizedBox(width: 4),
            _buildIconButton(
              Icons.message_outlined,
              onMessageTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback? onTap, {
    bool hasNotification = false,
  }) {
    return Stack(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: AppColors.textPrimaryLight,
            size: 24,
          ),
        ),
        if (hasNotification)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final bool centerTitle;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                )
              : null),
      actions: actions,
    );
  }
}
