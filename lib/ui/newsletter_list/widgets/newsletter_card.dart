import 'package:flutter/material.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/widget/MaxSizeIcon.dart';

typedef NewsletterTapCallback = void Function(Newsletter newsletter);

class NewsletterCardWidget extends StatelessWidget {
  final Newsletter newsletter;
  final NewsletterTapCallback onTap;
  final NewsletterTapCallback onLongPress;

  const NewsletterCardWidget({Key key, this.newsletter, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          onTap(newsletter);
        },
        onLongPress: () {
          onLongPress(newsletter);
        },
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: MaxSizeIcon(Icons.import_contacts),
                  height: 40,
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          newsletter.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
