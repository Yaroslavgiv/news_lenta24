import 'package:flutter/material.dart';

class NewsSource {
  const NewsSource({
    required this.id,
    required this.name,
    required this.description,
    required this.rssUrl,
    required this.siteUrl,
    required this.color,
    required this.initials,
    this.isPrimary = false,
  });

  final String id;
  final String name;
  final String description;
  final String rssUrl;
  final String siteUrl;
  final Color color;
  final String initials;
  final bool isPrimary;
}
