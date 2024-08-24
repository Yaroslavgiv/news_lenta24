import 'package:bloc/bloc.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'news_state.dart';

const _top7URL = 'https://lenta.ru/rss/top7';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  Future<void> loadNews() async {
    final newsBox = Hive.box('newsBox');
    try {
      if (newsBox.containsKey('news')) {
        final cachedNews = newsBox.get('news') as List<RssItem>;
        emit(NewsLoadedState(cachedNews));
        return;
      }

      await Future.delayed(const Duration(seconds: 2));
      final response = await http.Client().get(Uri.parse(_top7URL));
      final rssFeed = RssFeed.parse(response.body);

      newsBox.put('news', rssFeed.items);
      emit(NewsLoadedState(rssFeed.items));
    } catch (e) {
      emit(NewsErrorState('Упссс!'));
    }
  }

  Future<void> reloadNews() async {
    emit(NewsInitial());
    await loadNews();
  }

  @override
  Future<void> close() {
    Hive.box('newsBox').close();
    return super.close();
  }
}
