import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../main.dart';
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
        return OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? Column(
                    children: [
                      Expanded(
                        child: _buildNewsCarousel(orientation),
                      ),
                      const Expanded(
                        flex: 2,
                        child: LastNewsPage(),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _buildNewsCarousel(orientation),
                        ),
                      ),
                      const Expanded(
                        // flex: 2,
                        child: LastNewsPage(),
                      ),
                    ],
                  );
          },
        );
      case 1:
        return const Last24NewsPage();
      default:
        throw ArgumentError();
    }
  }

  Widget _buildNewsCarousel(Orientation orientation) {
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isRead ? Colors.grey[200] : Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(item.enclosure?.url ?? ''),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
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
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  color: Colors.white70,
                                  child: const Text(
                                    'New',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.red),
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
                    height: orientation == Orientation.portrait
                        ? 220
                        : double.infinity,
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                    aspectRatio:
                        orientation == Orientation.portrait ? 16 / 9 : 9 / 16,
                    viewportFraction: 0.8,
                    enableInfiniteScroll: true,
                    scrollDirection: orientation == Orientation.portrait
                        ? Axis.horizontal
                        : Axis.vertical,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
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
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text(
          'LENTA.RU',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black38,
        leading: IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white70,
          ),
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
            icon: const Icon(
              Icons.mark_email_read,
              color: Colors.white70,
            ),
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
