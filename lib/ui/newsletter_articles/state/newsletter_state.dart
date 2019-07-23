import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterState with ChangeNotifier {
  final ArticleRepository _articlesRepository;
  final NewsletterArticleUpdaterFactory _articleUpdaterFactory;

  Newsletter _newsletter;
  Newsletter get newsletter => _newsletter;
  set newsletter(Newsletter newsletter) {
    _newsletter = newsletter;
    notifyListeners();
  }

  bool isLoading = false;
  bool isUpdating = false;
  bool isLoaded = false;
  String error;
  List<Article> loadedArticles;

  NewsletterState(this._newsletter, this._articlesRepository, this._articleUpdaterFactory) {
    loadArticles();
  }

  void loadArticles() async {
    isLoaded = false;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      var articles = await _articlesRepository.queryArticlesOfNewsletter(_newsletter.id);
      loadedArticles = articles;
      loadedArticles.sort((a, b) => -a.releaseDate?.compareTo(b.releaseDate) ?? 0);
    } catch (e) {
      print(e);
      error = e.toString();
    }

    isLoading = false;
    isLoaded = true;
    notifyListeners();
  }

  void updateArticles() async {
    error = null;
    isUpdating = true;
    notifyListeners();

    try {
      var newArticles = await _articleUpdaterFactory.getNewArticleUpdaterInstance(_newsletter).updateArticles();

      loadedArticles.addAll(newArticles);
      loadedArticles.sort((a, b) => a.releaseDate?.compareTo(b.releaseDate) ?? 0);
    } catch (e) {
      print(e);
      error = e.toString();
    }

    isUpdating = false;
    notifyListeners();
  }
}
