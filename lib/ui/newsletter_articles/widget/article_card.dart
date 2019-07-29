import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/article_state.dart';
import 'package:provider/provider.dart';

import 'article_placeholder.dart';
import 'article_thumbnail.dart';

class ArticleCard extends StatelessWidget {
  final double borderRadius = 16;

  @override
  Widget build(BuildContext context) {
    return new Consumer(
      builder: (BuildContext context, ArticleState state, _) => buildCard(state),
    );
  }

  Widget buildCard(ArticleState state) {
    Widget image;

    if (state.article.thumbnailPath != null) {
      image = ArticleThumbnail(
        borderRadius: borderRadius,
        thumbnailPath: state.article.thumbnailPath,
      );
    } else {
      image = Padding(
        child: ArticlePlaceholder(state.article.id % 3),
        padding: EdgeInsets.fromLTRB(0, 8, 0, 24),
      );
    }

    Widget button;

    if (state.isDownloading ?? false) {
      button = Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      );
    } else if (state.article.isDownloaded ?? false) {
      button = Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(Icons.delete_outline),
          color: Colors.amber.shade500,
          onPressed: state.deleteArticle,
        ),
      );
    } else {
      button = Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.file_download),
          color: Colors.amber.shade500,
          onPressed: state.downloadArticle,
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(borderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: state.articleClicked,
        child: Stack(
          children: <Widget>[
            AnimatedSwitcher(
              child: image,
              duration: Duration(milliseconds: 200),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        DateFormat.yMMMd().format(state.article.releaseDate),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  button,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
