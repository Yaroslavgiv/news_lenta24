import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

Future<void> bootstrap({String? hivePath}) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (hivePath == null) {
    await Hive.initFlutter();
  } else {
    Hive.init(hivePath);
  }
  if (!Hive.isBoxOpen('newsBox')) {
    await Hive.openBox('newsBox');
  }
}

Future<void> main() async {
  await bootstrap();
  runApp(
    const ProviderScope(
      child: NewsApp(),
    ),
  );
}
