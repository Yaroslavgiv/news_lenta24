final _tagPattern = RegExp(r'<[^>]*>', multiLine: true);
final _spacePattern = RegExp(r'\s+');
final _imagePattern = RegExp(
  r'''<img[^>]+src=["']([^"']+)["']''',
  caseSensitive: false,
);

const _entities = <String, String>{
  '&nbsp;': ' ',
  '&quot;': '"',
  '&#34;': '"',
  '&apos;': "'",
  '&#39;': "'",
  '&amp;': '&',
  '&lt;': '<',
  '&gt;': '>',
  '&laquo;': '«',
  '&raquo;': '»',
  '&mdash;': '—',
  '&ndash;': '–',
  '&hellip;': '…',
};

String stripHtml(String? raw) {
  if (raw == null || raw.isEmpty) {
    return '';
  }

  var text = raw.replaceAll(_tagPattern, ' ');
  _entities.forEach((entity, value) {
    text = text.replaceAll(entity, value);
  });
  return text.replaceAll(_spacePattern, ' ').trim();
}

String? extractImageUrl(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  return _imagePattern.firstMatch(raw)?.group(1);
}

List<String> extractKeywords(String title, {int limit = 4}) {
  final words = title
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}\s-]', unicode: true), ' ')
      .split(_spacePattern)
      .where((word) => word.length > 3)
      .toList();
  return words.take(limit).toList();
}
