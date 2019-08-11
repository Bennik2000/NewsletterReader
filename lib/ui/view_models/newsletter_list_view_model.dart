import 'package:newsletter_reader/business/articles/article_delete.dart';
import 'package:newsletter_reader/business/articles/article_download_delete.dart';
import 'package:newsletter_reader/business/articles/article_downloader.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';

import 'newsletter_view_model.dart';

class NewsletterListViewModel {
  final NewsletterRepository _newsletterRepository;
  final ArticleRepository _articleRepository;
  final NewsletterArticleUpdaterFactory _articleUpdaterFactory;
  final ArticleDeleteFactory _articleDeleteFactory;
  final ArticleDownloaderFactory _articleDownloaderFactory;
  final ArticleDownloadDeleteFactory _articleDownloadDeleteFactory;

  List<NewsletterViewModel> _newsletters;

  NewsletterListViewModel(
    this._newsletterRepository,
    this._articleRepository,
    this._articleUpdaterFactory,
    this._articleDeleteFactory,
    this._articleDownloaderFactory,
    this._articleDownloadDeleteFactory,
  );

  Future<List<NewsletterViewModel>> getNewsletters() async {
    if (_newsletters == null) {
      await loadNewsletters();
    }

    return _newsletters;
  }

  Future loadNewsletters() async {
    _disposeNewsletterViewModels();

    var loadedNewsletters = await _newsletterRepository.queryNewsletters();

    var viewModels = <NewsletterViewModel>[];

    for (var newsletter in loadedNewsletters) {
      var viewModel = NewsletterViewModel(
          newsletter,
          _articleRepository,
          _articleUpdaterFactory.getNewArticleUpdaterInstance(newsletter),
          _articleDeleteFactory,
          _articleDownloaderFactory,
          _articleDownloadDeleteFactory);

      viewModel.loadArticles();

      viewModels.add(viewModel);
    }


    _newsletters = viewModels;
  }

  void _disposeNewsletterViewModels() {
    if (_newsletters == null) return;

    for (var newsletter in _newsletters) {
      newsletter.dispose();
    }

    _newsletters = null;
  }
}
