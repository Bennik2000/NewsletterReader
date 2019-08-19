import 'dart:io';

import 'package:newsletter_reader/business/newsletters/newsletter_storage_path.dart';
import 'package:newsletter_reader/business/pdf/pdf_to_image_renderer.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

import 'article_thumbnail_creator.dart';

class ArticleImport {
  final PdfToImageRenderer _pdfToImageRenderer;
  final ArticleRepository _articleRepository;
  final Newsletter _newsletter;

  ArticleImport(this._articleRepository, this._pdfToImageRenderer, this._newsletter);

  Future importArticle(String path) async {
    var article = new Article();

    await _articleRepository.saveArticleForNewsletter(_newsletter.id, article);

    var targetPath = await NewsletterStoragePath().getArticleStorageFile(_newsletter, article);

    await File.fromUri(Uri.file(path)).copy(targetPath.path);

    article.isDownloaded = true;
    article.storagePath = targetPath.path;
    article.downloadDate = DateTime.now();
    article.releaseDate = DateTime.now();

    await new ArticleThumbnailCreator(_pdfToImageRenderer, _articleRepository, article, _newsletter).createThumbnail();
  }
}
