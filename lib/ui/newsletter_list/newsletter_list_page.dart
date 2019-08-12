import 'package:flutter/material.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_page.dart';
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
        title: Text("Newsletters"),
        actions: <Widget>[
          Consumer(
            builder: (BuildContext context, NewsletterListViewModel viewModel,
                    Widget child) =>
                IconButton(
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
        builder: (BuildContext context, NewsletterListViewModel state, _) =>
            FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {

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
          },
        ),
      ),
    );
  }
}
