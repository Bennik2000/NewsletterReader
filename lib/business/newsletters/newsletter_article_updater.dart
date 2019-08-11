import 'package:newsletter_reader/data/network/article_searcher.dart';
import 'package:newsletter_reader/data/network/pattern_url_article_searcher.dart';
import 'package:newsletter_reader/data/network/same_url_article_searcher.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterArticleUpdater {
  final Newsletter _newsletter;
  final ArticleRepository _articleRepository;
  final NewsletterRepository _newsletterRepository;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  NewsletterArticleUpdater(this._newsletter, this._articleRepository, this._newsletterRepository);

  Future<List<Article>> updateArticles() async {
    _isUpdating = true;

    var articleSearcher = _getArticleSearcher();

    List<Article> newArticles = await articleSearcher.fetchNewArticles();

    for (Article article in newArticles) {
      await _articleRepository.saveArticleForNewsletter(_newsletter.id, article);
    }

    _newsletter.lastUpdated = DateTime.now();
    await _newsletterRepository.saveNewsletter(_newsletter);

    _isUpdating = false;

    return newArticles;
  }

  ArticleSearcher _getArticleSearcher() {
    switch (_newsletter.updateStrategy) {
      case UpdateStrategy.SameUrl:
        return new SameUrlArticleSearcher(_newsletter, _articleRepository);
        break;
      case UpdateStrategy.PatternUrl:
        return new PatternUrlArticleSearcher(_newsletter, _articleRepository);
        break;
    }

    return null;
  }
}

class NewsletterArticleUpdaterFactory {
  final ArticleRepository _articleRepository;
  final NewsletterRepository _newsletterRepository;

  NewsletterArticleUpdaterFactory(this._articleRepository, this._newsletterRepository);

  NewsletterArticleUpdater getNewArticleUpdaterInstance(Newsletter newsletter) {
    return new NewsletterArticleUpdater(newsletter, _articleRepository, _newsletterRepository);
  }
}
