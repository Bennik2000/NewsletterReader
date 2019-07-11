import 'package:flutter/foundation.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/article_download_delete.dart';
import 'package:newsletter_reader/business/article_downloader.dart';
import 'package:newsletter_reader/data/model/model.dart';
import 'package:open_file/open_file.dart';

class ArticleState with ChangeNotifier {
  final Newsletter _newsletter;

  Article _article;
  Article get article => _article;
  set article(Article article) {
    _article = article;
    notifyListeners();
  }

  bool isDownloading;

  ArticleState(this._article, this._newsletter);

  void articleClicked() {
    if (article.storagePath != null && article.isDownloaded) {
      OpenFile.open(article.storagePath);
    }
  }

  Future downloadArticle() async {
    isDownloading = true;
    notifyListeners();

    await kiwi.Container()
        .resolve<ArticleDownloaderFactory>()
        .getNewArticleDownloaderInstance(_newsletter, article)
        .downloadArticle();

    isDownloading = false;
    notifyListeners();
  }

  Future deleteArticle() async {
    await kiwi.Container()
        .resolve<ArticleDownloadDeleteFactory>()
        .getNewArticleDownloadDeleteInstance(article)
        .deleteDownloadedArticle();

    notifyListeners();
  }
}
