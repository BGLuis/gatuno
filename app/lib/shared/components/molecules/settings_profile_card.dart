import 'package:flutter/material.dart';
import '../atoms/app_avatar.dart';

class SettingsProfileCard extends StatelessWidget {
  final String name;
  final String? email;
  final VoidCallback onTap;

  const SettingsProfileCard({
    super.key,
    required this.name,
    this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      leading: AppAvatar(name: email != null ? name : null, radius: 24),
      title: Text(
        name,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: email != null
          ? Text(
              email!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
