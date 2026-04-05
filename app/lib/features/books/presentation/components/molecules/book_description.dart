import 'package:flutter/material.dart';

class BookDescription extends StatelessWidget {
  final String? description;

  const BookDescription({super.key, this.description});

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        description!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
