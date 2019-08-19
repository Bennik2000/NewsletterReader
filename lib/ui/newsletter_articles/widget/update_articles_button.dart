import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

class UpdateArticlesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewsletterViewModel value, Widget child) => IconButton(
        icon: Icon(
          Icons.refresh,
          color: Theme.of(context).accentColor,
        ),
        iconSize: 28,
        onPressed: value.isUpdating || value.isLoading ? null : value.updateArticles,
      ),
    );
  }
}
