import 'package:flutter/material.dart';
import '../molecules/user_profile_icon.dart';
import '../molecules/login_icon.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isAuthenticated;
  final bool isLoading;
  final String? displayName;
  final VoidCallback onProfilePressed;
  final VoidCallback onSignInPressed;
  final String profileTooltip;
  final String signInTooltip;

  const HomeAppBar({
    super.key,
    required this.title,
    required this.isAuthenticated,
    required this.isLoading,
    required this.displayName,
    required this.onProfilePressed,
    required this.onSignInPressed,
    required this.profileTooltip,
    required this.signInTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        if (!isLoading)
          isAuthenticated
              ? UserProfileIcon(
                  displayName: displayName,
                  tooltip: profileTooltip,
                  onPressed: onProfilePressed,
                )
              : LoginIcon(tooltip: signInTooltip, onPressed: onSignInPressed),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
