import 'package:flutter/material.dart';
import '../atoms/book_description.dart';
import '../atoms/book_title.dart';

class BookInfo extends StatelessWidget {
  final String title;
  final String? description;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final int titleMaxLines;
  final int descriptionMaxLines;
  final double spacing;

  const BookInfo({
    super.key,
    required this.title,
    this.description,
    this.titleStyle,
    this.descriptionStyle,
    this.titleMaxLines = 2,
    this.descriptionMaxLines = 3,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookTitle(title: title, style: titleStyle, maxLines: titleMaxLines),
        if (description != null && description!.isNotEmpty) ...[
          SizedBox(height: spacing),
          Flexible(
            child: BookDescription(
              description: description!,
              style: descriptionStyle,
              maxLines: descriptionMaxLines,
            ),
          ),
        ],
      ],
    );
  }
}
