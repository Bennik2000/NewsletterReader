import 'package:newsletter_reader/business/articles/article_download_delete.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterDelete {
  final NewsletterRepository _newsletterRepository;
  final ArticleRepository _articleRepository;
  final Newsletter _newsletter;

  NewsletterDelete(this._newsletter, this._newsletterRepository, this._articleRepository);

  Future deleteNewsletter() async {
    var articles = await _articleRepository.queryArticlesOfNewsletter(_newsletter.id);

    articles.forEach((a) async {
      await new ArticleDownloadDelete(a, _articleRepository).deleteDownloadedArticle();
      await _articleRepository.deleteArticle(a);
    });

    await _newsletterRepository.deleteNewsletter(_newsletter);
  }
}
