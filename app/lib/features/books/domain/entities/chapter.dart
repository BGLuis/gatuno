enum ScrapingStatus { process, ready, error }

class Chapter {
  final String id;
  final String? title;
  final double index;
  final ScrapingStatus? scrapingStatus;
  final bool read;

  const Chapter({
    required this.id,
    this.title,
    required this.index,
    this.scrapingStatus,
    this.read = false,
  });
}

class ChapterList {
  final List<Chapter> data;
  final String? nextCursor;
  final bool hasNextPage;

  const ChapterList({
    required this.data,
    this.nextCursor,
    required this.hasNextPage,
  });
}
