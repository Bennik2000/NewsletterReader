import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/newsletter_articles/newsletter_articles_page.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_page.dart';
import 'package:newsletter_reader/ui/settings/settings_page.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'package:kiwi/kiwi.dart' as kiwi;

import 'newsletter_detail_page.dart';
import 'newsletter_list_page.dart';

class NewslettersMasterDetailContainer extends StatefulWidget {
  @override
  _NewslettersMasterDetailContainerState createState() =>
      _NewslettersMasterDetailContainerState();
}

class _NewslettersMasterDetailContainerState
    extends State<NewslettersMasterDetailContainer> {
  dynamic selectedElement;

  @override
  Widget build(BuildContext context) {
    var widget;
    if (isTablet()) {
      widget = buildTabletLayout(context);
    } else {
      widget = buildPhoneLayout(context);
    }

    return Material(
      child: Provider(
        builder: (BuildContext context) {
          return NewsletterListViewModel(
            kiwi.Container().resolve(),
            kiwi.Container().resolve(),
            kiwi.Container().resolve(),
            kiwi.Container().resolve(),
            kiwi.Container().resolve(),
            kiwi.Container().resolve(),
          );
        },
        child: widget,
      ),
    );
  }

  Widget buildPhoneLayout(BuildContext context) {
    return NewsletterListPage(
      showAsCards: true,
      onNewsletterTap: (NewsletterViewModel newsletter) async {
        await navigateToNewsletter(context, newsletter);
      },
      onNewsletterEdit: (NewsletterViewModel newsletter) async {
        await editNewsletter(context, newsletter);
      }, 
      onSettingsClicked: () async {
        await navigateToSettings(context);
      },
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    Widget content;

    if (selectedElement is NewsletterViewModel) {
      var newsletter = selectedElement as NewsletterViewModel;
      content = NewsletterDetailPage(
        newsletter: newsletter,
        key: ObjectKey(selectedElement)
      );

    } else if(selectedElement is SettingElement){
      content = SettingsPage();
    } else {
      content = Container();
    }

    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: NewsletterListPage(
            onNewsletterTap: (NewsletterViewModel newsletter) {
              setState(() {
                selectedElement = newsletter;
              });
            },
            onNewsletterEdit: (NewsletterViewModel newsletter) async {
              await editNewsletter(context, newsletter);
            },
            selectedItem: selectedElement is NewsletterViewModel ? selectedElement as NewsletterViewModel : null,
            showAsCards: false, onSettingsClicked: () {
              setState(() {
                selectedElement = SettingElement();
              });
          },
          ),
        ),
        VerticalDivider(
          width: 1,
          color: Theme.of(context).dividerColor,
        ),
        Flexible(
          flex: 2,
          child: content,
        )
      ],
    );
  }

  bool isTablet() {
    var size = MediaQuery.of(context).size;
    return size.height < size.width;
  }



  Future editNewsletter(BuildContext context, NewsletterViewModel newsletter) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new NewsletterEditPage(
            newsletter.newsletter,
          );
        },
      ),
    );
  }

  Future navigateToNewsletter(BuildContext context, NewsletterViewModel newsletter) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new NewsletterArticlesPage(
            newsletter: newsletter,
          );
        },
      ),
    );
  }

  Future navigateToSettings(BuildContext context) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new SettingsPage();
        },
      ),
    );
  }
}


class SettingElement {}