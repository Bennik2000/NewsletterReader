import 'dart:io';

import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class ArticleDownloadDelete {
  final ArticleRepository _articleRepository;
  final Article _article;

  ArticleDownloadDelete(this._article, this._articleRepository);

  Future deleteDownloadedArticle() async {
    if (_article.storagePath != null) {
      File file = File.fromUri(Uri.file(_article.storagePath));

      if (await file.exists()) {
        await file.delete();
      }
    }

    _article.isDownloaded = false;
    _article.storagePath = null;
    _article.downloadDate = null;
    _articleRepository.saveArticle(_article);
  }
}

class ArticleDownloadDeleteFactory {
  final ArticleRepository _articleRepository;

  ArticleDownloadDeleteFactory(this._articleRepository);

  ArticleDownloadDelete getNewArticleDownloadDeleteInstance(Article article) {
    return new ArticleDownloadDelete(article, _articleRepository);
  }
}
