import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/data/model/model.dart';
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
