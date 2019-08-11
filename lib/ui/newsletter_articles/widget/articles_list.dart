import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'article_card.dart';

class ArticlesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewsletterViewModel state, _) {
        return GridView.extent(
          childAspectRatio: 1 / sqrt(2),
          crossAxisSpacing: 16,
          maxCrossAxisExtent: 300,
          children: List.generate(state.articles.length, (i) {
            return Padding(
              key: ObjectKey(state.articles[i]),
              padding: const EdgeInsets.all(4.0),
              child: ListenableProvider.value(
                value: state.articles[i],
                child: new ArticleCard(),
              ),
            );
          }),
        );
      },
    );
  }
}
