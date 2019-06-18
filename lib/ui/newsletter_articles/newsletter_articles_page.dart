import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_articles/load_articles_bloc.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/article_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:newsletter_reader/ui/newsletter_articles/widget/article_card.dart';
import 'package:provider/provider.dart';

class NewsletterArticlesPage extends StatefulWidget {
  final Newsletter newsletter;

  const NewsletterArticlesPage({Key key, this.newsletter}) : super(key: key);

  @override
  _NewsletterArticlesPageState createState() => _NewsletterArticlesPageState(newsletter);
}

class _NewsletterArticlesPageState extends State<NewsletterArticlesPage> {
  final LoadArticlesBloc _loadArticlesBloc;
  final Newsletter _newsletter;

  _NewsletterArticlesPageState(Newsletter newsletter)
      : _newsletter = newsletter,
        _loadArticlesBloc = new LoadArticlesBloc(
          newsletter,
          kiwi.Container().resolve(),
        ) {
    _loadArticlesBloc.dispatch(new DoLoadArticlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        builder: (c) => new NewsletterState(_newsletter),
        child: Stack(
          children: <Widget>[buildBackground(), buildBody()],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Flex(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: buildTitle(),
        ),
        Flexible(
          flex: 7,
          child: buildContent(),
        )
      ],
      direction: Axis.vertical,
    );
  }

  Widget buildBackground() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.green,
          ),
          flex: 1,
        ),
        Flexible(
          child: Container(),
          flex: 4,
        )
      ],
    );
  }

  Widget buildTitle() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Icon(
                  Icons.import_contacts,
                  color: Colors.white,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Consumer<NewsletterState>(
                  builder: (BuildContext context, NewsletterState state, _) => Text(
                        state.newsletter.name,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: BlocBuilder(
        bloc: _loadArticlesBloc,
        builder: (BuildContext context, LoadArticlesState state) {
          Widget body = Text("");

          if (state.isLoading || state.isUpdating) {
            body = Padding(
              padding: const EdgeInsets.fromLTRB(0, 54, 0, 0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state.isLoaded && state.loadedArticles.isEmpty) {
            body = Padding(
              padding: const EdgeInsets.fromLTRB(0, 54, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.announcement),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Center(
                      child: Text("Es sind noch keine Ausgaben verfügbar"),
                    ),
                  ),
                ],
              ),
            );
          } else if (state.isLoaded && state.loadedArticles.isNotEmpty) {
            body = Flexible(
              child: GridView.count(
                childAspectRatio: 1 / sqrt(2),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                children: List.generate(state.loadedArticles.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new ChangeNotifierProvider(
                      builder: (c) => new ArticleState(state.loadedArticles[i]),
                      child: new ArticleCard(
                        onTap: () {},
                      ),
                    ),
                  );
                }),
              ),
            );
          }

          return Card(
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Verfügbare Ausgaben",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Aktualisiert am 17.06.2019 um 14:12 Uhr",
                        style: TextStyle(color: Colors.black54),
                      ),
                      FlatButton(
                        onPressed: state.isUpdating
                            ? null
                            : () {
                                _loadArticlesBloc.dispatch(new UpdateArticlesEvent());
                              },
                        child: Text("Aktualisieren".toUpperCase()),
                        textColor: Colors.amber,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Opacity(
                    opacity: state.hasError ? 1 : 0,
                    child: Text(
                      state.error ?? "",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Divider(
                    height: 1,
                    color: Colors.black12,
                  ),
                ),
                body,
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loadArticlesBloc.dispose();
  }
}
