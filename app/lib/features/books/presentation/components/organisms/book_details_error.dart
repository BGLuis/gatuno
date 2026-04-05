import 'package:flutter/material.dart';
import '../molecules/book_error_view.dart';

class BookDetailsError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const BookDetailsError({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BookErrorView(error: error, onRetry: onRetry),
    );
  }
}
