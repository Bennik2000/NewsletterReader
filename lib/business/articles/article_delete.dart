import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';

import 'article_download_delete.dart';

class ArticleDelete {
  final ArticleRepository _articleRepository;
  final ArticleDownloadDeleteFactory _articleDownloadDeleteFactory;
  final Article _article;

  ArticleDelete(this._articleRepository, this._articleDownloadDeleteFactory, this._article);

  Future deleteArticle() async {
    await _articleDownloadDeleteFactory.getNewArticleDownloadDeleteInstance(_article).deleteDownloadedArticle();
    await _articleRepository.deleteArticle(_article);
  }
}

class ArticleDeleteFactory {
  final ArticleRepository _articleRepository;
  final ArticleDownloadDeleteFactory _articleDownloadDeleteFactory;

  ArticleDeleteFactory(this._articleRepository, this._articleDownloadDeleteFactory);

  ArticleDelete getNewArticleDeleteInstance(Article article) {
    return new ArticleDelete(_articleRepository, _articleDownloadDeleteFactory, article);
  }
}
