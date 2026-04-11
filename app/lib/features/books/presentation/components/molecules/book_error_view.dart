import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';

class BookErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const BookErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(l10n.errorRetry)),
        ],
      ),
    );
  }
}
