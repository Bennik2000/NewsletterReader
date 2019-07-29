import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_export.dart';
import 'package:newsletter_reader/data/filestorage/file_public_repository.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/articles_list.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/articles_page_background.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/articles_title.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/last_update_information.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/no_articles_empty_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/update_articles_button.dart';
import 'package:provider/provider.dart';

class NewsletterArticlesPage extends StatefulWidget {
  final Newsletter newsletter;

  const NewsletterArticlesPage({Key key, this.newsletter}) : super(key: key);

  @override
  _NewsletterArticlesPageState createState() => _NewsletterArticlesPageState(newsletter);
}

class _NewsletterArticlesPageState extends State<NewsletterArticlesPage> {
  final Newsletter _newsletter;

  _NewsletterArticlesPageState(Newsletter newsletter) : _newsletter = newsletter {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              new NewsletterExport(_newsletter, new FilePublicRepository()).shareNewsletter();
            },
          )
        ],
      ),
      body: ChangeNotifierProvider(
        builder: (c) => new NewsletterState(
          _newsletter,
          kiwi.Container().resolve(),
          kiwi.Container().resolve(),
        ),
        child: Stack(
          children: <Widget>[
            ArticlesPageBackground(),
            buildBody(),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Flex(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: ArticlesTitle(),
        ),
        Flexible(
          flex: 7,
          child: buildContent(),
        )
      ],
      direction: Axis.vertical,
    );
  }

  Widget buildContent() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Verfügbare Ausgaben",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LastUpdatedInformation(),
                  UpdateArticlesButton(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Consumer<NewsletterState>(
                builder: (BuildContext context, NewsletterState value, Widget child) => Opacity(
                  opacity: value.error != null ? 1 : 0,
                  child: Text(
                    value.error ?? "",
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Consumer<NewsletterState>(
                builder: (BuildContext context, NewsletterState value, Widget child) => Opacity(
                  opacity: (value.isLoading || value.isUpdating) ? 1 : 0,
                  child: LinearProgressIndicator(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Divider(
                height: 1,
                color: Colors.black12,
              ),
            ),
            Consumer<NewsletterState>(
              builder: (BuildContext context, NewsletterState state, _) {
                if (state.isLoaded && state.loadedArticles.isEmpty) {
                  return NoArticlesEmptyState();
                } else if (state.isLoaded && state.loadedArticles.isNotEmpty) {
                  return ArticlesList(state.loadedArticles, _newsletter);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
