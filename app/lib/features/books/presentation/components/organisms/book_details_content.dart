import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/book.dart';
import '../../view_models/book_details_view_model.dart';
import '../atoms/book_cover_large.dart';
import '../molecules/book_action_buttons.dart';
import '../molecules/book_details_header.dart';
import '../molecules/book_tags_list.dart';
import '../molecules/book_description.dart';
import '../templates/book_details_template.dart';
import 'chapter_list.dart';

class BookDetailsContent extends StatelessWidget {
  final BookDetailsViewModel viewModel;
  final Book book;

  const BookDetailsContent({
    super.key,
    required this.viewModel,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return BookDetailsTemplate(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      cover: BookCoverLarge(coverUrl: book.cover),
      header: BookDetailsHeader(
        title: book.title,
        authors: book.authors,
        totalChapters: book.totalChapters,
        publicationYear: book.publication,
      ),
      actionButtons: BookActionButtons(
        onStartReading: () {
          // TODO: Implement start reading
        },
      ),
      tags: BookTagsList(tags: book.tags),
      description: BookDescription(description: book.description),
      chapterList: ChapterList(
        chapters: viewModel.chapterList?.data ?? [],
        isLoading: viewModel.isLoading,
        hasNextPage: viewModel.chapterList?.hasNextPage ?? false,
        onLoadMore: viewModel.loadMoreChapters,
        onChapterTap: (chapter) {
          // TODO: Navigate to reader
        },
      ),
    );
  }
}
