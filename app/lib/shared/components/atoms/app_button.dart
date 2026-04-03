import 'package:flutter/material.dart';
import 'package:gatuno/shared/components/atoms/app_loading_indicator.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isLoading
          ? AppLoadingIndicator(size: 20, color: colorScheme.onPrimary)
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
