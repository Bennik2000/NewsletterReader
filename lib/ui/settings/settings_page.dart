import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_import.dart';
import 'package:provider/provider.dart';

import 'state/settings_state.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.import_export),
              onPressed: () async {
                var path = await FilePicker.getFilePath();
                await new NewsletterImport(kiwi.Container().resolve()).importNewsletter(path);
              },
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
            title: Text("Benachrichtigung bei neuen Ausgaben"),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnNewArticlesDownloaded,
            onChanged: (bool value) => state.notifyOnNewArticlesDownloaded = value,
            title: Text("Benachrichtigung, wenn neue Ausgaben heruntergeladen wurden"),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnNoWifi,
            onChanged: (bool value) => state.notifyOnNoWifi = value,
            title: Text("Benachrichtigung, wenn kein WLAN zum herungerladen verfügbar war"),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnNoNewArticles,
            onChanged: (bool value) => state.notifyOnNoNewArticles = value,
            title: Text("Benachrichtigung, auch wenn keine neuen Ausgaben gefunden wurden"),
          );
        }),
        Consumer(builder: (context, SettingsState state, _) {
          return CheckboxListTile(
            value: state.notifyOnUpdateError,
            onChanged: (bool value) => state.notifyOnUpdateError = value,
            title: Text("Benachrichtigung, wenn die Aktualisierung fehlschlug"),
          );
        }),
      ],
    );
  }
}
