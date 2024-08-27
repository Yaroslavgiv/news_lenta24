Documentation

Stack and Technologies Used:


Flutter: The main framework used for building the UI of the application.

Riverpod: A provider package for state management.

Bloc: A predictable state management library for Flutter.

Hive: A lightweight and fast key-value database used for local storage.

Dart RSS: A library for parsing RSS feeds.

HTTP: A package for making HTTP requests.

Cached Network Image: A package for displaying images from the internet with caching functionality.

Carousel Slider: A package for creating image carousels.

Key Features:


State Management: Utilizes Riverpod and Bloc for managing the state of the application.

Local Storage: Uses Hive for storing and retrieving news data locally.

RSS Feed Parsing: Fetches and parses RSS feeds using the Dart RSS library.

Image Caching: Displays images with caching to improve performance and reduce data usage.

Carousel Display: Provides a carousel slider for showcasing news items.

Search Functionality: Allows users to search for news articles.

Responsive UI: Ensures the application is responsive and visually appealing across different devices.


1. The main application file (main.dart)
Necessary dependencies are initialized here, such as Hive for local data storage.
A Provider is being created for qubits (NewsCubit, News24Cubit), which will manage the state of news pages.
The application is launched using ProviderScope, which allows you to use Riverpod to manage the state.

2. Data model (res_item.dart)
The RssItem model is used to represent a news item, and the Enclosure is used to store information about multimedia attachments (for example, the URL of an image).
These models are adapted for storage using Hive.

3. Qubits for state management (for example, news_cubit.dart, news24_cubit.dart)
NewsCubit and News24Cubit manage the loading status of news from RSS feeds. They upload data, mark the news as read, and handle errors.
Qubits use the state to display various content (for example, download indication, news list, error messages).

4. News display widgets (list_item_widget.dart, image_news_widget.dart)
ListItemWidget is responsible for displaying individual news items such as headline, author, description and image.
ImageNewsWidget handles image loading using CachedNetworkImage, which improves performance and user experience.

5. The main page of the application (main_page.dart)
The main page contains a bottom navigation bar that allows the user to switch between different tabs (for example, latest news, news for 24 hours).
CarouselSlider is used to create a news slider, which adds interactivity to the interface.

6. Using Bloc and Riverpod
The blockprovider and the blockbuilder are used for state management, which allows you to respond to state changes and update the UI accordingly.
The ConsumerWidget from Riverpod is used to get qubits and further manage the state.

7. Click and click processing
When you click on a news item, it is marked as read and you are redirected to the page with the details of the news.
Highlights:  Using Hive to cache and store the status of read news.
Image processing and caching to improve performance.
Animations and effects using the flutter_staggered_animations and carousel_slider packages.



Документация

Стек и используемые технологии:

Flutter: Основная платформа, используемая для создания пользовательского интерфейса приложения.
Riverpod: Пакет провайдера для управления состоянием.
Bloc: Библиотека предсказуемого управления состоянием для Flutter.
Hive: Легкая и быстрая база данных значений ключей, используемая для локального хранения.
Dart RSS: Библиотека для анализа RSS-каналов.
HTTP: Пакет для выполнения HTTP-запросов.
Cached Network Image: Пакет для отображения изображений из Интернета с функцией кэширования.
Carousel Slider: Пакет для создания каруселей изображений.

ключевые функции:

Управление состоянием: Использует Riverpod и Block для управления состоянием приложения.
Локальное хранилище: Использует Hive для локального хранения и извлечения новостных данных.
Анализ RSS-каналов: Извлекает и анализирует RSS-каналы с помощью библиотеки Dart RSS.
Кэширование изображений: Отображение изображений с кэшированием для повышения производительности и сокращения использования данных.
Отображение карусели: Предоставляет ползунок карусели для демонстрации новостей.
Функция поиска: Позволяет пользователям искать новостные статьи.
Адаптивный пользовательский интерфейс: обеспечивает адаптивность и визуальную привлекательность приложения на разных устройствах.
