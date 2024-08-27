import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/pages/last24_news_page/cubit/news24_cubit.dart';
import 'src/pages/last_news_page/cubit/news_cubit.dart';
import 'src/pages/main_page.dart';
import 'src/utils/res_item.dart';

// Define providers for NewsCubit and News24Cubit
final newsCubitProvider = Provider<NewsCubit>((ref) => NewsCubit());
final news24CubitProvider = Provider<News24Cubit>((ref) => News24Cubit());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('newsBox');

  // Register Hive adapters
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
