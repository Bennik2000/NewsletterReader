import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:provider/provider.dart';

class ArticlesTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Icon(
                  Icons.import_contacts,
                  color: Theme.of(context).primaryTextTheme.title.color,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Consumer<NewsletterState>(
                  builder: (BuildContext context, NewsletterState state, _) => Text(
                    state.newsletter.name,
                    style: TextStyle(
                      fontSize: 35,
                      color: Theme.of(context).primaryTextTheme.title.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
