import 'dart:io';

import 'package:newsletter_reader/business/util/date_template_filler.dart';
import 'package:newsletter_reader/business/util/string_template_filler.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/util/util.dart';

import 'article_searcher.dart';
import 'http_utils.dart';

///
/// This ArticleSearcher searches for new articles based on a url pattern. The
/// Url pattern can contain the current date and an increasing number
///
class PatternUrlArticleSearcher extends ArticleSearcher {
  final Newsletter _newsletter;
  final ArticleRepository _articleRepository;
  final int _initialFailCounter = 5;

  final _stringTemplateFiller = new StringTemplateFiller();
  final _dateTemplateFiller = new DateTemplateFiller();

  PatternUrlArticleSearcher(this._newsletter, this._articleRepository);

  @override
  Future fetchNewArticles() async {
    if (_newsletter.updateStrategy != UpdateStrategy.PatternUrl) {
      throw new InvalidArgumentException();
    }

    var newsletterArticles =
        await _articleRepository.queryArticlesOfNewsletter(_newsletter.id);

    var newArticles = <Article>[];

    // This implements a fail counter to allow gaps between the article urls
    var counter = 0;
    var failCounter = _initialFailCounter;

    while (true) {
      var url = generateUrl(_newsletter.url, counter++, DateTime.now());

      if (newsletterArticles.any((a) => a.sourceUrl == url)) continue;

      var headers = {
        HttpHeaders.ifModifiedSinceHeader:
            HttpUtils.formatDateForHeader(DateTime.now()),
      };

      var response =
          await HttpRequestHelper(url).withHeaders(headers).doGetRequest();

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.notModified) {

        var etag = HttpUtils.getEtagOrNull(headers);
        var filename = HttpUtils.getFilenameOfResponseHeader(response.headers);
        var date =
            HttpUtils.getCreationDateOrNull(response.headers) ?? DateTime.now();

        var article = new Article(
            releaseDate: date,
            sourceUrl: url,
            newsletterId: _newsletter.id,
            originalFilename: filename,
            documentEtag: etag);

        newArticles.add(article);

        failCounter = _initialFailCounter;
      } else if (--failCounter == 0) {
        // Break after n failed request
        break;
      }
    }

    return newArticles;
  }

  String generateUrl(String urlPattern, int counter, DateTime currentDate) {
    var url;

    url = _stringTemplateFiller.fillStringWithVariables(
      urlPattern,
      {"n": counter.toString()},
    );

    url = _dateTemplateFiller.fillStringWithDate(url, currentDate);
    return url;
  }
}
