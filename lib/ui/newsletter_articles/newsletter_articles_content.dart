import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/style/text_style.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'widget/articles_list.dart';
import 'widget/last_update_information.dart';
import 'widget/no_articles_empty_state.dart';
import 'widget/update_articles_button.dart';

class NewsletterArticlesContent extends StatelessWidget {
  const NewsletterArticlesContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    L.of(context).newsletterAvailableArticles,
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
          child: Consumer(
            builder: (BuildContext context, NewsletterViewModel value,
                    Widget child) =>
                Opacity(
              opacity: value.error != null ? 1 : 0,
              child: Text(
                value.error ?? "",
                style: TextStyles(context).textError(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Consumer(
            builder: (BuildContext context, NewsletterViewModel value,
                    Widget child) =>
                Opacity(
              opacity: (value.isUpdating) ? 1 : 0,
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
        Consumer(
          builder: (BuildContext context, NewsletterViewModel state, _) {
            Widget widget;

            if (!state.isLoading &&
                state.articles != null &&
                state.articles.isEmpty) {
              widget = NoArticlesEmptyState();
            } else if (!state.isLoading &&
                state.articles != null &&
                state.articles.isNotEmpty) {
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
    );
  }
}
