import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/article.dart';
import '../../detail/news_detail_page.dart';
import '../../shared/widgets/article_card.dart';
import '../../shared/widgets/featured_carousel.dart';
import '../../shared/widgets/feed_states.dart';
import '../cubit/feed_cubit.dart';
import '../cubit/feed_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cubit = ref.watch(lentaFeedProvider);
    return BlocProvider.value(
      value: cubit,
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        if (state is FeedInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<FeedCubit>().load();
            }
          });
          return const FeedLoadingView();
        }
        if (state is FeedLoading) {
          return const FeedLoadingView();
        }
        if (state is FeedError) {
          return FeedErrorView(
            message: state.message,
            onRetry: () => context.read<FeedCubit>().reload(),
          );
        }
        if (state is FeedLoaded) {
          return RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () => context.read<FeedCubit>().reload(),
            child: OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? _PortraitHome(state: state)
                    : _LandscapeHome(state: state);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _PortraitHome extends StatelessWidget {
  const _PortraitHome({required this.state});

  final FeedLoaded state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FeaturedCarousel(
              articles: state.articles,
              readLinks: state.readLinks,
              orientation: Orientation.portrait,
              onOpen: (article) => _open(context, article),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Text(
              'Последние новости',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList.separated(
            itemCount: state.articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final article = state.articles[index];
              return ArticleCard(
                article: article,
                isRead: state.isRead(article),
                onTap: () => _open(context, article),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LandscapeHome extends StatelessWidget {
  const _LandscapeHome({required this.state});

  final FeedLoaded state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FeaturedCarousel(
            articles: state.articles,
            readLinks: state.readLinks,
            orientation: Orientation.landscape,
            onOpen: (article) => _open(context, article),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(8, 12, 16, 24),
            itemCount: state.articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final article = state.articles[index];
              return ArticleCard(
                article: article,
                isRead: state.isRead(article),
                onTap: () => _open(context, article),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _open(BuildContext context, Article article) async {
  final cubit = context.read<FeedCubit>();
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
