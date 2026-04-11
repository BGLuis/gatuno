import 'package:flutter/material.dart';

class AppClickableAction extends StatelessWidget {
  final Widget child;
  final String tooltip;
  final VoidCallback? onPressed;
  final EdgeInsets padding;

  const AppClickableAction({
    super.key,
    required this.child,
    required this.tooltip,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onPressed != null,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: padding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
