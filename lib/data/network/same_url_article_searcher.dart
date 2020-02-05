import 'dart:io';
import 'package:newsletter_reader/data/network/article_searcher.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/util/util.dart';

import 'http_utils.dart';

class SameUrlArticleSearcher extends ArticleSearcher {
  final Newsletter _newsletter;
  final ArticleRepository _articleRepository;

  SameUrlArticleSearcher(this._newsletter, this._articleRepository);

  @override
  Future<List<Article>> fetchNewArticles() async {
    if (_newsletter.updateStrategy != UpdateStrategy.SameUrl) {
      throw new InvalidArgumentException();
    }

    var article =
        await _articleRepository.queryLastArticleOfNewsletter(_newsletter.id);

    var headers = _createRequestConditionalHeaders(article);

    var response = await HttpRequestHelper(_newsletter.url)
        .withHeaders(headers)
        .doGetRequest();

    // There is no new article if the request failed or the code was not ok (200)
    if(response.failed || response.statusCode != HttpStatus.ok) return [];

    var date = HttpUtils.getCreationDateOrNull(response.headers) ?? DateTime.now();

    // Decide if the article is newer
    if (article == null ||
        article.releaseDate == null ||
        article.releaseDate.isBefore(date)) {

      var filename = HttpUtils.getFilenameOfResponseHeader(response.headers);
      var etag = HttpUtils.getEtagOrNull(response.headers);

      var newArticle = new Article(
          isDownloaded: false,
          sourceUrl: _newsletter.url.toString(),
          newsletterId: _newsletter.id,
          originalFilename: filename,
          releaseDate: date,
          documentEtag: etag);

      return [newArticle];
    }

    return [];
  }

  Map<String, String> _createRequestConditionalHeaders(
    Article article,
  ) {
    if (article == null) return Map<String, String>();

    Map<String, String> headers = {};

    if (article.documentEtag != null) {
      headers.addAll({
        HttpHeaders.ifNoneMatchHeader: article.documentEtag,
      });
    }

    if (article.releaseDate != null) {
      headers.addAll({
        HttpHeaders.ifModifiedSinceHeader:
            HttpUtils.formatDateForHeader(article.releaseDate),
      });
    }

    return headers;
  }
}
