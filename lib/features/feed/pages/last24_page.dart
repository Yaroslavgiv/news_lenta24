import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widgets/feed_states.dart';
import '../cubit/feed_cubit.dart';
import '../cubit/feed_state.dart';

class Last24Page extends ConsumerWidget {
  const Last24Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cubit = ref.watch(last24FeedProvider);
    return BlocProvider.value(
      value: cubit,
      child: const _Last24View(),
    );
  }
}

class _Last24View extends StatelessWidget {
  const _Last24View();

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
              header: const Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 14),
                child: Text(
                  'Лента за 24 часа',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
