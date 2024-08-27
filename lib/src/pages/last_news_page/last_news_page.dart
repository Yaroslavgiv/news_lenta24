import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../main.dart';
import '../news_detail_page.dart';
import 'cubit/news_cubit.dart';
import '../../widgets/image_news_widget.dart';

// Widget for displaying the latest news.
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
        // Show loading indicator when news is being fetched
        if (state is NewsInitial) {
          context.read<NewsCubit>().loadNews();
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Show error message if there's an error
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
        // Show news list when news is loaded
        if (state is NewsLoadedState) {
          return RefreshIndicator(
            onRefresh: () => context.read<NewsCubit>().reloadNews(),
            child: _buildNewsList(context, state),
          );
        }

        return Container(); // Empty container when no state matches
      },
    );
  }

  // Builds a list of news items with animations
  Widget _buildNewsList(BuildContext context, NewsLoadedState state) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: state.news.length,
        itemBuilder: (context, index) {
          final item = state.news[index];
          final bool isRead = state.readNews.contains(item.link);

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(
                        item.title!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isRead ? Colors.grey : Colors.black,
                        ),
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey[300]!,
                        size: 30,
                      ),
                      tileColor: isRead ? Colors.grey[200] : Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                      onTap: () {
                        final newsCubit = context.read<NewsCubit>();
                        newsCubit.markAsRead(item.link);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailPage(newsItem: item),
                          ),
                        );
                      },
                      leading: ImageNewsWidget(
                        urlImage: item.enclosure?.url ?? '',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
