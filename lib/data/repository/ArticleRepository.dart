import 'package:newsletter_reader/data/database/DatabaseAccess.dart';
import 'package:newsletter_reader/data/database/entity/article_entity.dart';
import 'package:newsletter_reader/data/model/model.dart';

class ArticleRepository {
  final DatabaseAccess _database;

  ArticleRepository(this._database);

  Future<List<Article>> queryArticlesOfNewsletter(int newsletterId) async {
    var rows = await _database.queryAllRows(ArticleEntity.tableName());
    var articles = new List<Article>();

    for (var row in rows) {
      articles.add(new ArticleEntity.fromMap(row).asArticle());
    }

    return articles;
  }

  Future saveArticleForNewsletter(int newsletterId, Article article) async {
    var row = new ArticleEntity.fromModel(article).toMap();

    article.newsletterId = newsletterId;

    if (article.id == null) {
      var id = await _database.insert(ArticleEntity.tableName(), row);
      article.id = id;
    } else {
      await _database.update(ArticleEntity.tableName(), row);
    }
  }
}
