import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/news_source.dart';
import '../../feed/cubit/feed_cubit.dart';
import '../../feed/cubit/feed_state.dart';
import '../../shared/widgets/feed_states.dart';

class SourceFeedPage extends ConsumerWidget {
  const SourceFeedPage({super.key, required this.source});

  final NewsSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cubit = ref.watch(feedCubitProvider(source.id));
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(source.name.toUpperCase()),
          actions: [
            IconButton(
              tooltip: 'Отметить всё прочитанным',
              onPressed: cubit.markAllAsRead,
              icon: const Icon(Icons.done_all_rounded),
            ),
          ],
        ),
        body: const _SourceFeedBody(),
      ),
    );
  }
}

class _SourceFeedBody extends StatelessWidget {
  const _SourceFeedBody();

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
            child: ArticleListView(
              state: state,
              cubit: context.read<FeedCubit>(),
              showSource: true,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
