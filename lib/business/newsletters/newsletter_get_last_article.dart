import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterGetLastArticle {
  final ArticleRepository _articleRepository;
  final Newsletter _newsletter;

  NewsletterGetLastArticle(this._newsletter, this._articleRepository);

  Future<Article> getLastArticleOrNull() async {
    return _articleRepository.queryLastArticleOfNewsletter(_newsletter.id);
  }
}
