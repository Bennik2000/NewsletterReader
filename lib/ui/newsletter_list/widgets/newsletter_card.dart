import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';

typedef NewsletterTapCallback = void Function(NewsletterViewModel newsletter);

class NewsletterCardWidget extends StatelessWidget {
  final NewsletterViewModel newsletter;
  final NewsletterTapCallback onTap;
  final NewsletterTapCallback onLongPress;
  final bool isSelected;
  final bool showAsCard;

  const NewsletterCardWidget({
    Key key,
    this.newsletter,
    this.onTap,
    this.onLongPress,
    this.isSelected,
    this.showAsCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = ListTile(
      title: Text(
        newsletter.newsletter.name,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Icon(Icons.import_contacts),
      onLongPress: () {
        onLongPress(newsletter);
      },
      onTap: () {
        onTap(newsletter);
      },
      selected: isSelected,
    );

    if (!showAsCard) return content;

    return Card(
      child: content,
    );
  }
}
