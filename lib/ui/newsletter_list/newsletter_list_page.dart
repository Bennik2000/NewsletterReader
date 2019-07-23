import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_import.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/newsletter_articles_page.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_page.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_bloc.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_event.dart';

class NewsletterListPage extends StatefulWidget {
  @override
  _NewsletterListPageState createState() => _NewsletterListPageState();
}

class _NewsletterListPageState extends State<NewsletterListPage> {
  final NewsletterListBloc _newsletterListBloc = new NewsletterListBloc(kiwi.Container().resolve());

  _NewsletterListPageState() {
    _newsletterListBloc.dispatch(new LoadNewsletterListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsletters"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.import_export),
            onPressed: () async {
              var path = await FilePicker.getFilePath();

              new NewsletterImport(kiwi.Container().resolve()).importNewsletter(path);
            },
          )
        ],
      ),
      body: BlocProvider(
        bloc: _newsletterListBloc,
        child: Center(
          child: NewsletterList(
            onNewsletterTap: (Newsletter newsletter) {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
                return new NewsletterArticlesPage(
                  newsletter: newsletter,
                );
              })).then((value) {
                _newsletterListBloc.dispatch(new LoadNewsletterListEvent());
              });
            },
            onLongPress: (Newsletter newsletter) {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
                return new NewsletterEditPage(newsletter);
              })).then((value) {
                _newsletterListBloc.dispatch(new LoadNewsletterListEvent());
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
            return new NewsletterEditPage(new Newsletter());
          })).then((value) {
            _newsletterListBloc.dispatch(new LoadNewsletterListEvent());
          });
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          title: Text("Newsletters"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_download),
          title: Text("Heruntergeladen"),
        )
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _newsletterListBloc.dispose();
  }
}
