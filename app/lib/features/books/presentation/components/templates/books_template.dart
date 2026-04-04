import 'package:flutter/material.dart';

class BooksTemplate extends StatelessWidget {
  final Widget? appBar;
  final Widget body;

  const BooksTemplate({super.key, this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: appBar!,
            )
          : null,
      body: body,
    );
  }
}
