import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'state/settings_state.dart';
import 'widget/import_newsletter_button.dart';

class SettingsPage extends StatelessWidget {
  final NewsletterListViewModel newsletterListViewModel;

  const SettingsPage({Key key, this.newsletterListViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text(L.of(context).settingsPageTitle),
          actions: <Widget>[
            ImportNewsletterButton(
              newsletterListViewModel: newsletterListViewModel,
            ),
          ],
        ),
        body: buildBody(),
      ),
      builder: (BuildContext context) => SettingsState(kiwi.Container().resolve()),
    );
  }

  Widget buildBody() {
    return ListView(
      children: <Widget>[
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnNewArticles,
            onChanged: (bool value) => state.notifyOnNewArticles = value,
            title: Text(L.of(context).settingsNotificationOnNewArticles),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnNewArticlesDownloaded,
            onChanged: (bool value) => state.notifyOnNewArticlesDownloaded = value,
            title: Text(L.of(context).settingsNotificationOnNewArticlesDownloaded),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnNoWifi,
            onChanged: (bool value) => state.notifyOnNoWifi = value,
            title: Text(L.of(context).settingsNotificationOnNoWifi),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnNoNewArticles,
            onChanged: (bool value) => state.notifyOnNoNewArticles = value,
            title: Text(L.of(context).settingsNotificationOnNoNewArticles),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnUpdateError,
            onChanged: (bool value) => state.notifyOnUpdateError = value,
            title: Text(L.of(context).settingsNotificationOnUpdateError),
          );
        }),
      ],
    );
  }
}
