import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../../../../shared/components/atoms/app_button.dart';
import '../../../../../shared/utils/bottom_sheet_utils.dart';
import '../../../domain/entities/book_page_options.dart';
import '../../../domain/entities/book_type.dart';
import '../../view_models/books_view_model.dart';
import '../molecules/books_filter_content.dart';
import '../molecules/books_filter_header.dart';

class BooksFilterSheet extends StatefulWidget {
  final BookPageOptions initialOptions;
  final void Function(BookPageOptions) onApply;
  final VoidCallback onClear;
  const BooksFilterSheet({
    super.key,
    required this.initialOptions,
    required this.onApply,
    required this.onClear,
  });

  static Future<void> show(BuildContext context, BooksViewModel viewModel) {
    return showAppModalBottomSheet<void>(
      context: context,
      builder: (context) => BooksFilterSheet(
        initialOptions: viewModel.options,
        onApply: (newOptions) {
          viewModel.updateFilters(
            publication: newOptions.publication,
            publicationOperator: newOptions.publicationOperator,
            type: newOptions.type,
            tags: newOptions.tags,
            tagsLogic: newOptions.tagsLogic,
            excludeTags: newOptions.excludeTags,
            excludeTagsLogic: newOptions.excludeTagsLogic,
            authors: newOptions.authors,
            authorsLogic: newOptions.authorsLogic,
            sensitiveContent: newOptions.sensitiveContent,
          );
        },
        onClear: viewModel.clearFilters,
      ),
    );
  }

  @override
  State<BooksFilterSheet> createState() => _BooksFilterSheetState();
}

class _BooksFilterSheetState extends State<BooksFilterSheet> {
  late BookPageOptions _currentOptions;
  final TextEditingController _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentOptions = widget.initialOptions;
    if (_currentOptions.publication != null) {
      _yearController.text = _currentOptions.publication.toString();
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  void _onOperatorChanged(String? value) {
    setState(() {
      _currentOptions = _currentOptions.copyWith(
        publicationOperator: Optional.ofNullable(value),
      );
    });
  }

  void _onYearChanged(String value) {
    setState(() {
      _currentOptions = _currentOptions.copyWith(
        publication: Optional.ofNullable(int.tryParse(value)),
      );
    });
  }

  void _onTypeSelected(TypeBook type, bool selected) {
    setState(() {
      final types = List<TypeBook>.from(_currentOptions.type ?? []);
      if (selected) {
        types.add(type);
      } else {
        types.remove(type);
      }
      _currentOptions = _currentOptions.copyWith(
        type: Optional.ofNullable(types),
      );
    });
  }

  void _onSensitiveContentSelected(String tag, bool selected) {
    setState(() {
      final tags = List<String>.from(_currentOptions.sensitiveContent ?? []);
      if (selected) {
        tags.add(tag);
      } else {
        tags.remove(tag);
      }
      _currentOptions = _currentOptions.copyWith(
        sensitiveContent: Optional.ofNullable(tags),
      );
    });
  }

  void _onClear() {
    widget.onClear();
    Navigator.pop(context);
  }

  void _onApply() {
    widget.onApply(_currentOptions);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BooksFilterHeader(onClear: _onClear),
            const Divider(),
            Flexible(
              child: BooksFilterContent(
                options: _currentOptions,
                yearController: _yearController,
                onOperatorChanged: _onOperatorChanged,
                onYearChanged: _onYearChanged,
                onTypeSelected: _onTypeSelected,
                onSensitiveContentSelected: _onSensitiveContentSelected,
              ),
            ),
            const SizedBox(height: 16),
            AppButton(text: l10n.booksApplyFilters, onPressed: _onApply),
          ],
        ),
      ),
    );
  }
}
