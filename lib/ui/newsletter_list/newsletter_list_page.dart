import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_import.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_page.dart';
import 'package:newsletter_reader/ui/utils/dialog_utils.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'newsletter_list.dart';
import 'widgets/newsletter_card.dart';

typedef SettingsClicked = void Function();

class NewsletterListPage extends StatelessWidget {
  final NewsletterTapCallback onNewsletterTap;
  final NewsletterEditCallback onNewsletterEdit;
  final SettingsClicked onSettingsClicked;
  final NewsletterViewModel selectedItem;
  final bool showAsCards;

  const NewsletterListPage({
    Key key,
    @required this.onNewsletterTap,
    @required this.onNewsletterEdit,
    @required this.onSettingsClicked,
    this.selectedItem,
    this.showAsCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).newslettersListPageTitle),
        actions: <Widget>[
          Consumer(
            builder: (BuildContext context, NewsletterListViewModel viewModel, Widget child) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                onSettingsClicked();
              },
            ),
          ),
        ],
      ),
      body: NewsletterList(
        onNewsletterTap: onNewsletterTap,
        onNewsletterEdit: onNewsletterEdit,
        selectedItem: selectedItem,
        showAsCards: showAsCards,
      ),
      floatingActionButton: Consumer(
        builder: (BuildContext context, NewsletterListViewModel state, _) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await onNewNewsletterPressed(context, state);
          },
        ),
      ),
    );
  }

  Future onNewNewsletterPressed(BuildContext context, NewsletterListViewModel state) async {
    var newsletterImport = new NewsletterImport(kiwi.Container().resolve());

    bool canImportNewsletter = await newsletterImport.getCanImportNewsletter();

    if (canImportNewsletter) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => createAlertDialog(
          context,
          L.of(context).couldImportNewsletterDialogTitle,
          message: L.of(context).couldImportNewsletterDialogMessage,
          cancelText: L.of(context).couldImportNewsletterDialogButtonNewNewsletter,
          okText: L.of(context).couldImportNewsletterDialogButtonImportNewsletter,
          okAction: () async {
            await newsletterImport.importNewsletter();
            await state.loadNewsletters();
          },
          cancelAction: () async {
            await showNewNewsletterPage(context, state);
          },
        ),
      );
    } else {
      await showNewNewsletterPage(context, state);
    }
  }

  Future showNewNewsletterPage(BuildContext context, NewsletterListViewModel state) async {
    var viewModel = new NewsletterViewModel(new Newsletter(), null, null, null, null, null);

    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new NewsletterEditPage(viewModel);
        },
      ),
    );

    viewModel.dispose();

    await state.loadNewsletters();
  }
}
