import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/pages/last24_news_page/cubit/news24_cubit.dart';
import 'src/pages/last_news_page/cubit/news_cubit.dart';
import 'src/pages/main_page.dart';
import 'src/utils/res_item.dart';

final newsCubitProvider = Provider<NewsCubit>((ref) => NewsCubit());
final news24CubitProvider = Provider<News24Cubit>((ref) => News24Cubit());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('newsBox');

  Hive.registerAdapter(RssItemAdapter());
  Hive.registerAdapter(EnclosureAdapter());

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
