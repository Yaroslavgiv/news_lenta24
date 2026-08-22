import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/news_repository.dart';
import '../data/sources/catalog.dart';
import '../features/feed/cubit/feed_cubit.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository();
});

final feedCubitProvider = Provider.family<FeedCubit, String>((ref, sourceId) {
  final cubit = FeedCubit(
    repository: ref.watch(newsRepositoryProvider),
    source: NewsCatalog.byId(sourceId),
  );
  ref.onDispose(cubit.close);
  return cubit;
});

final lentaFeedProvider = Provider<FeedCubit>((ref) {
  return ref.watch(feedCubitProvider(NewsCatalog.lentaTop.id));
});

final last24FeedProvider = Provider<FeedCubit>((ref) {
  return ref.watch(feedCubitProvider(NewsCatalog.lenta24.id));
});
