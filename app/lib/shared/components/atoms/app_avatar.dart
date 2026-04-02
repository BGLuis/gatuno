import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const AppAvatar({super.key, required this.name, this.radius = 50});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
