import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/html_utils.dart';
import '../../core/utils/link_launcher.dart';
import '../../data/models/article.dart';
import '../shared/widgets/article_image.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({
    super.key,
    required this.article,
    this.related = const [],
  });

  final Article article;
  final List<Article> related;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.sourceName.toUpperCase()),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: orientation == Orientation.portrait
                ? _PortraitBody(article: article, related: related)
                : _LandscapeBody(article: article, related: related),
          );
        },
      ),
    );
  }
}

class _PortraitBody extends StatelessWidget {
  const _PortraitBody({required this.article, required this.related});

  final Article article;
  final List<Article> related;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.hasImage)
          ArticleImage(
            url: article.imageUrl,
            width: double.infinity,
            height: 240,
            radius: 22,
          ),
        const SizedBox(height: 18),
        _ArticleCopy(article: article),
        _RelatedNews(related: related),
      ],
    );
  }
}

class _LandscapeBody extends StatelessWidget {
  const _LandscapeBody({required this.article, required this.related});

  final Article article;
  final List<Article> related;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.hasImage)
          Expanded(
            child: ArticleImage(
              url: article.imageUrl,
              width: double.infinity,
              height: 280,
              radius: 22,
            ),
          ),
        if (article.hasImage) const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ArticleCopy(article: article),
              _RelatedNews(related: related),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArticleCopy extends StatelessWidget {
  const _ArticleCopy({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Chip(label: article.sourceName, filled: true),
            if (article.publishedAt != null)
              _Chip(label: formatArticleDate(article.publishedAt)),
            ...extractKeywords(article.title).map(
              (keyword) => _Chip(label: keyword),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          article.title,
          style: const TextStyle(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          article.author ?? 'Автор не указан',
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          article.description.isEmpty
              ? 'Краткое описание недоступно. Откройте материал на сайте источника.'
              : article.description,
          style: const TextStyle(fontSize: 16, height: 1.45),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => launchUniversalLink(article.link),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Читать на сайте'),
          ),
        ),
      ],
    );
  }
}

class _RelatedNews extends StatelessWidget {
  const _RelatedNews({required this.related});

  final List<Article> related;

  @override
  Widget build(BuildContext context) {
    if (related.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        const Text(
          'По теме',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        ...related.map(
          (item) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(item.sourceName),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NewsDetailPage(
                    article: item,
                    related: related.where((other) => other.link != item.link).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? AppColors.accent : AppColors.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.white : AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
