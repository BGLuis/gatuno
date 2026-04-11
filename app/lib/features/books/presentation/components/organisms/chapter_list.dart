import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/features/books/domain/entities/chapter.dart';
import '../molecules/chapter_tile.dart';

class ChapterList extends StatelessWidget {
  final List<Chapter> chapters;
  final bool isLoading;
  final bool hasNextPage;
  final void Function(Chapter) onChapterTap;
  final String? error;
  final VoidCallback? onRetry;

  const ChapterList({
    super.key,
    required this.chapters,
    required this.isLoading,
    required this.hasNextPage,
    required this.onChapterTap,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (chapters.isEmpty && !isLoading && error == null) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(l10n.booksNoChaptersFound),
          ),
        ),
      );
    }

    if (chapters.isEmpty && isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (chapters.isEmpty && error != null) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(error!, textAlign: TextAlign.center),
                if (onRetry != null)
                  TextButton(onPressed: onRetry, child: Text(l10n.errorRetry)),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == chapters.length) {
          if (isLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(error!, textAlign: TextAlign.center),
                    if (onRetry != null)
                      TextButton(
                        onPressed: onRetry,
                        child: Text(l10n.errorRetry),
                      ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox(height: 32);
        }

        final chapter = chapters[index];
        return ChapterTile(
          chapter: chapter,
          onTap: () => onChapterTap(chapter),
        );
      }, childCount: chapters.length + 1),
    );
  }
}
