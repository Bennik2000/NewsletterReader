import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/article_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:provider/provider.dart';

import 'article_card.dart';

class ArticlesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewsletterState state, _) {
        print("rebuild grid with ${state.loadedArticles.length} items");
        return GridView.extent(
          childAspectRatio: 1 / sqrt(2),
          crossAxisSpacing: 16,
          maxCrossAxisExtent: 300,
          children: List.generate(state.loadedArticles.length, (i) {
            var index = i;

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ChangeNotifierProvider(
                builder: (c) => new ArticleState(state.loadedArticles[index], state.newsletter),
                child: new ArticleCard(),
              ),
            );
          }),
        );
      },
    );
  }
}
