import 'package:flutter/material.dart';

class BookDetailsLoading extends StatelessWidget {
  const BookDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
