import 'package:flutter/material.dart';
import 'package:gatuno/shared/components/atoms/app_avatar.dart';
import 'package:gatuno/shared/components/atoms/app_clickable_action.dart';

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
      child: AppAvatar(name: displayName, radius: 16),
    );
  }
}
