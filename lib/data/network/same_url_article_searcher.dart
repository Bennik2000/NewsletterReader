import 'dart:convert';
import 'dart:io';

import 'package:newsletter_reader/data/filestorage/file_download_repository.dart';
import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/data/network/article_searcher.dart';
import 'package:newsletter_reader/util/util.dart';

class SameUrlArticleSearcher extends ArticleSearcher {
  final FileDownloadRepository fileDownloadRepository = new FileDownloadRepository();
  final Newsletter newsletter;

  SameUrlArticleSearcher(this.newsletter);

  @override
  Future<List<Article>> fetchNewArticles() async {
    if (newsletter.updateStrategy != UpdateStrategy.SameUrl) {
      throw new InvalidArgumentException();
    }

    var url = Uri.parse(newsletter.url);

    var request = await new HttpClient().getUrl(url);

    var response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      var article =
          new Article(isDownloaded: false, sourceUrl: url.toString(), newsletterId: newsletter.id, releaseDate: DateTime.now());

      return <Article>[article];
    }

    return <Article>[];

    var buffer = new StringBuffer();

    await response.transform(utf8.decoder).listen((d) {
      buffer.write(d);
    }).asFuture();

    var directory = "newsletter_" + newsletter.id.toString();

    var file = await fileDownloadRepository.getFile(directory, DateTime.now().toIso8601String());

    await file.writeAsString(buffer.toString());

    return null;
  }
}
