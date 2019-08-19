import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_import.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/utils/dialog_utils.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';

class ImportNewsletterButton extends StatelessWidget {
  final NewsletterListViewModel newsletterListViewModel;

  const ImportNewsletterButton({Key key, this.newsletterListViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        L.of(context).importNewsletterButton.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryTextTheme.button.color,
        ),
      ),
      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      onPressed: () => doImportNewsletter(context),
    );
  }

  Future doImportNewsletter(BuildContext context) async {
    var result = await new NewsletterImport(kiwi.Container().resolve()).importNewsletter();

    if (result) {
      await newsletterListViewModel.loadNewsletters();

      await showDialog(
        context: context,
        builder: (BuildContext context) => createAlertDialog(
          context,
          L.of(context).importNewsletterDialogTitle,
          okAction: () {},
          cancelAction: null,
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) => createAlertDialog(
          context,
          L.of(context).importNewsletterFailedDialogTitle,
          message: L.of(context).importNewsletterFailedDialogMessage,
          okAction: () {},
          cancelAction: null,
        ),
      );
    }
  }
}
