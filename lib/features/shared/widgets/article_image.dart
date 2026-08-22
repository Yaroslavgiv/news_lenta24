import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.url,
    this.height = 72,
    this.width = 96,
    this.radius = 16,
  });

  final String? url;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width,
        child: url == null || url!.isEmpty
            ? _Placeholder(height: height, width: width)
            : CachedNetworkImage(
                imageUrl: url!,
                height: height,
                width: width,
                fit: BoxFit.cover,
                placeholder: (_, __) => _Placeholder(
                  height: height,
                  width: width,
                  loading: true,
                ),
                errorWidget: (_, __, ___) => Image.asset(
                  'assets/no_image.png',
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _Placeholder(
                    height: height,
                    width: width,
                  ),
                ),
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.height,
    required this.width,
    this.loading = false,
  });

  final double height;
  final double width;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.accentSoft,
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  Icons.newspaper_rounded,
                  color: AppColors.accent.withOpacity(0.7),
                ),
        ),
      ),
    );
  }
}
