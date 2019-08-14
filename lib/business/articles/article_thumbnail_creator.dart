import 'package:newsletter_reader/business/newsletters/newsletter_storage_path.dart';
import 'package:newsletter_reader/business/pdf/pdf_to_image_renderer.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class ArticleThumbnailCreator {
  final PdfToImageRenderer _pdfToImageRenderer;
  final ArticleRepository _articleRepository;
  final Article _article;
  final Newsletter _newsletter;

  ArticleThumbnailCreator(this._pdfToImageRenderer, this._articleRepository, this._article, this._newsletter);

  Future createThumbnail() async {
    var thumbnailFile = await new NewsletterStoragePath().getThumbnailFile(_newsletter);

    await _pdfToImageRenderer.renderPdfToImage(_article.storagePath, thumbnailFile.path, 0);

    _article.thumbnailPath = thumbnailFile.path;

    await _articleRepository.saveArticle(_article);
  }
}

class ArticleThumbnailCreatorFactory {
  final PdfToImageRenderer _pdfToImageRenderer;
  final ArticleRepository _articleRepository;

  ArticleThumbnailCreatorFactory(this._pdfToImageRenderer, this._articleRepository);

  ArticleThumbnailCreator getNewArticleThumbnailCreatorInstance(Newsletter newsletter, Article article) {
    return new ArticleThumbnailCreator(_pdfToImageRenderer, _articleRepository, article, newsletter);
  }
}
