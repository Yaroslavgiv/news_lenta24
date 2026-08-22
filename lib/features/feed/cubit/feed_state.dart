import '../../../data/models/article.dart';

sealed class FeedState {
  const FeedState();
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  const FeedLoaded({
    required this.articles,
    this.readLinks = const <String>{},
  });

  final List<Article> articles;
  final Set<String> readLinks;

  bool isRead(Article article) => readLinks.contains(article.link);

  FeedLoaded copyWith({
    List<Article>? articles,
    Set<String>? readLinks,
  }) {
    return FeedLoaded(
      articles: articles ?? this.articles,
      readLinks: readLinks ?? this.readLinks,
    );
  }
}

class FeedError extends FeedState {
  const FeedError(this.message);

  final String message;
}
