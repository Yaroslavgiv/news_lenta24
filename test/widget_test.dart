import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:news_test_app/app.dart';
import 'package:news_test_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('lenta24_test');
    await bootstrap(hivePath: tempDir.path);
  });

  tearDown(() async {
    if (Hive.isBoxOpen('newsBox')) {
      await Hive.box('newsBox').close();
    }
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('нижняя навигация содержит три раздела', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NewsApp()));
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Лента'), findsOneWidget);
    expect(find.text('24 часа'), findsOneWidget);
    expect(find.text('Источники'), findsOneWidget);
    expect(find.text('LENTA24'), findsOneWidget);
  });

  testWidgets('вкладка источников показывает РИА Новости и Хабр', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NewsApp()));
    await tester.pump();

    await tester.tap(find.text('Источники'));
    await tester.pump();

    expect(find.text('ИСТОЧНИКИ'), findsOneWidget);
    expect(find.text('Другие источники'), findsOneWidget);
    expect(find.text('РИА Новости'), findsOneWidget);
    expect(find.text('Хабр'), findsOneWidget);
    expect(find.text('ТАСС'), findsOneWidget);
    expect(find.text('Интерфакс'), findsOneWidget);
  });
}
