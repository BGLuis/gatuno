import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';

class BooksSensitiveContentFilter extends StatelessWidget {
  final List<String>? selectedContent;
  final void Function(String, bool) onSelected;

  const BooksSensitiveContentFilter({
    super.key,
    required this.selectedContent,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.booksSensitiveContent, style: theme.textTheme.titleMedium),
        Wrap(
          spacing: 8,
          children: ['Safe', 'Ecchi', 'Gore'].map((tag) {
            final isSelected = selectedContent?.contains(tag) ?? false;
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) => onSelected(tag, selected),
            );
          }).toList(),
        ),
      ],
    );
  }
}
