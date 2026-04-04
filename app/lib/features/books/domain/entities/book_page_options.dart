import 'book_type.dart';

enum SortOrder { asc, desc }

class SortOption {
  final String orderBy;
  final SortOrder order;
  const SortOption(this.orderBy, this.order);
}

class BookPageOptions {
  final int page;
  final int limit;
  final String orderBy;
  final SortOrder order;
  final String? search;
  final int? publication;
  final String? publicationOperator; // 'eq', 'gt', 'lt', 'gte', 'lte'
  final List<TypeBook>? type;
  final List<String>? sensitiveContent;
  final List<String>? tags;
  final String? tagsLogic; // 'and', 'or'
  final List<String>? excludeTags;
  final String? excludeTagsLogic; // 'and', 'or'
  final List<String>? authors;
  final String? authorsLogic; // 'and', 'or'

  const BookPageOptions({
    this.page = 1,
    this.limit = 20,
    this.orderBy = 'createdAt',
    this.order = SortOrder.desc,
    this.search,
    this.publication,
    this.publicationOperator = 'eq',
    this.type,
    this.sensitiveContent,
    this.tags,
    this.tagsLogic = 'and',
    this.excludeTags,
    this.excludeTagsLogic = 'or',
    this.authors,
    this.authorsLogic = 'and',
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'orderBy': orderBy,
      'order': order.name,
      if (search != null && search!.isNotEmpty) 'search': search,
      if (publication != null) 'publication': publication,
      if (publicationOperator != null)
        'publicationOperator': publicationOperator,
      if (type != null && type!.isNotEmpty)
        'type': type!.map((e) => e.name.toLowerCase()).toList(),
      if (sensitiveContent != null && sensitiveContent!.isNotEmpty)
        'sensitiveContent': sensitiveContent,
      if (tags != null && tags!.isNotEmpty) 'tags': tags,
      if (tagsLogic != null) 'tagsLogic': tagsLogic,
      if (excludeTags != null && excludeTags!.isNotEmpty)
        'excludeTags': excludeTags,
      if (excludeTagsLogic != null) 'excludeTagsLogic': excludeTagsLogic,
      if (authors != null && authors!.isNotEmpty) 'authors': authors,
      if (authorsLogic != null) 'authorsLogic': authorsLogic,
    };
  }

  BookPageOptions copyWith({
    int? page,
    int? limit,
    String? orderBy,
    SortOrder? order,
    String? search,
    int? publication,
    String? publicationOperator,
    List<TypeBook>? type,
    List<String>? sensitiveContent,
    List<String>? tags,
    String? tagsLogic,
    List<String>? excludeTags,
    String? excludeTagsLogic,
    List<String>? authors,
    String? authorsLogic,
  }) {
    return BookPageOptions(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      orderBy: orderBy ?? this.orderBy,
      order: order ?? this.order,
      search: search ?? this.search,
      publication: publication ?? this.publication,
      publicationOperator: publicationOperator ?? this.publicationOperator,
      type: type ?? this.type,
      sensitiveContent: sensitiveContent ?? this.sensitiveContent,
      tags: tags ?? this.tags,
      tagsLogic: tagsLogic ?? this.tagsLogic,
      excludeTags: excludeTags ?? this.excludeTags,
      excludeTagsLogic: excludeTagsLogic ?? this.excludeTagsLogic,
      authors: authors ?? this.authors,
      authorsLogic: authorsLogic ?? this.authorsLogic,
    );
  }
}
