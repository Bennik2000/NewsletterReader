import 'package:newsletter_reader/data/database/DatabaseAccess.dart';
import 'package:newsletter_reader/data/database/entity/article_entity.dart';
import 'package:newsletter_reader/data/model/model.dart';

class ArticleRepository {
  final DatabaseAccess _database;

  ArticleRepository(this._database);

  Future<List<Article>> queryArticlesOfNewsletter(int newsletterId) async {
    var rows = await _database.queryRows(
      ArticleEntity.tableName(),
      where: "newsletterId=?",
      whereArgs: [newsletterId],
    );
    var articles = new List<Article>();

    for (var row in rows) {
      articles.add(new ArticleEntity.fromMap(row).asArticle());
    }

    return articles;
  }

  Future<Article> queryLastArticleOfNewsletter(int newsletterId) async {
    var rows = await _database.queryRows(ArticleEntity.tableName(),
        where: "newsletterId=?", whereArgs: [newsletterId], orderBy: "releaseDate DESC", limit: 1);

    for (var row in rows) {
      return new ArticleEntity.fromMap(row).asArticle();
    }

    return null;
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

  Future saveArticle(Article article) async {
    await saveArticleForNewsletter(article.newsletterId, article);
  }

  Future deleteArticle(Article article) async {
    await _database.delete(ArticleEntity.tableName(), article.id);
  }
}
