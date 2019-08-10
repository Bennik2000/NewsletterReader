import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/articles_list.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/articles_title.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/last_update_information.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/no_articles_empty_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/update_articles_button.dart';
import 'package:provider/provider.dart';

import 'widget/articles_page_background.dart';

class NewsletterArticlesPage extends StatelessWidget {
  final Newsletter _newsletter;

  const NewsletterArticlesPage(this._newsletter);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        builder: (c) => new NewsletterState(
          _newsletter,
          kiwi.Container().resolve(),
          kiwi.Container().resolve(),
          kiwi.Container().resolve(),
        ),
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
          child: ArticlesTitle(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      child: LastUpdatedInformation(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: UpdateArticlesButton(),
                )
              ],
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
                color: Theme.of(context).dividerColor,
              ),
            ),
            Consumer<NewsletterState>(
              builder: (BuildContext context, NewsletterState state, _) {
                Widget widget;

                if (state.isLoaded && state.loadedArticles.isEmpty) {
                  widget = NoArticlesEmptyState();
                } else if (state.isLoaded && state.loadedArticles.isNotEmpty) {
                  widget = ArticlesList();
                } else {
                  widget = Container();
                }

                return Flexible(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: widget,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
