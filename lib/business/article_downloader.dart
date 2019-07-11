import 'package:newsletter_reader/data/filestorage/file_download_repository.dart';
import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/data/network/file_downloader.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:path/path.dart' as path;

class ArticleDownloader {
  final FileDownloadRepository _fileDownloadRepository;
  final FileDownloader _fileDownloader;
  final ArticleRepository _articleRepository;
  final Article _article;
  final Newsletter _newsletter;

  ArticleDownloader(this._article, this._newsletter, this._fileDownloadRepository, this._fileDownloader, this._articleRepository);

  Future downloadArticle() async {
    var directory = path.join(
      "newsletter_" + _newsletter.id.toString(),
      _article.id.toString(),
    );

    var file = await _fileDownloadRepository.getFile(
      directory,
      _article.originalFilename ?? _article.id.toString(),
    );

    try {
      await _fileDownloader.downloadFile(_article.sourceUrl, file);

      _article.storagePath = file.path;
      _article.downloadDate = DateTime.now();
      _article.isDownloaded = true;

      await _articleRepository.saveArticle(_article);
    } catch (e) {
      print(e);

      if (await file.exists()) {
        await file.delete();
      }

      _article.isDownloaded = false;
    }
  }
}

class ArticleDownloaderFactory {
  final ArticleRepository _articleRepository;
  final FileDownloadRepository _fileDownloadRepository;
  final FileDownloader _fileDownloader;

  ArticleDownloaderFactory(this._fileDownloadRepository, this._fileDownloader, this._articleRepository);

  ArticleDownloader getNewArticleDownloaderInstance(Newsletter newsletter, Article article) {
    return new ArticleDownloader(article, newsletter, _fileDownloadRepository, _fileDownloader, _articleRepository);
  }
}
