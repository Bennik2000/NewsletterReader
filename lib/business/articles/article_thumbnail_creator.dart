import 'package:newsletter_reader/business/pdf/pdf_to_image_renderer.dart';
import 'package:newsletter_reader/data/filestorage/file_download_repository.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:path/path.dart' as path;

class ArticleThumbnailCreator {
  final FileDownloadRepository _fileDownloadRepository;
  final PdfToImageRenderer _pdfToImageRenderer;
  final ArticleRepository _articleRepository;
  final Article _article;
  final Newsletter _newsletter;

  ArticleThumbnailCreator(
      this._pdfToImageRenderer, this._fileDownloadRepository, this._articleRepository, this._article, this._newsletter);

  Future createThumbnail() async {
    var directory = path.join(
      "newsletter_${_newsletter.id.toString()}",
      _article.id.toString(),
    );

    var thumbnailFile = await _fileDownloadRepository.getFile(
      directory,
      "thumbnail_${_article.id.toString()}.png",
    );

    await _pdfToImageRenderer.renderPdfToImage(_article.storagePath, thumbnailFile.path, 0);

    _article.thumbnailPath = thumbnailFile.path;

    await _articleRepository.saveArticle(_article);
  }
}

class ArticleThumbnailCreatorFactory {
  final PdfToImageRenderer _pdfToImageRenderer;
  final FileDownloadRepository _fileDownloadRepository;
  final ArticleRepository _articleRepository;

  ArticleThumbnailCreatorFactory(this._pdfToImageRenderer, this._fileDownloadRepository, this._articleRepository);

  ArticleThumbnailCreator getNewArticleThumbnailCreatorInstance(Newsletter newsletter, Article article) {
    return new ArticleThumbnailCreator(_pdfToImageRenderer, _fileDownloadRepository, _articleRepository, article, newsletter);
  }
}
