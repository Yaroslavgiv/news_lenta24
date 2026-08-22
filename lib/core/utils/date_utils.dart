DateTime? parseRssDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }

  final value = raw.trim();
  try {
    return DateTime.parse(value).toLocal();
  } catch (_) {}

  const months = <String, int>{
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  final match = RegExp(
    r'(\d{1,2}) (\w{3}) (\d{4}) (\d{2}):(\d{2})(?::(\d{2}))?',
  ).firstMatch(value);
  if (match == null) {
    return null;
  }

  final month = months[match.group(2)];
  if (month == null) {
    return null;
  }

  return DateTime(
    int.parse(match.group(3)!),
    month,
    int.parse(match.group(1)!),
    int.parse(match.group(4)!),
    int.parse(match.group(5)!),
    int.parse(match.group(6) ?? '0'),
  ).toLocal();
}

String formatArticleDate(DateTime? date) {
  if (date == null) {
    return '';
  }

  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) {
    return 'только что';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} мин назад';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} ч назад';
  }

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day.$month $hour:$minute';
}
