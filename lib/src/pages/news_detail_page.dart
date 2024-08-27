import 'package:flutter/material.dart';
import 'package:dart_rss/dart_rss.dart';
import '../utils/utils.dart';
import '../widgets/image_news_widget.dart';

class NewsDetailPage extends StatelessWidget {
  final RssItem newsItem;

  const NewsDetailPage({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout()
                  : _buildLandscapeLayout(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (newsItem.enclosure?.url != null)
          Expanded(
            child: SizedBox(
              child: ImageNewsWidget(
                urlImage: newsItem.enclosure!.url!,
                // width: double.infinity,
                height: 240,
              ),
            ),
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
      ],
    );
  }
}
