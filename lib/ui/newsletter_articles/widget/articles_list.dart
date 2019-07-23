import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/article_state.dart';
import 'package:provider/provider.dart';

import 'article_card.dart';

class ArticlesList extends StatelessWidget {
  final List<Article> loadedArticles;
  final Newsletter _newsletter;

  const ArticlesList(this.loadedArticles, this._newsletter);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1 / sqrt(2),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        children: List.generate(loadedArticles.length, (i) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: new ChangeNotifierProvider(
              builder: (c) => new ArticleState(loadedArticles[i], _newsletter),
              child: new ArticleCard(),
            ),
          );
        }),
      ),
    );
  }
}
