import 'package:flutter/material.dart';

import '../models/news_source.dart';

abstract final class NewsCatalog {
  static const lentaTop = NewsSource(
    id: 'lenta_top',
    name: 'Lenta.ru',
    description: 'Главные материалы редакции',
    rssUrl: 'https://lenta.ru/rss/top7',
    siteUrl: 'https://lenta.ru',
    color: Color(0xFFC62828),
    initials: 'L',
    isPrimary: true,
  );

  static const lenta24 = NewsSource(
    id: 'lenta_24',
    name: 'Lenta.ru · 24 часа',
    description: 'Все новости за последние сутки',
    rssUrl: 'https://lenta.ru/rss/last24',
    siteUrl: 'https://lenta.ru',
    color: Color(0xFF8E2442),
    initials: '24',
    isPrimary: true,
  );

  static const ria = NewsSource(
    id: 'ria',
    name: 'РИА Новости',
    description: 'Оперативная лента российского информагентства',
    rssUrl: 'https://ria.ru/export/rss2/archive/index.xml',
    siteUrl: 'https://ria.ru',
    color: Color(0xFFE31E24),
    initials: 'РИА',
  );

  static const habr = NewsSource(
    id: 'habr',
    name: 'Хабр',
    description: 'Технологии, разработка и IT-индустрия',
    rssUrl: 'https://habr.com/ru/rss/articles/?fl=ru',
    siteUrl: 'https://habr.com',
    color: Color(0xFF4384B8),
    initials: 'ХБ',
  );

  static const tass = NewsSource(
    id: 'tass',
    name: 'ТАСС',
    description: 'Официальная хроника и мировые события',
    rssUrl: 'https://tass.ru/rss/v2.xml',
    siteUrl: 'https://tass.ru',
    color: Color(0xFF0033A0),
    initials: 'Т',
  );

  static const interfax = NewsSource(
    id: 'interfax',
    name: 'Интерфакс',
    description: 'Деловые и политические новости',
    rssUrl: 'https://www.interfax.ru/rss',
    siteUrl: 'https://www.interfax.ru',
    color: Color(0xFF222222),
    initials: 'ИФ',
  );

  static const kommersant = NewsSource(
    id: 'kommersant',
    name: 'Коммерсантъ',
    description: 'Экономика, бизнес и аналитика',
    rssUrl: 'https://www.kommersant.ru/RSS/news.xml',
    siteUrl: 'https://www.kommersant.ru',
    color: Color(0xFF1A1A1A),
    initials: 'Ъ',
  );

  static const izvestia = NewsSource(
    id: 'izvestia',
    name: 'Известия',
    description: 'Общество, политика и культура',
    rssUrl: 'https://iz.ru/xml/rss/all.xml',
    siteUrl: 'https://iz.ru',
    color: Color(0xFFB71C1C),
    initials: 'ИЗ',
  );

  static const gazeta = NewsSource(
    id: 'gazeta',
    name: 'Газета.ру',
    description: 'Лента общественно-политических новостей',
    rssUrl: 'https://www.gazeta.ru/export/rss/lenta.xml',
    siteUrl: 'https://www.gazeta.ru',
    color: Color(0xFF0D47A1),
    initials: 'Г',
  );

  static const meduza = NewsSource(
    id: 'meduza',
    name: 'Meduza',
    description: 'Независимые материалы и разборы',
    rssUrl: 'https://meduza.io/rss/all',
    siteUrl: 'https://meduza.io',
    color: Color(0xFF000000),
    initials: 'M',
  );

  static const extraSources = <NewsSource>[
    ria,
    habr,
    tass,
    interfax,
    kommersant,
    izvestia,
    gazeta,
    meduza,
  ];

  static const all = <NewsSource>[
    lentaTop,
    lenta24,
    ...extraSources,
  ];

  static NewsSource byId(String id) {
    return all.firstWhere(
      (source) => source.id == id,
      orElse: () => lentaTop,
    );
  }
}
