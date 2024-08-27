part of 'news24_cubit.dart';

/// Abstract base class for 24-hour news states
@immutable
abstract class News24State {}

/// Initial state before 24-hour news is loaded
class News24Initial extends News24State {}

/// State when 24-hour news is successfully loaded
class News24LoadedState extends News24State {
  final List<RssItem> news;
  final Set<String> readNews;

  News24LoadedState(this.news, {this.readNews = const <String>{}});
}

/// State when there is an error loading 24-hour news
class News24ErrorState extends News24State {
  final String errorMessage;

  News24ErrorState(this.errorMessage);
}
