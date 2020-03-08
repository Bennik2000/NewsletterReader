import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_get_last_article.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/article_placeholder.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/article_thumbnail.dart';
import 'package:newsletter_reader/ui/style/text_style.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

typedef NewsletterTapCallback = void Function(NewsletterViewModel newsletter);

class NewsletterCardWidget extends StatefulWidget {
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
  _NewsletterCardWidgetState createState() => _NewsletterCardWidgetState();
}

class _NewsletterCardWidgetState extends State<NewsletterCardWidget> {
  Article article;

  @override
  void initState() {
    super.initState();

    loadLastArticle();
  }

  void loadLastArticle() async {
    var getLastArticle = new NewsletterGetLastArticle(
        widget.newsletter.newsletter, kiwi.Container().resolve());
    var a = await getLastArticle.getLastArticleOrNull();

    setState(() {
      article = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 16;
    double height = 150;

    Widget content = InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onLongPress: () {
        widget.onLongPress(widget.newsletter);
      },
      onTap: () {
        widget.onTap(widget.newsletter);
      },
      child: Container(
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: height / sqrt(2),
              child: AnimatedSwitcher(
                child: article != null && article.thumbnailPath != null
                    ? Padding(
                        padding: EdgeInsets.all(borderRadius),
                        child: Container(
                          child: Ink.image(
                            image: FileImage(File(article.thumbnailPath)),
                            child: Container(),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.import_contacts,
                        color: Colors.black26,
                      ),
                duration: Duration(milliseconds: 200),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.newsletter.newsletter.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles(context).cardTitle(),
                    ),
                    Container(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.showAsCard) return content;

    return Container(
      height: 148,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: content,
        elevation: 4,
      ),
    );
  }
}
