import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../atoms/app_nav_bar_item.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isAuthenticated;
  final String? displayName;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isAuthenticated,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color:
                Theme.of(context).dividerTheme.color ??
                Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 48,
        padding: EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppNavBarItem(
              icon: const Icon(Icons.home),
              tooltip: l10n.homeTitle,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            AppNavBarItem(
              icon: const Icon(Icons.book),
              tooltip: l10n.booksTitle,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            AppNavBarItem(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}
