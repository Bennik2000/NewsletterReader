import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/articles/article_import.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/style/text_style.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';

class ImportArticleButton extends StatelessWidget {
  final NewsletterViewModel newsletter;

  const ImportArticleButton({Key key, this.newsletter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !Platform.isIOS
        ? FlatButton(
            child: Text(
              L.of(context).importArticleButton.toUpperCase(),
              style: TextStyles(context).titleBarFlatButton(),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            onPressed: () async {
              var path = await FilePicker.getFilePath(fileExtension: "pdf");

              if (path != null) {
                await new ArticleImport(
                  kiwi.Container().resolve(),
                  kiwi.Container().resolve(),
                  newsletter.newsletter,
                ).importArticle(path);
              }

              await newsletter.loadArticles();
            },
          )
        : Container();
  }
}
