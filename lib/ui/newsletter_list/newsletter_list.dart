import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_export.dart';
import 'package:newsletter_reader/ui/newsletter_list/widgets/newsletters_empty_state.dart';
import 'package:newsletter_reader/ui/utils/dialog_utils.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'widgets/newsletter_card.dart';
import 'widgets/newsletter_loading_indicator.dart';

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
    var listViewModel = Provider.of<NewsletterListViewModel>(context);

    return FutureBuilder(
      future: listViewModel.getNewsletters(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return NewsletterLoadingIndicator();
        }

        if(snapshot.hasError){
          return Center(
            child: Text("Failed to load newsletters!")
          );
        }

        List<NewsletterViewModel> newsletters = snapshot.data ?? <NewsletterViewModel>[];

        if(newsletters.isEmpty){
          return NewslettersEmptyState();
        }
        else{
          return buildNewsletterList(newsletters);
        }
      },
    );
  }

  Widget buildNewsletterList(List<NewsletterViewModel> newsletters) {
    return ListView.separated(


      itemBuilder: (BuildContext context, int index) {
        return NewsletterCardWidget(
          showAsCard: showAsCards,
          isSelected: newsletters[index] == selectedItem,
          newsletter: newsletters[index],
          onTap: onNewsletterTap,
          onLongPress: (NewsletterViewModel newsletter) async {
            await onNewsletterLongPress(context, newsletter);
          },
        );
      },
      itemCount: newsletters.length,
      separatorBuilder: (BuildContext context, int index) {
        if (!showAsCards) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Divider(
              height: 1,
              color: Theme.of(context).dividerColor
            ),
          );
        }
        else {
          return Container();
        }
      },
    );
  }

  Future onNewsletterLongPress(BuildContext context, NewsletterViewModel newsletter) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.edit),
              title: new Text('Bearbeiten'),
              onTap: () async {
                Navigator.of(context).pop();
                onNewsletterEdit(newsletter);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.share),
              title: new Text('Exportieren'),
              onTap: () async {
                Navigator.of(context).pop();
                await onExportNewsletterClick(newsletter, context);
              },
            )
          ],
        );
      },
    );
  }

  Future onExportNewsletterClick(
      NewsletterViewModel newsletter, BuildContext context) async {
    await new NewsletterExport(newsletter.newsletter, kiwi.Container().resolve())
        .shareNewsletter();

    await showDialog(
      context: context,
      builder: (BuildContext context) => createAlertDialog(
        context,
        "Newsletter exportiert",
        "Der Newsletter wurde exportiert",
        okAction: () => {},
        cancelAction: null,
      ),
    );
  }
}
