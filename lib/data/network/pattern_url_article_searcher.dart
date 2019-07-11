import 'package:newsletter_reader/data/model/model.dart';

import 'article_searcher.dart';

class PatternUrlArticleSearcher extends ArticleSearcher {
  final Newsletter _newsletter;

  PatternUrlArticleSearcher(this._newsletter);

  @override
  Future fetchNewArticles() {
    return null;
  }
}
