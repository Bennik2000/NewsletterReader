import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/ui/newsletter_articles/newsletter_articles.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_detail_page.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_page.dart';
import 'package:newsletter_reader/ui/settings/settings_page.dart';
import 'package:newsletter_reader/ui/utils/device_utils.dart' as device_utils;
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'view_model/master_detail_view_model.dart';
import 'widget/master_detail_nothing_selected.dart';

class NewslettersMasterDetailContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListenableProvider(
        builder: (BuildContext context) => MasterDetailViewModel(),
        child: ListenableProvider(
          builder: (BuildContext context) {
            var newsletterListViewModel = NewsletterListViewModel(
              kiwi.Container().resolve(),
              kiwi.Container().resolve(),
              kiwi.Container().resolve(),
              kiwi.Container().resolve(),
              kiwi.Container().resolve(),
              kiwi.Container().resolve(),
            );

            newsletterListViewModel.loadNewsletters();

            return newsletterListViewModel;
          },
          child: Consumer(
            builder: (BuildContext context, MasterDetailViewModel value, Widget child) =>
                device_utils.isTablet(context) ? buildTabletLayout(context, value) : buildPhoneLayout(context),
          ),
        ),
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

  Widget buildTabletLayout(BuildContext context, MasterDetailViewModel masterDetailViewModel) {
    Widget content;

    if (masterDetailViewModel.selectedElement is NewsletterViewModel) {
      var newsletter = masterDetailViewModel.selectedElement as NewsletterViewModel;
      content = NewsletterDetailPage(
        newsletter: newsletter,
        key: ObjectKey(masterDetailViewModel.selectedElement),
      );
    } else if (masterDetailViewModel.selectedElement is SettingElement) {
      content = SettingsPage();
    } else {
      content = MasterDetailNothingSelected();
    }

    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: NewsletterListPage(
            onNewsletterTap: (NewsletterViewModel newsletter) {
              masterDetailViewModel.selectedElement = newsletter;
            },
            onNewsletterEdit: (NewsletterViewModel newsletter) async {
              await editNewsletter(context, newsletter);
            },
            selectedItem: masterDetailViewModel.selectedElement is NewsletterViewModel
                ? masterDetailViewModel.selectedElement as NewsletterViewModel
                : null,
            showAsCards: false,
            onSettingsClicked: () {
              masterDetailViewModel.selectedElement = SettingElement();
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

  Future editNewsletter(BuildContext context, NewsletterViewModel newsletter) async {
    await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new NewsletterEditPage(
            newsletter,
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
