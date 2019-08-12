import 'package:flutter/material.dart';
import 'package:newsletter_reader/business/articles/article_delete.dart';
import 'package:newsletter_reader/business/articles/article_download_delete.dart';
import 'package:newsletter_reader/business/articles/article_downloader.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_delete.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';

import 'newsletter_view_model.dart';

class NewsletterListViewModel with ChangeNotifier{
  final NewsletterRepository _newsletterRepository;
  final ArticleRepository _articleRepository;
  final NewsletterArticleUpdaterFactory _articleUpdaterFactory;
  final ArticleDeleteFactory _articleDeleteFactory;
  final ArticleDownloaderFactory _articleDownloaderFactory;
  final ArticleDownloadDeleteFactory _articleDownloadDeleteFactory;

  List<NewsletterViewModel> _newsletters;
  List<NewsletterViewModel> get newsletters => _newsletters;

  bool isLoading = false;

  NewsletterListViewModel(
    this._newsletterRepository,
    this._articleRepository,
    this._articleUpdaterFactory,
    this._articleDeleteFactory,
    this._articleDownloaderFactory,
    this._articleDownloadDeleteFactory,
  );

  Future loadNewsletters() async {
    if(isLoading) return;

    isLoading = true;

    notifyListeners();

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
    isLoading = false;

    notifyListeners();
  }

  void _disposeNewsletterViewModels() {
    if (newsletters == null) return;

    for (var newsletter in newsletters) {
      newsletter.dispose();
    }

    _newsletters = null;
  }

  Future deleteNewsletter(NewsletterViewModel newsletter) async {
    await new NewsletterDelete(newsletter.newsletter, _newsletterRepository, _articleRepository).deleteNewsletter();

    newsletters.remove(newsletter);

    notifyListeners();
  }

  @override
  void dispose() {
    _disposeNewsletterViewModels();

    super.dispose();
  }
}
