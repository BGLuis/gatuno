import 'package:flutter/material.dart';
import 'app_clickable_action.dart';

class AppNavBarItem extends StatelessWidget {
  final Widget icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const AppNavBarItem({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: AppClickableAction(
        tooltip: tooltip,
        onPressed: onTap,
        child: IconTheme(
          data: IconThemeData(color: color, size: 28),
          child: icon,
        ),
      ),
    );
  }
}
