import 'package:flutter/material.dart';

class AppClickableAction extends StatelessWidget {
  final Widget child;
  final String tooltip;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  const AppClickableAction({
    super.key,
    required this.child,
    required this.tooltip,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Tooltip(
        message: tooltip,
        child: Padding(
          padding: padding,
          child: Center(child: child),
        ),
      ),
    );
  }
}
