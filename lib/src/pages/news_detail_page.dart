import 'package:flutter/material.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/painting.dart';

import '../utils/utils.dart';
import '../widgets/image_news_widget.dart';

class NewsDetailPage extends StatelessWidget {
  final RssItem newsItem;

  const NewsDetailPage({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Новость',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
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
                style: const TextStyle(fontSize: 18, color: Colors.grey),
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

  List<TextSpan> _highlightKeywords(String text, String keyword) {
    final List<TextSpan> spans = [];
    final splitText =
        text.split(RegExp(r'(\b' + keyword + r'\b)', caseSensitive: false));
    for (var part in splitText) {
      if (part.toLowerCase() == keyword.toLowerCase()) {
        spans.add(TextSpan(
            text: part,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey)));
      } else {
        spans.add(TextSpan(text: part));
      }
    }
    return spans;
  }
}
