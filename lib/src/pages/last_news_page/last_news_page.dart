import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../news_detail_page.dart';
import 'cubit/news_cubit.dart';
import '../../widgets/image_news_widget.dart';

class LastNewsPage extends ConsumerWidget {
  const LastNewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsCubit = ref.watch(newsCubitProvider);

    return BlocProvider.value(
      value: newsCubit,
      child: const _LastNewsPage(),
    );
  }
}

class _LastNewsPage extends StatelessWidget {
  const _LastNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsInitial) {
          context.read<NewsCubit>().loadNews();
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsErrorState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        if (state is NewsLoadedState) {
          return RefreshIndicator(
            child: listBuilder(context, state),
            onRefresh: () => context.read<NewsCubit>().reloadNews(),
          );
        }

        return Container();
      },
    );
  }

  Widget listBuilder(BuildContext context, NewsLoadedState state) {
    return ListView.builder(
      itemCount: state.news.length,
      itemBuilder: (BuildContext context, int index) {
        final item = state.news[index];
        return ListTile(
          title: Text(
            item.title!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            maxLines: 8,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey[300]!,
            size: 30,
          ),
          contentPadding: const EdgeInsets.all(15),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(newsItem: item),
              ),
            );
          },
          leading: ImageNewsWidget(
            urlImage: item.enclosure?.url ?? '',
          ),
        );
      },
    );
  }
}
