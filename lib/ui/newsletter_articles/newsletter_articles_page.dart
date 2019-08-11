import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/articles_title.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'newsletter_articles_content.dart';
import 'widget/articles_page_background.dart';

class NewsletterArticlesPage extends StatelessWidget {
  final NewsletterViewModel newsletter;

  const NewsletterArticlesPage({Key key, this.newsletter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ListenableProvider(
        builder: (c) => newsletter,
        child: Stack(
          children: <Widget>[
            ArticlesPageBackground(),
            buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Flexible(
          child: ArticlesTitle(
            newsletter: newsletter,
          ),
          flex: 1,
        ),
        Expanded(
          child: buildContent(context),
          flex: 6,
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(2, 2, 2, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        elevation: 16,
        child: NewsletterArticlesContent(),
      ),
    );
  }
}
