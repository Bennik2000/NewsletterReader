import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/style/text_style.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'article_placeholder.dart';
import 'article_thumbnail.dart';

class ArticleCard extends StatelessWidget {
  final NewsletterViewModel newsletter;
  final double borderRadius = 16;

  const ArticleCard({Key key, this.newsletter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ArticleViewModel state, Widget child) =>
          buildCard(context, state),
    );
  }

  Widget buildCard(BuildContext context, ArticleViewModel state) {
    Widget image;

    if (state.article.thumbnailPath != null) {
      image = ArticleThumbnail(
        borderRadius: borderRadius,
        thumbnailPath: state.article.thumbnailPath,
        fadeOutBottom: true,
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(borderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () async {
          await readArticle(context, state);
        },
        onLongPress: () async {
          await articleLongPress(state, context);
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
                        DateFormat.yMMMEd(L.of(context).locale.languageCode)
                            .format(state.article.releaseDate),
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

  Future articleLongPress(
      ArticleViewModel article, BuildContext context) async {
    await showModalBottomSheet(
      builder: (BuildContext context) {
        var buttons = <Widget>[];

        if (article.article.isDownloaded ?? false) {
          buttons.add(new ListTile(
            leading: new Icon(Icons.import_contacts),
            title: new Text(L.of(context).articleMenuRead),
            onTap: () async {
              await readArticle(context, article);
              Navigator.of(context).pop();
            },
          ));

          buttons.add(new ListTile(
            leading: new Icon(Icons.file_download),
            title: new Text(L.of(context).articleMenuDeleteDownload),
            onTap: () async {
              await article.deleteDownloadedArticle();
              Navigator.of(context).pop();
            },
          ));
        } else {
          buttons.add(new ListTile(
            leading: new Icon(Icons.file_download),
            title: new Text(L.of(context).articleMenuDownload),
            onTap: () async {
              Navigator.of(context).pop();
              await article.downloadArticle();
            },
          ));
        }
        buttons.add(Divider(
          color: Theme.of(context).dividerColor,
        ));
        buttons.add(new ListTile(
          leading: new Icon(Icons.delete_forever,
              color: Theme.of(context).errorColor),
          title: new Text(
            L.of(context).articleMenuDelete,
            style: TextStyles(context).textError(),
          ),
          onTap: () async {
            Navigator.of(context).pop();
            await newsletter.deleteArticle(article);
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

  Future readArticle(BuildContext context, ArticleViewModel state) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: new CircularProgressIndicator(),
                ),
                new Text(L.of(context).articleFileOpening),
              ],
            ),
          ),
        );
      },
    );

    await state.articleClicked();

    Navigator.of(context).pop();
  }
}
