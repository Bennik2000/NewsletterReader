import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/data/network/article_searcher.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/util/util.dart';

import 'network_utils.dart';

class SameUrlArticleSearcher extends ArticleSearcher {
  final Newsletter _newsletter;
  final ArticleRepository _articleRepository;

  SameUrlArticleSearcher(this._newsletter, this._articleRepository);

  @override
  Future<List<Article>> fetchNewArticles() async {
    if (_newsletter.updateStrategy != UpdateStrategy.SameUrl) {
      throw new InvalidArgumentException();
    }

    Map<String, String> headers = {};

    var article = await _articleRepository.queryLastArticleOfNewsletter(_newsletter.id);
    if (article?.releaseDate != null) {
      headers.addAll({"If-Modified-Since": NetworkUtils.formatDateForHeader(article.releaseDate)});
    }

    var response = await http.get(
      // TODO: Use lower level http api. Now the complete article is downloaded only to test if a new article ist available.
      _newsletter.url,
      headers: headers,
    );

    String filename;

    if (response.headers.containsKey("content-disposition")) {
      var contentDisposition = response.headers["content-disposition"];

      RegExp regExp = new RegExp('filename[*]?=\\"(.*)\\"');
      var matches = regExp.allMatches(contentDisposition).toList();

      if (matches.length > 0) {
        filename = matches[0].group(1);
      }
    }

    if (response.statusCode == HttpStatus.ok) {
      var article = new Article(
        isDownloaded: false,
        sourceUrl: _newsletter.url.toString(),
        newsletterId: _newsletter.id,
        originalFilename: filename,
        releaseDate: DateTime.now(), // TODO: Read release Date from headers
      );

      return [article];
    }

    return [];
  }
}
