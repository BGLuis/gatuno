import '../../domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    super.title,
    required super.index,
    super.scrapingStatus,
    super.read = false,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      index: _parseIndex(json['index']),
      scrapingStatus: _parseScrapingStatus(json['scrapingStatus'] as String?),
      read: json['read'] as bool? ?? false,
    );
  }

  static double _parseIndex(dynamic index) {
    if (index == null) return 0.0;
    if (index is num) return index.toDouble();
    return double.tryParse(index.toString()) ?? 0.0;
  }

  static ScrapingStatus? _parseScrapingStatus(String? status) {
    if (status == null) return null;
    try {
      return ScrapingStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == status.toLowerCase(),
      );
    } catch (_) {
      return ScrapingStatus.process;
    }
  }
}

class ChapterListModel extends ChapterList {
  const ChapterListModel({
    required super.data,
    super.nextCursor,
    required super.hasNextPage,
  });

  factory ChapterListModel.fromJson(Map<String, dynamic> json) {
    final items = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ChapterListModel(
      data: items,
      nextCursor: json['nextCursor'] as String?,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}
