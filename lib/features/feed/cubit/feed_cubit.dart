import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/article.dart';
import '../../../data/models/news_source.dart';
import '../../../data/repositories/news_repository.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({
    required this.repository,
    required this.source,
  }) : super(const FeedInitial());

  final NewsRepository repository;
  final NewsSource source;

  Future<void> load({bool forceRefresh = false}) async {
    if (state is FeedLoading) {
      return;
    }

    if (state is! FeedLoaded) {
      emit(const FeedLoading());
    }

    try {
      final articles = await repository.load(
        source,
        forceRefresh: forceRefresh,
      );
      emit(FeedLoaded(
        articles: articles,
        readLinks: repository.readLinks(),
      ));
    } catch (_) {
      final cached = repository.cachedArticles(source);
      if (cached.isNotEmpty) {
        emit(FeedLoaded(
          articles: cached,
          readLinks: repository.readLinks(),
        ));
        return;
      }
      emit(FeedError('Не удалось загрузить ленту «${source.name}»'));
    }
  }

  Future<void> reload() => load(forceRefresh: true);

  Future<void> markAsRead(String? link) async {
    if (link == null || link.isEmpty) {
      return;
    }
    final current = state;
    if (current is! FeedLoaded) {
      return;
    }
    final updated = await repository.markAsRead(link);
    emit(current.copyWith(readLinks: updated));
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! FeedLoaded) {
      return;
    }
    final updated = await repository.markAllAsRead(
      current.articles.map((article) => article.link),
    );
    emit(current.copyWith(readLinks: updated));
  }

  List<Article> relatedTo(Article article, {int limit = 4}) {
    final current = state;
    if (current is! FeedLoaded) {
      return const [];
    }
    return current.articles
        .where((item) => item.link != article.link)
        .take(limit)
        .toList();
  }
}
