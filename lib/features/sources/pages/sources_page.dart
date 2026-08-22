import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/sources/catalog.dart';
import '../../shared/widgets/source_card.dart';
import 'source_feed_page.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final columns = orientation == Orientation.portrait ? 1 : 2;
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Другие источники',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'РИА Новости, Хабр, ТАСС и ещё несколько редакций — в одной панели.',
                      style: TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisExtent: 120,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final source = NewsCatalog.extraSources[index];
                    return SourceCard(
                      source: source,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SourceFeedPage(source: source),
                          ),
                        );
                      },
                    );
                  },
                  childCount: NewsCatalog.extraSources.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
