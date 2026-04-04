import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';

class BooksYearFilter extends StatelessWidget {
  final String? operator;
  final TextEditingController yearController;
  final void Function(String?) onOperatorChanged;
  final void Function(String) onYearChanged;

  const BooksYearFilter({
    super.key,
    required this.operator,
    required this.yearController,
    required this.onOperatorChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.booksPublicationYear, style: theme.textTheme.titleMedium),
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: operator ?? 'eq',
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'lt',
                    child: Text(l10n.booksOperatorBefore),
                  ),
                  DropdownMenuItem(
                    value: 'gt',
                    child: Text(l10n.booksOperatorAfter),
                  ),
                  DropdownMenuItem(
                    value: 'eq',
                    child: Text(l10n.booksOperatorEqual),
                  ),
                  DropdownMenuItem(
                    value: 'lte',
                    child: Text(l10n.booksOperatorBeforeEqual),
                  ),
                  DropdownMenuItem(
                    value: 'gte',
                    child: Text(l10n.booksOperatorAfterEqual),
                  ),
                ],
                onChanged: onOperatorChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '2026'),
                onChanged: onYearChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
