import 'package:flutter/material.dart';
import 'package:gatuno/shared/components/atoms/app_clickable_action.dart';

class LoginIcon extends StatelessWidget {
  final String tooltip;
  final VoidCallback onPressed;

  const LoginIcon({super.key, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppClickableAction(
      tooltip: tooltip,
      onPressed: onPressed,
      child: const Icon(Icons.login),
    );
  }
}
