import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart' as http;

part 'news24_state.dart';

const _top7URL = 'https://lenta.ru/rss/last24';

class News24Cubit extends Cubit<News24State> {
  News24Cubit() : super(News24Initial());

  Future<void> loadNews() async {
    final newsBox = Hive.box('newsBox');

    try {
      if (newsBox.containsKey('news24')) {
        final cachedNews = newsBox.get('news24') as List<RssItem>;
        emit(News24LoadedState(cachedNews));
        return;
      }

      await Future.delayed(const Duration(seconds: 2));
      final response = await http.Client().get(Uri.parse(_top7URL));
      final rssFeed = RssFeed.parse(response.body);

      newsBox.put('news24', rssFeed.items);
      emit(News24LoadedState(rssFeed.items));
    } catch (e) {
      emit(News24ErrorState('Упссс!'));
    }
  }

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
