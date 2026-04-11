import 'package:flutter/material.dart';
import '../atoms/app_avatar.dart';
import '../atoms/app_text_skeleton.dart';

class UserProfileHeader extends StatelessWidget {
  final String? displayName;
  final String? email;

  const UserProfileHeader({super.key, this.displayName, this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppAvatar(name: displayName),
        const SizedBox(height: 16),
        AppTextSkeleton(
          text: displayName,
          width: 150,
          height: 24,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        AppTextSkeleton(
          text: email,
          width: 200,
          height: 16,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
