import 'package:flutter/material.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/utils.dart';
import '../widgets/image_news_widget.dart';
import '../widgets/list_item_widget.dart';
import 'last_news_page/cubit/news_cubit.dart';

class NewsDetailPage extends StatelessWidget {
  final RssItem newsItem;

  const NewsDetailPage(
      {super.key,
      required this.newsItem}); // Add the parameter to the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use newsCubit directly as needed
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text(
          'Новость',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (newsItem.enclosure?.url != null)
                ImageNewsWidget(
                  urlImage: newsItem.enclosure!.url!,
                  width: double.infinity,
                  height: 250,
                ),
              const SizedBox(height: 16),
              Text(
                newsItem.title ?? 'Без названия',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                newsItem.author ?? 'Автор неизвестен',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                newsItem.description ?? 'Нет описания',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              InkWell(
                child: const Text(
                  'Читать на сайте',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => launchUniversalLink(newsItem.link!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
