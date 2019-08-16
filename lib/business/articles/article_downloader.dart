import 'dart:io';

import 'package:newsletter_reader/business/newsletters/newsletter_storage_path.dart';
import 'package:newsletter_reader/data/network/file_downloader.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

import 'article_thumbnail_creator.dart';

class ArticleDownloader {
  final FileDownloader _fileDownloader;
  final ArticleRepository _articleRepository;
  final ArticleThumbnailCreatorFactory _articleThumbnailCreatorFactory;
  final Article _article;
  final Newsletter _newsletter;

  bool _isDownloading;
  bool get isDownloading => _isDownloading;

  ArticleDownloader(
      this._article, this._newsletter, this._fileDownloader, this._articleRepository, this._articleThumbnailCreatorFactory);

  Future downloadArticle() async {
    _isDownloading = true;

    var file = await new NewsletterStoragePath().getArticleStorageFile(_newsletter, _article);

    try {
      await _fileDownloader.downloadFile(_article.sourceUrl, file);

      setArticleDownloaded(file);

      await _articleRepository.saveArticle(_article);

      await createThumbnail();
    } catch (e) {
      print(e);

      if (await file.exists()) {
        await file.delete();
      }

      _article.isDownloaded = false;
    }

    _isDownloading = false;
  }

  String getFilename() {
    var fileName = _article.originalFilename ?? _newsletter.name ?? _article.id.toString();

    if (!fileName.endsWith(".pdf")) {
      fileName += ".pdf";
    }

    return fileName;
  }

  void setArticleDownloaded(File file) {
    _article.storagePath = file.path;
    _article.downloadDate = DateTime.now();
    _article.isDownloaded = true;
  }

  Future createThumbnail() async {
    var thumbnailCreator = _articleThumbnailCreatorFactory.getNewArticleThumbnailCreatorInstance(_newsletter, _article);
    await thumbnailCreator.createThumbnail();
  }
}

class ArticleDownloaderFactory {
  final ArticleRepository _articleRepository;
  final FileDownloader _fileDownloader;
  final ArticleThumbnailCreatorFactory _articleThumbnailCreatorFactory;

  ArticleDownloaderFactory(
    this._fileDownloader,
    this._articleRepository,
    this._articleThumbnailCreatorFactory,
  );

  ArticleDownloader getNewArticleDownloaderInstance(Newsletter newsletter, Article article) {
    return new ArticleDownloader(
      article,
      newsletter,
      _fileDownloader,
      _articleRepository,
      _articleThumbnailCreatorFactory,
    );
  }
}
