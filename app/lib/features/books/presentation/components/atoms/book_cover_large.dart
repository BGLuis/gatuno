import 'package:flutter/material.dart';
import 'package:gatuno/features/books/presentation/components/atoms/book_cover.dart';

class BookCoverLarge extends StatelessWidget {
  final String? coverUrl;
  final double width;
  final double height;

  const BookCoverLarge({
    super.key,
    this.coverUrl,
    this.width = 240,
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BookCover(
        imageUrl: coverUrl,
        width: width,
        height: height,
        borderRadius: 16,
        iconSize: 64,
        usePlaceholderIfNull: true,
      ),
    );
  }
}
