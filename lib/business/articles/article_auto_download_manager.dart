import 'package:newsletter_reader/business/notification/notificator.dart';
import 'package:newsletter_reader/business/util/cancellation_token.dart';
import 'package:newsletter_reader/data/network/connectivity_information.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/newsletter.dart';

import 'article_downloader.dart';

class ArticleAutoDownloadManager {
  final NewsletterRepository newsletterRepository;
  final ArticleRepository articleRepository;
  final ArticleDownloaderFactory articleDownloaderFactory;
  final Notificator notificator;

  ArticleAutoDownloadManager(this.newsletterRepository, this.articleRepository, this.articleDownloaderFactory, this.notificator);

  Future tick(CancellationToken token) async {
    if (token.isCancelled) return;

    if (!await new ConnectivityInformation().isWifiAvailable()) return;

    var newsletters = await newsletterRepository.queryNewsletters();

    for (var newsletter in newsletters) {
      if (token.isCancelled) break;
      if (!newsletter.isAutoDownloadEnabled) continue;

      await downloadArticlesOfNewsletter(newsletter, token);
    }
  }

  Future downloadArticlesOfNewsletter(Newsletter newsletter, CancellationToken token) async {
    var downloadedCounter = 0;

    var articles = await articleRepository.queryNotDownloadedArticlesOfNewsletter(newsletter.id);

    for (var article in articles) {
      if (token.isCancelled) break;

      await articleDownloaderFactory.getNewArticleDownloaderInstance(newsletter, article).downloadArticle();

      downloadedCounter++;
    }

    if (downloadedCounter > 0) {
      notificator.showSimpleTextNotification(
          "Beitrag heruntergeladen", "Es wurde ein neuer Beitrag für ${newsletter.name} heruntergeladen");
    }
  }
}
