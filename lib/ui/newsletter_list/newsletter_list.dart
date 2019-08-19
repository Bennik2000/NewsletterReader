import 'package:flutter/material.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_export.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/main_page/main_page.dart';
import 'package:newsletter_reader/ui/utils/dialog_utils.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'widgets/newsletter_card.dart';
import 'widgets/newsletter_loading_indicator.dart';
import 'widgets/newsletters_empty_state.dart';

typedef NewsletterEditCallback = void Function(NewsletterViewModel newsletter);

class NewsletterList extends StatelessWidget {
  final NewsletterTapCallback onNewsletterTap;
  final NewsletterEditCallback onNewsletterEdit;
  final NewsletterViewModel selectedItem;
  final bool showAsCards;

  const NewsletterList({
    Key key,
    @required this.onNewsletterTap,
    @required this.onNewsletterEdit,
    this.selectedItem,
    this.showAsCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewsletterListViewModel listViewModel, Widget child) {
        if (listViewModel.isLoading) {
          return NewsletterLoadingIndicator();
        }

        List<NewsletterViewModel> newsletters = listViewModel.newsletters ?? <NewsletterViewModel>[];

        if (newsletters.isEmpty) {
          return NewslettersEmptyState();
        } else {
          return buildNewsletterList(listViewModel);
        }
      },
    );
  }

  Widget buildNewsletterList(NewsletterListViewModel listViewModel) {
    return Consumer(
      builder: (BuildContext context, MasterDetailViewModel masterDetailViewModel, Widget child) => ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return NewsletterCardWidget(
            showAsCard: showAsCards,
            isSelected: listViewModel.newsletters[index] == selectedItem,
            newsletter: listViewModel.newsletters[index],
            onTap: onNewsletterTap,
            onLongPress: (NewsletterViewModel newsletter) async {
              await onNewsletterLongPress(
                context,
                masterDetailViewModel,
                newsletter,
                listViewModel,
              );
            },
          );
        },
        itemCount: listViewModel.newsletters.length,
        separatorBuilder: (BuildContext context, int index) {
          if (!showAsCards) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Divider(height: 1, color: Theme.of(context).dividerColor),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future onNewsletterLongPress(
    BuildContext context,
    MasterDetailViewModel masterDetailViewModel,
    NewsletterViewModel newsletter,
    NewsletterListViewModel listViewModel,
  ) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.edit),
              title: new Text(L.of(context).newsletterMenuEdit),
              onTap: () async {
                Navigator.of(context).pop();
                onNewsletterEdit(newsletter);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.share),
              title: new Text(L.of(context).newsletterMenuExport),
              onTap: () async {
                Navigator.of(context).pop();
                await onExportNewsletterClick(newsletter, context);
              },
            ),
            Divider(),
            new ListTile(
              leading: new Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              title: new Text(
                L.of(context).newsletterMenuDelete,
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();

                await showDialog(
                  context: context,
                  builder: (BuildContext context) => createAlertDialog(
                    context,
                    "${newsletter.newsletter.name} löschen",
                    message: "Der Newsletter ${newsletter.newsletter.name} wird endgültig gelöscht.",
                    okAction: () async {
                      await listViewModel.deleteNewsletter(newsletter);

                      masterDetailViewModel.selectedElement = null;
                    },
                    cancelAction: () {},
                    okText: L.of(context).buttonDelete,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future onExportNewsletterClick(NewsletterViewModel newsletter, BuildContext context) async {
    var result = await new NewsletterExport(newsletter.newsletter).exportNewsletter();

    if (result) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => createAlertDialog(
          context,
          L.of(context).exportNewsletterDialogTitle,
          message: L.of(context).exportNewsletterDialogMessage,
          okAction: () => {},
          cancelAction: null,
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) => createAlertDialog(
          context,
          L.of(context).exportNewsletterFailedDialogTitle,
          message: L.of(context).exportNewsletterFailedDialogMessage,
          okAction: () => {},
          cancelAction: null,
        ),
      );
    }
  }
}
