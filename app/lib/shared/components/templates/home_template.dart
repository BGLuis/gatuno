import 'package:flutter/material.dart';

class HomeTemplate extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  const HomeTemplate({super.key, required this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar, body: body);
  }
}
