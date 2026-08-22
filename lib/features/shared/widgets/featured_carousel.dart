import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/article.dart';
import 'article_image.dart';

class FeaturedCarousel extends StatelessWidget {
  const FeaturedCarousel({
    super.key,
    required this.articles,
    required this.readLinks,
    required this.onOpen,
    required this.orientation,
  });

  final List<Article> articles;
  final Set<String> readLinks;
  final ValueChanged<Article> onOpen;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    final items = articles.take(8).toList();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final isPortrait = orientation == Orientation.portrait;

    return CarouselSlider.builder(
      itemCount: items.length,
      itemBuilder: (context, index, _) {
        final article = items[index];
        final isRead = readLinks.contains(article.link);
        return _FeaturedCard(
          article: article,
          isRead: isRead,
          onTap: () => onOpen(article),
        );
      },
      options: CarouselOptions(
        height: isPortrait ? 228 : double.infinity,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 700),
        enlargeCenterPage: true,
        viewportFraction: isPortrait ? 0.86 : 0.92,
        aspectRatio: isPortrait ? 16 / 9 : 9 / 16,
        enableInfiniteScroll: items.length > 1,
        scrollDirection: isPortrait ? Axis.horizontal : Axis.vertical,
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.article,
    required this.isRead,
    required this.onTap,
  });

  final Article article;
  final bool isRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ArticleImage(
                url: article.imageUrl,
                height: double.infinity,
                width: double.infinity,
                radius: 0,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.78),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Badge(
                          label: article.sourceName,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        if (!isRead)
                          const _Badge(label: 'Новое', color: Colors.white24),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
