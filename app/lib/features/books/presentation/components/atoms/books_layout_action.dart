import 'package:flutter/material.dart';
import '../../view_models/books_view_model.dart';

class BooksLayoutAction extends StatelessWidget {
  final BooksLayoutMode layoutMode;
  final VoidCallback onPressed;

  const BooksLayoutAction({
    super.key,
    required this.layoutMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        layoutMode == BooksLayoutMode.grid ? Icons.view_list : Icons.grid_view,
      ),
      onPressed: onPressed,
    );
  }
}
