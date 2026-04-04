import 'package:flutter/material.dart';

class BooksFilterAction extends StatelessWidget {
  final VoidCallback onPressed;

  const BooksFilterAction({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: onPressed,
    );
  }
}
