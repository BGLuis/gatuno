import 'package:flutter/material.dart';

class AppTextSkeleton extends StatelessWidget {
  final String? text;
  final double width;
  final double height;
  final TextStyle? style;
  final TextAlign? textAlign;

  const AppTextSkeleton({
    super.key,
    this.text,
    required this.width,
    required this.height,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return Text(text!, style: style, textAlign: textAlign);
  }
}
