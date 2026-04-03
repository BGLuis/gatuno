import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const AppAvatar({super.key, required this.name, this.radius = 50});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primary,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
