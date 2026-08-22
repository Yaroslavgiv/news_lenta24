import 'package:flutter_test/flutter_test.dart';
import 'package:news_test_app/core/utils/html_utils.dart';
import 'package:news_test_app/core/utils/date_utils.dart';
import 'package:news_test_app/data/sources/catalog.dart';
import 'package:news_test_app/features/shared/widgets/highlighted_text.dart';

void main() {
  test('stripHtml убирает теги и сущности', () {
    const raw = '<p>Привет&nbsp;&laquo;мир&raquo;</p>';
    expect(stripHtml(raw), 'Привет «мир»');
  });

  test('extractImageUrl берёт первый src', () {
    const raw = '<div><img src="https://example.com/pic.jpg" /></div>';
    expect(extractImageUrl(raw), 'https://example.com/pic.jpg');
  });

  test('highlightSpans выделяет запрос', () {
    final spans = highlightSpans('РИА Новости сегодня', 'новости', null);
    expect(spans.length, 3);
    expect(spans[1].text, 'Новости');
  });

  test('каталог содержит дополнительные источники', () {
    final names = NewsCatalog.extraSources.map((source) => source.name);
    expect(names, containsAll(['РИА Новости', 'Хабр', 'ТАСС', 'РБК']));
    expect(NewsCatalog.byId('habr').rssUrl, contains('habr.com'));
  });

  test('parseRssDate понимает RFC 822', () {
    final date = parseRssDate('Wed, 21 Aug 2026 10:15:00 GMT');
    expect(date, isNotNull);
    expect(date!.year, 2026);
    expect(date.month, 8);
  });
}
