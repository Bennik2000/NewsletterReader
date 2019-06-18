import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/article_state.dart';
import 'package:provider/provider.dart';

class ArticleCard extends StatelessWidget {
  final GestureTapCallback onTap;

  const ArticleCard({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Consumer(
      builder: (BuildContext context, ArticleState state, _) => buildCard(state),
    );
  }

  Widget buildCard(ArticleState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(8)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 8,
              left: 0,
              right: 0,
              child: Container(
                child: Ink.image(
                  image: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/7/75/NYTimes-Page1-11-11-1918.jpg",
                  ),
                  child: Container(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 8,
              left: 0,
              right: 0,
              child: Ink(
                child: Container(),
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white,
                    ],
                    stops: [0.0, 0.75],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        DateFormat.yMMMd().format(state.article.releaseDate),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Visibility(
                          visible: true,
                          child: IconButton(
                            icon: Icon(Icons.file_download),
                            color: Colors.amber.shade500,
                            onPressed: () {},
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: IconButton(
                            icon: Icon(Icons.delete_outline),
                            color: Colors.amber.shade500,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
