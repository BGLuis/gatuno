import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../atoms/app_clickable_action.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final ValueChanged<int> onPageChanged;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPageNumbers(context),
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context) {
    final List<Widget> items = [];
    final List<int> pages = [];

    // Always include first page
    pages.add(1);

    // Range around current page
    for (int i = currentPage - 2; i <= currentPage + 2; i++) {
      if (i > 1 && i < totalPages) {
        pages.add(i);
      }
    }

    // Always include last page
    if (totalPages > 1) {
      pages.add(totalPages);
    }

    // Sort and remove duplicates
    final uniquePages = pages.toSet().toList()..sort();

    for (int i = 0; i < uniquePages.length; i++) {
      final page = uniquePages[i];

      // Add ellipsis if there's a gap
      if (i > 0 && page - uniquePages[i - 1] > 1) {
        items.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...'),
          ),
        );
      }

      items.add(
        _PageButton(
          page: page,
          isSelected: page == currentPage,
          isLoading: isLoading && page == currentPage,
          onTap: () => onPageChanged(page),
        ),
      );
    }

    return items;
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _PageButton({
    required this.page,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AppClickableAction(
        tooltip: l10n.commonPage(page),
        padding: EdgeInsets.zero,
        onPressed: isSelected ? null : onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : null,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isSelected ? theme.colorScheme.onPrimary : null,
                  ),
                )
              : Text(
                  '$page',
                  style: TextStyle(
                    color: isSelected ? theme.colorScheme.onPrimary : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
        ),
      ),
    );
  }
}
