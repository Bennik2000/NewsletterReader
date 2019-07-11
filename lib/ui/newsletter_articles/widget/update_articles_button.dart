import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:provider/provider.dart';

class UpdateArticlesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsletterState>(
      builder: (BuildContext context, NewsletterState value, Widget child) => FlatButton(
            onPressed: value.isUpdating || value.isLoading ? null : value.updateArticles,
            child: Text("Aktualisieren".toUpperCase()),
            textColor: Colors.amber,
          ),
    );
  }
}
