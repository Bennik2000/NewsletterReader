import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_export.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/newsletter_articles_page.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_page.dart';
import 'package:newsletter_reader/ui/newsletter_list/state/newsletter_list_state.dart';
import 'package:newsletter_reader/ui/newsletter_list/widgets/newsletters_empty_state.dart';
import 'package:provider/provider.dart';

import 'widgets/newsletter_card.dart';
import 'widgets/newsletter_loading_indicator.dart';

class NewsletterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewsletterListState state, _) {
        Widget widget = new Container();

        if (state.isLoading || !state.isLoaded) {
          widget = NewsletterLoadingIndicator();
        }

        if (state.isLoaded && state.newsletters.isNotEmpty) {
          widget = buildNewsletterList(state);
        }

        if (state.isLoaded && state.newsletters.isEmpty) {
          widget = NewslettersEmptyState();
        }

        return widget;
      },
    );
  }

  Widget buildNewsletterList(NewsletterListState state) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return NewsletterCardWidget(
          newsletter: state.newsletters[index],
          onTap: (Newsletter newsletter) async {
            await Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new NewsletterArticlesPage(
                    newsletter,
                  );
                },
              ),
            );

            state.loadNewsletters();
          },
          onLongPress: (Newsletter newsletter) async {
            await onNewsletterLongPress(context, newsletter, state);
          },
        );
      },
      itemCount: state.newsletters.length,
    );
  }

  Future onNewsletterLongPress(BuildContext context, Newsletter newsletter, NewsletterListState state) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.edit),
              title: new Text('Bearbeiten'),
              onTap: () async {
                Navigator.of(context).pop();
                await onEditNewsletterClick(context, newsletter, state);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.share),
              title: new Text('Exportieren'),
              onTap: () async {
                Navigator.of(context).pop();
                await onExportNewsletterClick(newsletter, context);
              },
            )
          ],
        );
      },
    );
  }

  Future onExportNewsletterClick(Newsletter newsletter, BuildContext context) async {
    await new NewsletterExport(newsletter, kiwi.Container().resolve()).shareNewsletter();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Newsletter exportiert"),
          content: new Text("Der Newsletter wurde exportiert"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future onEditNewsletterClick(BuildContext context, Newsletter newsletter, NewsletterListState state) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new NewsletterEditPage(newsletter);
        },
      ),
    );

    await state.loadNewsletters();
  }
}
