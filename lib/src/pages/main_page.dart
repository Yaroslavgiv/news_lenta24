import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_test_app/main.dart';

import 'last24_news_page/cubit/news24_cubit.dart';
import 'last24_news_page/last24_news_page.dart';
import 'last_news_page/cubit/news_cubit.dart';
import 'last_news_page/last_news_page.dart';
import 'news_detail_page.dart';
import 'search_news_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectIndex = 0;
  late Widget bodyWidget;

  @override
  void initState() {
    super.initState();
    onItemTepped(0);
  }

  void onItemTepped(int index) {
    setState(() {
      selectIndex = index;
      bodyWidget = buildCurrentWidget(index);
    });
  }

  Widget buildCurrentWidget(int type) {
    switch (type) {
      case 0:
        return Column(
          children: [
            Expanded(
              child: _buildNewsCarousel(),
            ),
            const Expanded(
              flex: 2,
              child: LastNewsPage(),
            ),
          ],
        );
      case 1:
        return const Last24NewsPage();
      default:
        throw ArgumentError();
    }
  }

  Widget _buildNewsCarousel() {
    return Consumer(
      builder: (context, ref, child) {
        final news24Cubit = ref.watch(news24CubitProvider);

        return BlocProvider.value(
          value: news24Cubit,
          child: BlocBuilder<News24Cubit, News24State>(
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
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              }
              if (state is News24LoadedState) {
                return CarouselSlider.builder(
                  itemCount: state.news.length,
                  itemBuilder: (context, index, realIndex) {
                    final item = state.news[index];
                    final bool isRead = state.readNews.contains(item.link);

                    return GestureDetector(
                      onTap: () {
                        context.read<News24Cubit>().markAsRead(item.link);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailPage(newsItem: item),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isRead ? Colors.grey[200] : Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(item.enclosure?.url ?? ''),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        item.title ?? '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                  ),
                );
              }

              return Container();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lenta.ru',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SearchNewsPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              final newsCubit = context.read<NewsCubit>();
              newsCubit.markAllAsRead();
            },
          ),
        ],
      ),
      body: bodyWidget,
    );
  }
}
