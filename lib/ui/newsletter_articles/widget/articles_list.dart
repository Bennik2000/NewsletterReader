import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:provider/provider.dart';

import 'article_card.dart';

class ArticlesList extends StatelessWidget {
  final Newsletter _newsletter;

  const ArticlesList(this._newsletter);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewsletterState state, Widget child) => GridView.count(
        childAspectRatio: 1 / sqrt(2),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        children: List.generate(state.loadedArticles.length, (i) {
          return Padding(padding: const EdgeInsets.all(4.0), child: new ArticleCard(_newsletter, state.loadedArticles[i]));
        }),
      ),
    );
  }
}
