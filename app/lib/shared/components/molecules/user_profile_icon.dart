import 'package:flutter/material.dart';
import '../atoms/app_avatar.dart';
import '../atoms/app_clickable_action.dart';

class UserProfileIcon extends StatelessWidget {
  final String? displayName;
  final String tooltip;
  final VoidCallback onPressed;

  const UserProfileIcon({
    super.key,
    required this.displayName,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppClickableAction(
      tooltip: tooltip,
      onPressed: onPressed,
      child: displayName != null
          ? AppAvatar(name: displayName!, radius: 16)
          : Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
    );
  }
}
