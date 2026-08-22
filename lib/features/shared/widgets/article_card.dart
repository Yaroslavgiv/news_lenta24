import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/article.dart';
import 'article_image.dart';
import 'highlighted_text.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.isRead,
    required this.onTap,
    this.searchQuery = '',
    this.showSource = false,
  });

  final Article article;
  final bool isRead;
  final VoidCallback onTap;
  final String searchQuery;
  final bool showSource;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isRead ? 0.62 : 1,
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.line),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArticleImage(url: article.imageUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showSource || article.publishedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              [
                                if (showSource) article.sourceName,
                                formatArticleDate(article.publishedAt),
                              ].where((item) => item.isNotEmpty).join(' · '),
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        HighlightedText(
                          text: article.title,
                          query: searchQuery,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            color: isRead ? AppColors.inkMuted : AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.ink.withOpacity(0.28),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
