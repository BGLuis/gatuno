import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';

class BooksFilterHeader extends StatelessWidget {
  final VoidCallback onClear;

  const BooksFilterHeader({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l10n.booksFilterTitle, style: theme.textTheme.titleLarge),
        TextButton(onPressed: onClear, child: Text(l10n.booksClearFilters)),
      ],
    );
  }
}
