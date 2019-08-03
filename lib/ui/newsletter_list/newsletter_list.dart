import 'package:flutter/material.dart';
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
                    newsletter: newsletter,
                  );
                },
              ),
            );

            state.loadNewsletters();
          },
          onLongPress: (Newsletter newsletter) async {
            await Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new NewsletterEditPage(newsletter);
                },
              ),
            );

            state.loadNewsletters();
          },
        );
      },
      itemCount: state.newsletters.length,
    );
  }
}
