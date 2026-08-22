import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/article.dart';
import '../../detail/news_detail_page.dart';
import '../../feed/cubit/feed_cubit.dart';
import '../../feed/cubit/feed_state.dart';
import 'article_card.dart';

class FeedLoadingView extends StatelessWidget {
  const FeedLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class FeedErrorView extends StatelessWidget {
  const FeedErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 42, color: AppColors.accent),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleListView extends StatelessWidget {
  const ArticleListView({
    super.key,
    required this.state,
    required this.cubit,
    this.searchQuery = '',
    this.showSource = false,
    this.padding,
    this.header,
  });

  final FeedLoaded state;
  final FeedCubit cubit;
  final String searchQuery;
  final bool showSource;
  final EdgeInsets? padding;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: state.articles.length + (header == null ? 0 : 1),
        itemBuilder: (context, index) {
          if (header != null && index == 0) {
            return header!;
          }
          final articleIndex = header == null ? index : index - 1;
          final article = state.articles[articleIndex];
          return AnimationConfiguration.staggeredList(
            position: articleIndex,
            duration: const Duration(milliseconds: 380),
            child: SlideAnimation(
              verticalOffset: 28,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ArticleCard(
                    article: article,
                    isRead: state.isRead(article),
                    searchQuery: searchQuery,
                    showSource: showSource,
                    onTap: () => _openArticle(context, article),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openArticle(BuildContext context, Article article) async {
    await cubit.markAsRead(article.link);
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewsDetailPage(
          article: article,
          related: cubit.relatedTo(article),
        ),
      ),
    );
  }
}
