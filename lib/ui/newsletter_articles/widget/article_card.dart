import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/article_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:provider/provider.dart';

import 'article_placeholder.dart';
import 'article_thumbnail.dart';

class ArticleCard extends StatelessWidget {
  final double borderRadius = 16;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ArticleState state, _) => buildCard(context, state),
    );
  }

  Widget buildCard(BuildContext context, ArticleState state) {
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
    } else if (!(state.article.isDownloaded ?? false)) {
      button = Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.file_download),
          color: Theme.of(context).accentColor,
          onPressed: state.downloadArticle,
        ),
      );
    } else {
      button = Container();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(borderRadius)),
      child: Consumer(
        builder: (BuildContext context, NewsletterState newsletterState, _) {
          return InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: state.articleClicked,
            onLongPress: () async {
              await articleLongPress(state, newsletterState, context);
            },
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 24),
                          child: Text(
                            state.article.id.toString(),
                            //DateFormat.yMMMd().format(state.article.releaseDate),
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
          );
        },
      ),
    );
  }

  Future articleLongPress(ArticleState state, NewsletterState newsletterState, BuildContext context) async {
    await showModalBottomSheet(
      builder: (BuildContext context) {
        var buttons = <Widget>[];

        if (state.article.isDownloaded ?? false) {
          buttons.add(new ListTile(
            leading: new Icon(Icons.import_contacts),
            title: new Text('Beitrag Lesen'),
            onTap: () {
              state.articleClicked();
              Navigator.of(context).pop();
            },
          ));

          buttons.add(new ListTile(
            leading: new Icon(Icons.file_download),
            title: new Text('Download entfernen'),
            onTap: () async {
              await state.deleteDownloadedArticle();
              Navigator.of(context).pop();
            },
          ));
        } else {
          buttons.add(new ListTile(
            leading: new Icon(Icons.file_download),
            title: new Text('Herunterladen'),
            onTap: () async {
              Navigator.of(context).pop();
              await state.downloadArticle();
            },
          ));
        }
        buttons.add(Divider(
          color: Theme.of(context).dividerColor,
        ));
        buttons.add(new ListTile(
          leading: new Icon(Icons.delete_forever, color: Theme.of(context).errorColor),
          title: new Text(
            'Beitrag löschen',
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          onTap: () async {
            Navigator.of(context).pop();
            newsletterState.deleteArticle(state.article);
          },
        ));

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: buttons,
        );
      },
      context: context,
    );
  }
}
