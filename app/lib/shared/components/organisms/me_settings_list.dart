import 'package:flutter/material.dart';
import '../atoms/app_switch.dart';

class MeSettingsList extends StatelessWidget {
  final String sensitiveContentTitle;
  final String sensitiveContentSubtitle;
  final bool isSensitiveContentEnabled;
  final ValueChanged<bool> onSensitiveContentChanged;
  final Widget logoutButton;

  const MeSettingsList({
    super.key,
    required this.sensitiveContentTitle,
    required this.sensitiveContentSubtitle,
    required this.isSensitiveContentEnabled,
    required this.onSensitiveContentChanged,
    required this.logoutButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        AppSwitch(
          title: sensitiveContentTitle,
          subtitle: sensitiveContentSubtitle,
          value: isSensitiveContentEnabled,
          onChanged: onSensitiveContentChanged,
        ),
        const Divider(),
        const SizedBox(height: 32),
        logoutButton,
      ],
    );
  }
}
