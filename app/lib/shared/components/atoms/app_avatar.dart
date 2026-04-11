import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppAvatar({
    super.key,
    this.name,
    this.radius = 50,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (name == null) {
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      );
    }

    final initials = name!.isNotEmpty ? name![0].toUpperCase() : '?';
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
