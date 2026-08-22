import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.maxLines = 3,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyMedium;
    return Text.rich(
      TextSpan(children: highlightSpans(text, query, base)),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}

List<TextSpan> highlightSpans(String text, String query, TextStyle? style) {
  if (query.trim().isEmpty) {
    return [TextSpan(text: text, style: style)];
  }

  final lowerText = text.toLowerCase();
  final lowerQuery = query.trim().toLowerCase();
  final spans = <TextSpan>[];
  var start = 0;

  while (true) {
    final index = lowerText.indexOf(lowerQuery, start);
    if (index < 0) {
      spans.add(TextSpan(text: text.substring(start), style: style));
      break;
    }
    if (index > start) {
      spans.add(TextSpan(text: text.substring(start, index), style: style));
    }
    spans.add(
      TextSpan(
        text: text.substring(index, index + lowerQuery.length),
        style: (style ?? const TextStyle()).copyWith(
          backgroundColor: AppColors.accent.withOpacity(0.18),
          color: AppColors.accent,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
    start = index + lowerQuery.length;
  }

  return spans;
}
