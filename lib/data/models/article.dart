class Article {
  const Article({
    required this.title,
    required this.description,
    required this.link,
    required this.sourceId,
    required this.sourceName,
    this.author,
    this.imageUrl,
    this.publishedAt,
  });

  final String title;
  final String description;
  final String link;
  final String sourceId;
  final String sourceName;
  final String? author;
  final String? imageUrl;
  final DateTime? publishedAt;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'sourceId': sourceId,
      'sourceName': sourceName,
      'author': author,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }

  factory Article.fromMap(Map<dynamic, dynamic> map) {
    return Article(
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      link: map['link'] as String? ?? '',
      sourceId: map['sourceId'] as String? ?? '',
      sourceName: map['sourceName'] as String? ?? '',
      author: map['author'] as String?,
      imageUrl: map['imageUrl'] as String?,
      publishedAt: map['publishedAt'] is String
          ? DateTime.tryParse(map['publishedAt'] as String)
          : null,
    );
  }
}
