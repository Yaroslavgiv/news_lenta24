import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/article.dart';
import '../detail/news_detail_page.dart';
import '../feed/cubit/feed_cubit.dart';
import '../feed/cubit/feed_state.dart';
import '../shared/widgets/article_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final lenta = ref.watch(lentaFeedProvider);
    final last24 = ref.watch(last24FeedProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          autofocus: true,
          onChanged: (value) => setState(() => query = value),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Поиск по заголовкам и тексту…',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        bloc: lenta,
        builder: (context, lentaState) {
          return BlocBuilder<FeedCubit, FeedState>(
            bloc: last24,
            builder: (context, last24State) {
              final articles = _mergeArticles(lentaState, last24State);
              final filtered = _filter(articles, query);

              if (filtered.isEmpty) {
                return const Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final article = filtered[index];
                  return ArticleCard(
                    article: article,
                    isRead: false,
                    searchQuery: query,
                    showSource: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NewsDetailPage(
                            article: article,
                            related: filtered
                                .where((item) => item.link != article.link)
                                .take(4)
                                .toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Article> _mergeArticles(FeedState first, FeedState second) {
    final items = <Article>[
      if (first is FeedLoaded) ...first.articles,
      if (second is FeedLoaded) ...second.articles,
    ];
    final seen = <String>{};
    return items.where((article) => seen.add(article.link)).toList();
  }

  List<Article> _filter(List<Article> articles, String rawQuery) {
    final q = rawQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return articles;
    }
    return articles.where((article) {
      return article.title.toLowerCase().contains(q) ||
          article.description.toLowerCase().contains(q) ||
          article.sourceName.toLowerCase().contains(q);
    }).toList();
  }
}
