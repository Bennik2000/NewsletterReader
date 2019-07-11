import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/data/network/article_searcher.dart';
import 'package:newsletter_reader/data/network/pattern_url_article_searcher.dart';
import 'package:newsletter_reader/data/network/same_url_article_searcher.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';

class ArticleUpdater {
  final Newsletter _newsletter;
  final ArticleRepository _articleRepository;
  final NewsletterRepository _newsletterRepository;

  ArticleUpdater(this._newsletter, this._articleRepository, this._newsletterRepository);

  Future<List<Article>> updateArticles() async {
    var articleSearcher = getArticleSearcher();

    List<Article> newArticles = await articleSearcher.fetchNewArticles();

    newArticles.forEach((a) async => await _articleRepository.saveArticleForNewsletter(_newsletter.id, a));

    _newsletter.lastUpdated = DateTime.now();
    await _newsletterRepository.saveNewsletter(_newsletter);

    return newArticles;
  }

  ArticleSearcher getArticleSearcher() {
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

class ArticleUpdaterFactory {
  final ArticleRepository _articleRepository;
  final NewsletterRepository _newsletterRepository;

  ArticleUpdaterFactory(this._articleRepository, this._newsletterRepository);

  ArticleUpdater getNewArticleUpdaterInstance(Newsletter newsletter) {
    return new ArticleUpdater(newsletter, _articleRepository, _newsletterRepository);
  }
}
