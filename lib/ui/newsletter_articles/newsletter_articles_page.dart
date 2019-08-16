import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/articles/article_import.dart';
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
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Import".toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.button.color,
              ),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            onPressed: () async {
              var path = await FilePicker.getFilePath(fileExtension: "pdf");

              if (path != null) {
                await new ArticleImport(
                  kiwi.Container().resolve(),
                  kiwi.Container().resolve(),
                  newsletter.newsletter,
                ).importArticle(path);
              }

              await newsletter.loadArticles();
            },
          )
        ],
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
