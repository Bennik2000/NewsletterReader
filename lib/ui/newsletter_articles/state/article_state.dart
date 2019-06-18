import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/data/model/model.dart';

class ArticleState with ChangeNotifier {
  Article _article;

  Article get article => _article;

  set article(Article article) {
    _article = article;
    notifyListeners();
  }

  ArticleState(this._article);
}
