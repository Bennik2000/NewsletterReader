import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:newsletter_reader/business/util/date_template_filler.dart';
import 'package:newsletter_reader/business/util/string_template_filler.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/util/util.dart';

import 'article_searcher.dart';
import 'http_utils.dart';

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

    var newsletterArticles = await _articleRepository.queryArticlesOfNewsletter(_newsletter.id);

    var newArticles = <Article>[];

    var counter = 0;
    var failCounter = _initialFailCounter;

    while (true) {
      var url = generateUrl(_newsletter.url, counter++, DateTime.now());

      if (newsletterArticles.any((a) => a.sourceUrl == url)) continue;

      var headers = {
        "If-Modified-Since": HttpUtils.formatDateForHeader(DateTime.now()),
      };

      var response = await http.get(url, headers: headers);

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified) {
        var date = HttpUtils.getCreationDateOrNull(response.headers) ?? DateTime.now();

        newArticles.add(new Article(
            releaseDate: date,
            sourceUrl: url,
            newsletterId: _newsletter.id,
            originalFilename: HttpUtils.getFilenameOfResponseHeaders(response.headers)));

        failCounter = _initialFailCounter;
      } else if (--failCounter == 0) {
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
