import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../widgets/list_item_widget.dart';
import 'last_news_page/cubit/news_cubit.dart';

class SearchNewsPage extends ConsumerStatefulWidget {
  const SearchNewsPage({super.key});

  @override
  _SearchNewsPageState createState() => _SearchNewsPageState();
}

class _SearchNewsPageState extends ConsumerState<SearchNewsPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final newsCubit = ref.watch(newsCubitProvider);

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Поиск новостей...',
            border: InputBorder.none,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: BlocProvider.value(
        value: newsCubit,
        child: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoadedState) {
              final filteredNews = state.news.where((item) {
                return item.title?.toLowerCase().contains(searchQuery) ?? false;
              }).toList();

              return OrientationBuilder(
                builder: (context, orientation) {
                  final crossAxisCount =
                      orientation == Orientation.portrait ? 1 : 2;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNews.length,
                    itemBuilder: (context, index) {
                      final item = filteredNews[index];
                      return ListItemWidget(
                          item: item, searchQuery: searchQuery);
                    },
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
