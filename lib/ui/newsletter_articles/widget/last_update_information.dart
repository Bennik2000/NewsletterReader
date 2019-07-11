import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:provider/provider.dart';

class LastUpdatedInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsletterState>(
      builder: (BuildContext context, NewsletterState value, Widget child) => Text(
            "Aktualisiert am " + (value.newsletter?.lastUpdated?.toIso8601String() ?? ""),
            style: TextStyle(color: Colors.black54),
          ),
    );
  }
}
