part of 'news_cubit.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<RssItem> news;
  final Set<String> readNews;

  NewsLoadedState(this.news, {this.readNews = const <String>{}});
}

class NewsErrorState extends NewsState {
  final String errorMessage;

  NewsErrorState(this.errorMessage);
}
