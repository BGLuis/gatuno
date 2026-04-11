import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/shared/components/atoms/app_button.dart';

class BookActionButtons extends StatelessWidget {
  final VoidCallback onStartReading;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSyncPressed;

  const BookActionButtons({
    super.key,
    required this.onStartReading,
    this.onMenuPressed,
    this.onSyncPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: l10n.booksStartReading,
            onPressed: onStartReading,
          ),
        ),
        const SizedBox(width: 12),
        _ActionButton(icon: Icons.more_vert, onPressed: onMenuPressed),
        const SizedBox(width: 12),
        _ActionButton(icon: Icons.sync, onPressed: onSyncPressed),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _ActionButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: colorScheme.primary),
        onPressed: onPressed,
      ),
    );
  }
}
