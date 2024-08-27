import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_test_app/src/pages/news_detail_page.dart';

import '../pages/last_news_page/cubit/news_cubit.dart';
import '../utils/utils.dart';
import 'image_news_widget.dart';

class ListItemWidget extends StatelessWidget {
  final RssItem item;

  const ListItemWidget({
    super.key,
    required this.item,
    required String searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final newsCubit = context.read<NewsCubit>();
    return InkWell(
      onTap: () {
        newsCubit.markAsRead(item.link);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              newsItem: item,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.green, spreadRadius: 3)],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                    child: Text(
                      item.author ?? 'Автор неизвестен',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ImageNewsWidget(
                          urlImage: item.enclosure!.url!,
                          width: 120,
                          height: 90,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        item.title!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 5,
                      )),
                    ],
                  ),
                  Expanded(
                      child: Text(
                    item.description!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    maxLines: 10,
                  )),
                  InkWell(
                    child: const Text('Читать на сайте',
                        style: TextStyle(decoration: TextDecoration.underline)),
                    onTap: () => launchUniversalLink(item.link!),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
