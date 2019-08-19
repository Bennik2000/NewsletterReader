import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/business/articles/article_download_delete.dart';
import 'package:newsletter_reader/business/articles/article_downloader.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:open_file/open_file.dart';

class ArticleViewModel with ChangeNotifier {
  final Article article;
  final ArticleDownloader _articleDownloader;
  final ArticleDownloadDelete _articleDownloadDelete;

  bool get isDownloaded => article.isDownloaded;
  bool get isDownloading => _articleDownloader.isDownloading;

  ArticleViewModel(
    this.article,
    this._articleDownloader,
    this._articleDownloadDelete,
  );

  Future articleClicked() async {
    if (article.storagePath != null && article.isDownloaded) {
      await OpenFile.open(article.storagePath);
    }
  }

  Future downloadArticle() async {
    var downloadFuture = _articleDownloader.downloadArticle();

    notifyListeners();

    await downloadFuture;

    notifyListeners();
  }

  Future deleteDownloadedArticle() async {
    await _articleDownloadDelete.deleteDownloadedArticle();

    notifyListeners();
  }
}
