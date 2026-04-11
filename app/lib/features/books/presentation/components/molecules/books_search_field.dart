import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';

class BooksSearchField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String?) onChanged;

  const BooksSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<BooksSearchField> createState() => _BooksSearchFieldState();
}

class _BooksSearchFieldState extends State<BooksSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: l10n.booksSearchHint,
        border: InputBorder.none,
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged(null);
                },
              )
            : null,
      ),
      onSubmitted: widget.onChanged,
    );
  }
}
