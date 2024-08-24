import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../widgets/list_item_widget.dart';
import 'cubit/news24_cubit.dart';

class Last24NewsPage extends ConsumerWidget {
  const Last24NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news24Cubit = ref.watch(news24CubitProvider);

    return BlocProvider.value(
      value: news24Cubit,
      child: const _LastNewsPage(),
    );
  }
}

class _LastNewsPage extends StatelessWidget {
  const _LastNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<News24Cubit, News24State>(
      builder: (context, state) {
        if (state is News24Initial) {
          context.read<News24Cubit>().loadNews();
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is News24ErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        }
        if (state is News24LoadedState) {
          return RefreshIndicator(
            child: listBuilder(context, state),
            onRefresh: () => context.read<News24Cubit>().reloadNews(),
          );
        }
        return Container();
      },
    );
  }

  Widget listBuilder(BuildContext context, News24LoadedState state) {
    return ListView.builder(
      itemCount: state.news.length,
      itemBuilder: (BuildContext context, int index) {
        final item = state.news[index];
        return ListItemWidget(item: item);
      },
    );
  }
}
