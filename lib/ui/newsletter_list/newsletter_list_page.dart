import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_import.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_page.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list.dart';
import 'package:newsletter_reader/ui/newsletter_list/state/newsletter_list_state.dart';
import 'package:newsletter_reader/ui/settings/settings_page.dart';
import 'package:provider/provider.dart';

class NewsletterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (BuildContext context) {
        var state = new NewsletterListState(kiwi.Container().resolve());

        state.loadNewsletters();

        return state;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Newsletters"),
          actions: <Widget>[
            new Consumer(
              builder: (BuildContext context, NewsletterListState state, Widget child) => IconButton(
                icon: Icon(Icons.import_export),
                onPressed: () async {
                  var path = await FilePicker.getFilePath();
                  await new NewsletterImport(kiwi.Container().resolve()).importNewsletter(path);

                  state.loadNewsletters();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                await Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return new SettingsPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: NewsletterList(),
        floatingActionButton: Consumer(
          builder: (BuildContext context, NewsletterListState state, _) => FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new NewsletterEditPage(new Newsletter());
                  },
                ),
              );

              state.loadNewsletters();
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
