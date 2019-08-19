import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';

class NewslettersEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(64, 128, 64, 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(L.of(context).noNewslettersEmptyState),
        ],
      ),
    );
  }
}
