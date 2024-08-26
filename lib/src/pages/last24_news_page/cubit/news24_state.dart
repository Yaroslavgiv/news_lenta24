part of 'news24_cubit.dart';

@immutable
abstract class News24State {}

class News24Initial extends News24State {}

class News24LoadedState extends News24State {
  final List<RssItem> news;
  final Set<String> readNews;

  News24LoadedState(this.news, {this.readNews = const {}});
}

class News24ErrorState extends News24State {
  final String errorMessage;

  News24ErrorState(this.errorMessage);
}
