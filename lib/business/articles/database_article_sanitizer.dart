import 'dart:io';

import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class DatabaseArticleSanitizer {
  final NewsletterRepository _newsletterRepository;
  final ArticleRepository _articleRepository;

  DatabaseArticleSanitizer(this._articleRepository, this._newsletterRepository);

  Future sanitize() async {
    var newsletters = await _newsletterRepository.queryNewsletters();

    for (var newsletter in newsletters) {
      await _sanitizeNewsletter(newsletter);
    }
  }

  Future _sanitizeNewsletter(Newsletter newsletter) async {
    var articles = await _articleRepository.queryArticlesOfNewsletter(newsletter.id);

    for (var article in articles) {
      await _sanitizeArticle(article, newsletter);
    }
  }

  Future _sanitizeArticle(Article article, Newsletter newsletter) async {
    bool modified = false;

    modified |= await _sanitizeIsDownloadedAndStoragePath(article);
    modified |= await _sanitizeThumbnailPath(article);

    if (modified) {
      await _articleRepository.saveArticle(article);
    }
  }

  Future<bool> _sanitizeIsDownloadedAndStoragePath(Article article) async {
    bool modified = false;

    if (article.isDownloaded ?? false) {
      if (article.storagePath == null) {
        article.isDownloaded = false;

        modified = true;
      } else if (await _fileMissing(article.storagePath)) {
        article.isDownloaded = false;
        article.storagePath = null;

        modified = true;
      }
    } else {
      if (article.storagePath != null) {
        article.storagePath = null;

        modified = true;
      }
    }

    return modified;
  }

  Future<bool> _sanitizeThumbnailPath(Article article) async {
    var modified = false;

    if (article.thumbnailPath != null) {
      if (await _fileMissing(article.thumbnailPath)) {
        article.thumbnailPath = null;

        modified = true;
      }
    }

    return modified;
  }

  Future<bool> _fileMissing(String path) async {
    return !(await File.fromUri(Uri.file(path)).exists());
  }
}
