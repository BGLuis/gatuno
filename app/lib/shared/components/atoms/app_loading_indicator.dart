import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double? size;
  final double strokeWidth;
  final Color? color;

  const AppLoadingIndicator({
    super.key,
    this.size,
    this.strokeWidth = 2,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      color: color ?? Theme.of(context).colorScheme.primary,
    );

    if (size != null) {
      return SizedBox(height: size, width: size, child: indicator);
    }

    return indicator;
  }
}
