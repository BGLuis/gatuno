import 'package:flutter/material.dart';
import '../atoms/app_avatar.dart';

class UserProfileHeader extends StatelessWidget {
  final String displayName;
  final String email;

  const UserProfileHeader({
    super.key,
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAvatar(name: displayName),
        const SizedBox(height: 16),
        Text(
          displayName,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          email,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
