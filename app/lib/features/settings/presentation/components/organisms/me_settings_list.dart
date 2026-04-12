import 'package:flutter/material.dart';

class MeSettingsList extends StatelessWidget {
  final Widget logoutButton;

  const MeSettingsList({super.key, required this.logoutButton});

  @override
  Widget build(BuildContext context) {
    return Column(children: [const SizedBox(height: 32), logoutButton]);
  }
}
