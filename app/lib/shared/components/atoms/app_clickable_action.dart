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
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: Material(
          type: MaterialType.transparency,
          child: InkResponse(
            onTap: onPressed,
            radius: 24,
            child: Padding(
              padding: padding,
              child: Center(widthFactor: 1.0, heightFactor: 1.0, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
