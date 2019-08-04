import 'package:newsletter_reader/business/notification/notificator.dart';
import 'package:newsletter_reader/business/util/cancellation_token.dart';
import 'package:newsletter_reader/data/network/connectivity_information.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/data/repository/settings_repository.dart';
import 'package:newsletter_reader/model/newsletter.dart';

import 'article_downloader.dart';

class ArticleAutoDownloadManager {
  final NewsletterRepository newsletterRepository;
  final ArticleRepository articleRepository;
  final ArticleDownloaderFactory articleDownloaderFactory;
  final SettingsRepository settingsRepository;
  final Notificator notificator;

  ArticleAutoDownloadManager(this.newsletterRepository, this.articleRepository, this.articleDownloaderFactory, this.notificator,
      this.settingsRepository);

  Future tick(CancellationToken token) async {
    if (token.isCancelled) return;

    if (!await new ConnectivityInformation().isWifiAvailable()) {
      await _showNoWifiNotification();
      return;
    }

    var newsletters = await newsletterRepository.queryNewsletters();

    for (var newsletter in newsletters) {
      if (token.isCancelled) break;
      if (!newsletter.isAutoDownloadEnabled) continue;

      try {
        await downloadArticlesOfNewsletter(newsletter, token);
      } catch (e) {
        print(e);
        await _showErrorWhileDownloadingNotification(newsletter);
      }
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
      await _showArticleDownloadedNotification(newsletter);
    }
  }

  Future _showArticleDownloadedNotification(Newsletter newsletter) async {
    if (await settingsRepository.getNotifyOnNewArticlesDownloaded()) {
      await notificator.showSimpleTextNotification(
          "Beitrag heruntergeladen", "Es wurde ein neuer Beitrag für ${newsletter.name} heruntergeladen");
    }
  }

  Future _showNoWifiNotification() async {
    if (await settingsRepository.getNotifyOnNoWifi()) {
      await notificator.showSimpleTextNotification("Beiträge konnten nicht heruntergeladen werden",
          "Es konnten keine Beiträge heruntergeladen werden, da keine WLAN Verbindung bestand");
    }
  }

  Future _showErrorWhileDownloadingNotification(Newsletter newsletter) async {
    if (await settingsRepository.getNotifyOnUpdateError()) {
      await notificator.showSimpleTextNotification(
          "Beiträge von ${newsletter.name} konnten nicht heruntergeladen werden", "Es trat ein Fehler während des Downloads auf");
    }
  }
}
