import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/business/articles/article_delete.dart';
import 'package:newsletter_reader/business/articles/article_download_delete.dart';
import 'package:newsletter_reader/business/articles/article_downloader.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

import 'article_view_model.dart';

class NewsletterViewModel with ChangeNotifier {
  final ArticleRepository _articleRepository;
  final NewsletterArticleUpdater _newsletterArticleUpdater;
  final ArticleDeleteFactory _articleDeleteFactory;
  final ArticleDownloaderFactory _articleDownloaderFactory;
  final ArticleDownloadDeleteFactory _articleDownloadDeleteFactory;

  final Newsletter newsletter;

  List<ArticleViewModel> _articles;
  List<ArticleViewModel> get articles => _articles;

  bool get isUpdating => _newsletterArticleUpdater.isUpdating;
  bool isLoading = false;
  String error;

  NewsletterViewModel(
    this.newsletter,
    this._articleRepository,
    this._newsletterArticleUpdater,
    this._articleDeleteFactory,
    this._articleDownloaderFactory,
    this._articleDownloadDeleteFactory,
  );

  Future loadArticles() async {
    if (isLoading || isUpdating) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      var loadedArticles = await _articleRepository.queryArticlesOfNewsletter(newsletter.id);
      loadedArticles.sort((a, b) => -a.releaseDate?.compareTo(b.releaseDate) ?? 0);

      var viewModels = <ArticleViewModel>[];

      for (var article in loadedArticles) {
        viewModels.add(ArticleViewModel(article, _articleDownloaderFactory.getNewArticleDownloaderInstance(newsletter, article),
            _articleDownloadDeleteFactory.getNewArticleDownloadDeleteInstance(article)));
      }

      _disposeArticleViewModels();

      _articles = viewModels;
    } catch (e) {
      print(e);

      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future updateArticles() async {
    if (isLoading || isUpdating) return;

    error = null;

    try {
      var newArticlesFuture = _newsletterArticleUpdater.updateArticles();

      notifyListeners();

      var newArticles = await newArticlesFuture;

      for (var article in newArticles) {
        articles.add(ArticleViewModel(article, _articleDownloaderFactory.getNewArticleDownloaderInstance(newsletter, article),
            _articleDownloadDeleteFactory.getNewArticleDownloadDeleteInstance(article)));
      }

      articles.sort((a, b) => -a.article.releaseDate?.compareTo(b.article.releaseDate) ?? 0);
    } catch (e) {
      print(e);
      error = e.toString();
    }

    notifyListeners();
  }

  Future deleteArticle(ArticleViewModel article) async {
    articles.remove(article);

    await _articleDeleteFactory.getNewArticleDeleteInstance(article.article).deleteArticle();

    notifyListeners();
  }

  void notifyNewsletterChanged() {
    notifyListeners();
  }

  void _disposeArticleViewModels() {
    if (_articles == null) return;

    var articles = _articles;

    _articles = null;

    notifyListeners();

    for (var viewModel in articles) {
      viewModel.dispose();
    }

    articles = null;
  }

  @override
  void dispose() {
    _disposeArticleViewModels();

    super.dispose();
  }
}
