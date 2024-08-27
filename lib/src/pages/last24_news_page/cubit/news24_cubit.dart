import 'package:bloc/bloc.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'news24_state.dart';

const _top7URL = 'https://lenta.ru/rss/last24';

/// Cubit for managing 24-hour news state
class News24Cubit extends Cubit<News24State> {
  News24Cubit() : super(News24Initial());

  /// Loads 24-hour news from API or cache
  Future<void> loadNews() async {
    final newsBox = Hive.box('newsBox');

    try {
      if (newsBox.containsKey('news24')) {
        final cachedNews = newsBox.get('news24') as List<RssItem>;
        final readNews =
            newsBox.get('readNews24', defaultValue: <String>{}) as Set<String>;
        emit(News24LoadedState(cachedNews, readNews: readNews));
        return;
      }

      await Future.delayed(const Duration(seconds: 2));
      final response = await http.Client().get(Uri.parse(_top7URL));
      final rssFeed = RssFeed.parse(response.body);

      newsBox.put('news24', rssFeed.items);
      emit(News24LoadedState(rssFeed.items));
    } catch (e) {
      emit(News24ErrorState('Error loading 24-hour news'));
    }
  }

  /// Marks a specific 24-hour news item as read
  void markAsRead(String? link) {
    final newsBox = Hive.box('newsBox');
    final currentState = state;

    if (currentState is News24LoadedState && link != null) {
      final updatedReadNews = Set<String>.from(currentState.readNews)
        ..add(link);
      newsBox.put('readNews24', updatedReadNews);
      emit(News24LoadedState(currentState.news, readNews: updatedReadNews));
    }
  }

  /// Reloads 24-hour news from API
  Future<void> reloadNews() async {
    emit(News24Initial());
    await loadNews();
  }

  @override
  Future<void> close() {
    Hive.box('newsBox').close();
    return super.close();
  }
}
