import 'package:hive/hive.dart';

part 'res_item.g.dart';

@HiveType(typeId: 0)
class RssItem {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String link;

  @HiveField(3)
  final String author;

  @HiveField(4)
  final Enclosure enclosure;

  RssItem({
    required this.title,
    required this.description,
    required this.link,
    required this.author,
    required this.enclosure,
  });
}

@HiveType(typeId: 1)
class Enclosure {
  @HiveField(0)
  final String url;

  Enclosure({required this.url});
}
