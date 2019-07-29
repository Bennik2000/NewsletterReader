import 'dart:io';

import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class ArticleDownloadDelete {
  final ArticleRepository _articleRepository;
  final Article _article;

  ArticleDownloadDelete(this._article, this._articleRepository);

  Future deleteDownloadedArticle() async {
    await deleteFile(_article.storagePath);
    await deleteFile(_article.thumbnailPath);

    _article.isDownloaded = false;
    _article.storagePath = null;
    _article.thumbnailPath = null;
    _article.downloadDate = null;
    _articleRepository.saveArticle(_article);
  }

  Future deleteFile(String path) async {
    if (path == null) return;

    File file = File.fromUri(Uri.file(path));

    if (await file.exists()) {
      await file.delete();
    }
  }
}

class ArticleDownloadDeleteFactory {
  final ArticleRepository _articleRepository;

  ArticleDownloadDeleteFactory(this._articleRepository);

  ArticleDownloadDelete getNewArticleDownloadDeleteInstance(Article article) {
    return new ArticleDownloadDelete(article, _articleRepository);
  }
}
