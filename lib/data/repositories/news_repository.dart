import 'dart:convert';
import 'dart:io';

import 'package:dart_rss/dart_rss.dart';
import 'package:hive/hive.dart';

import '../../core/utils/date_utils.dart';
import '../../core/utils/html_utils.dart';
import '../models/article.dart';
import '../models/news_source.dart';

typedef FeedDownloader = Future<String> Function(String url);

class NewsRepository {
  NewsRepository({
    Box? box,
    FeedDownloader? downloader,
    this.cacheTtl = const Duration(minutes: 15),
  })  : _box = box,
        _downloader = downloader ?? downloadFeed;

  static const _boxName = 'newsBox';
  static const _readKey = 'readNews';
  static const _userAgent =
      'Mozilla/5.0 (compatible; Lenta24/1.0; +https://lenta.ru)';

  final Duration cacheTtl;
  final FeedDownloader _downloader;
  Box? _box;

  Box get box => _box ??= Hive.box(_boxName);

  static Future<String> downloadFeed(String url) async {
    final client = HttpClient()
      ..userAgent = _userAgent
      ..connectionTimeout = const Duration(seconds: 12);
    try {
      final request = await client.getUrl(Uri.parse(url));
      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/rss+xml, application/xml, text/xml, */*',
      );
      request.followRedirects = true;
      final response = await request.close().timeout(const Duration(seconds: 15));
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
      }
      return body;
    } finally {
      client.close(force: true);
    }
  }

  Future<List<Article>> load(
    NewsSource source, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'feed_${source.id}';
    final stampKey = '${cacheKey}_ts';

    if (!forceRefresh) {
      final cached = _readCache(cacheKey);
      final stamp = box.get(stampKey);
      final isFresh = stamp is int &&
          DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(stamp)) <
              cacheTtl;
      if (cached.isNotEmpty && isFresh) {
        return cached;
      }
    }

    final articles = await fetchRemote(source);
    await box.put(cacheKey, articles.map((article) => article.toMap()).toList());
    await box.put(stampKey, DateTime.now().millisecondsSinceEpoch);
    return articles;
  }

  Future<List<Article>> fetchRemote(NewsSource source) async {
    final body = await _downloader(source.rssUrl);
    final feed = RssFeed.parse(body);
    return feed.items
        .map((item) => _mapItem(item, source))
        .where((article) => article.title.isNotEmpty && article.link.isNotEmpty)
        .toList();
  }

  Set<String> readLinks() {
    final stored = box.get(_readKey, defaultValue: <dynamic>[]);
    if (stored is List) {
      return stored.map((item) => item.toString()).toSet();
    }
    if (stored is Set) {
      return stored.map((item) => item.toString()).toSet();
    }
    return <String>{};
  }

  Future<Set<String>> markAsRead(String link) async {
    final updated = readLinks()..add(link);
    await box.put(_readKey, updated.toList());
    return updated;
  }

  Future<Set<String>> markAllAsRead(Iterable<String> links) async {
    final updated = readLinks()..addAll(links.where((link) => link.isNotEmpty));
    await box.put(_readKey, updated.toList());
    return updated;
  }

  List<Article> cachedArticles(NewsSource source) {
    return _readCache('feed_${source.id}');
  }

  List<Article> _readCache(String key) {
    final cached = box.get(key);
    if (cached is! List) {
      return const [];
    }
    return cached
        .whereType<Map>()
        .map(Article.fromMap)
        .where((article) => article.link.isNotEmpty)
        .toList();
  }

  Article _mapItem(RssItem item, NewsSource source) {
    final content = item.content?.value;
    final rawDescription =
        (content != null && content.trim().isNotEmpty) ? content : (item.description ?? '');
    final imageUrl = item.enclosure?.url ??
        extractImageUrl(content) ??
        extractImageUrl(item.description);

    return Article(
      title: stripHtml(item.title),
      description: stripHtml(rawDescription),
      link: item.link ?? '',
      author: stripHtml(item.author).isEmpty ? null : stripHtml(item.author),
      imageUrl: imageUrl,
      publishedAt: parseRssDate(item.pubDate),
      sourceId: source.id,
      sourceName: source.name,
    );
  }
}
