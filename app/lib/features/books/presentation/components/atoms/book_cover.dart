import 'package:flutter/material.dart';
import '../../../../../shared/components/atoms/app_image.dart';
import '../../../../../shared/components/atoms/app_skeleton.dart';

class BookCover extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final double iconSize;
  final bool usePlaceholderIfNull;

  const BookCover({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 4,
    this.iconSize = 24,
    this.usePlaceholderIfNull = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content;

    if (imageUrl != null) {
      content = AppImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorWidget: Icon(Icons.book, size: iconSize),
      );
    } else if (usePlaceholderIfNull) {
      content = SizedBox(
        width: width,
        height: height,
        child: Center(child: Icon(Icons.book, size: iconSize)),
      );
    } else {
      content = AppSkeleton(width: width, height: height);
    }

    if (borderRadius <= 0) return content;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: content,
    );
  }
}
