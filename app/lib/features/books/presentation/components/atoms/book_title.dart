import 'package:flutter/material.dart';

class BookTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;

  const BookTitle({
    super.key,
    required this.title,
    this.style,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title, maxLines: maxLines, overflow: overflow, style: style);
  }
}
