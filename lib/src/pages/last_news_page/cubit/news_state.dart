part of 'news_cubit.dart';

/// Abstract base class for news states
@immutable
abstract class NewsState {}

/// Initial state before news is loaded
class NewsInitial extends NewsState {}

/// State when news is successfully loaded
class NewsLoadedState extends NewsState {
  final List<RssItem> news;
  final Set<String> readNews;

  NewsLoadedState(this.news, {this.readNews = const <String>{}});
}

/// State when there is an error loading news
class NewsErrorState extends NewsState {
  final String errorMessage;

  NewsErrorState(this.errorMessage);
}
