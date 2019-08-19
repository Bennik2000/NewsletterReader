import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/newsletter_articles_content.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/import_article_button.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

class NewsletterDetailPage extends StatelessWidget {
  final NewsletterViewModel newsletter;

  const NewsletterDetailPage({
    Key key,
    @required this.newsletter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      builder: (c) => newsletter,
      child: Scaffold(
        appBar: AppBar(
          title: Text(newsletter.newsletter.name),
          actions: <Widget>[
            ImportArticleButton(
              newsletter: newsletter,
            )
          ],
        ),
        body: NewsletterArticlesContent(),
      ),
    );
  }
}
