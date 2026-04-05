enum ChapterSortOrder { asc, desc }

class ChapterPageOptions {
  final String? cursor;
  final int limit;
  final ChapterSortOrder order;

  const ChapterPageOptions({
    this.cursor,
    this.limit = 200,
    this.order = ChapterSortOrder.asc,
  });

  Map<String, dynamic> toJson() {
    return {
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
      'order': order.name.toUpperCase(),
    };
  }

  ChapterPageOptions copyWith({
    String? cursor,
    int? limit,
    ChapterSortOrder? order,
  }) {
    return ChapterPageOptions(
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
      order: order ?? this.order,
    );
  }
}
