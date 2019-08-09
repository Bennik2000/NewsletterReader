import 'package:flutter/material.dart';
import 'package:newsletter_reader/model/model.dart';

typedef NewsletterTapCallback = void Function(Newsletter newsletter);

class NewsletterCardWidget extends StatelessWidget {
  final Newsletter newsletter;
  final NewsletterTapCallback onTap;
  final NewsletterTapCallback onLongPress;

  const NewsletterCardWidget({Key key, this.newsletter, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          newsletter.name,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Icon(Icons.import_contacts),
        onLongPress: () {
          onLongPress(newsletter);
        },
        onTap: () {
          onTap(newsletter);
        },
      ),
    );
  }
}
