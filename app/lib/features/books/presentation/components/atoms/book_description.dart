import 'package:flutter/material.dart';

class BookDescription extends StatelessWidget {
  final String description;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;

  const BookDescription({
    super.key,
    required this.description,
    this.style,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }
}
